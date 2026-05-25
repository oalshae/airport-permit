# Builds "distance lookup.csv" via OSRM. One source -> all destinations per call.
# Output schema:  from_en,to_en,km
$ErrorActionPreference = 'Stop'
$folder = 'C:/Users/Othman Alshaya/Downloads/Digitalpay map'
$htmlPath = Join-Path $folder 'saudi_arabia_employees_map.html'
$csvPath  = Join-Path $folder 'distance lookup.csv'
$logPath  = Join-Path $folder '_osrm_progress.log'

# 1. Pull MAP_DATA out of the HTML
$mapLineNum = (Select-String -Path $htmlPath -Pattern '^window\.MAP_DATA' | Select-Object -First 1).LineNumber
$line = Get-Content $htmlPath -TotalCount $mapLineNum | Select-Object -Last 1
$json = $line -replace '^window\.MAP_DATA\s*=\s*','' -replace ';\s*$',''
$data = $json | ConvertFrom-Json
$cities = $data.cities
"Cities: $($cities.Count)" | Tee-Object -FilePath $logPath -Append

# 2. Build the shared coordinate list for OSRM
$coordsList = $cities | ForEach-Object { '{0},{1}' -f $_.lng, $_.lat }
$coordsStr = $coordsList -join ';'

# 3. Write CSV header
'from_en,to_en,km' | Out-File -FilePath $csvPath -Encoding UTF8

$baseUrl = 'http://router.project-osrm.org/table/v1/driving'
$sb = [System.Text.StringBuilder]::new()
$saveEvery = 10
$start = Get-Date

for ($i = 0; $i -lt $cities.Count; $i++) {
  $from = $cities[$i].name_en
  $url = "$baseUrl/$coordsStr" + "?sources=$i&annotations=distance"
  $attempt = 0; $ok = $false
  while (-not $ok -and $attempt -lt 4) {
    try {
      $resp = Invoke-RestMethod -Uri $url -TimeoutSec 60
      if ($resp.code -ne 'Ok') { throw "OSRM returned code=$($resp.code)" }
      $row = $resp.distances[0]
      $ok = $true
    } catch {
      $attempt++
      $wait = [Math]::Min(30, 2 * $attempt)
      "  retry $attempt for $from in ${wait}s: $_" | Tee-Object -FilePath $logPath -Append
      Start-Sleep -Seconds $wait
    }
  }
  if (-not $ok) {
    "  FAILED $from - skipping" | Tee-Object -FilePath $logPath -Append
    continue
  }

  for ($j = 0; $j -lt $cities.Count; $j++) {
    if ($i -eq $j) { continue }
    $meters = $row[$j]
    if ($null -eq $meters) { continue }
    $km = [Math]::Round([double]$meters / 1000.0, 1)
    $to = $cities[$j].name_en
    # Escape commas in names
    if ($from -match ',') { $fromCsv = '"' + $from.Replace('"', '""') + '"' } else { $fromCsv = $from }
    if ($to   -match ',') { $toCsv   = '"' + $to.Replace('"',   '""') + '"' } else { $toCsv   = $to   }
    [void]$sb.AppendLine("$fromCsv,$toCsv,$km")
  }

  if ((($i+1) % $saveEvery) -eq 0 -or $i -eq ($cities.Count - 1)) {
    Add-Content -Path $csvPath -Value $sb.ToString().TrimEnd() -Encoding UTF8
    $sb.Clear() | Out-Null
    $elapsed = (Get-Date) - $start
    $pct = [Math]::Round((($i+1) / $cities.Count) * 100, 1)
    "  [$($i+1)/$($cities.Count)  $pct%]  $from  elapsed=$($elapsed.ToString('mm\:ss'))" | Tee-Object -FilePath $logPath -Append
  }
  Start-Sleep -Milliseconds 250  # be polite to the public demo
}

"DONE. CSV at: $csvPath" | Tee-Object -FilePath $logPath -Append
$rowCount = (Get-Content $csvPath | Measure-Object -Line).Lines - 1
"Rows: $rowCount (expected ~$($cities.Count * ($cities.Count - 1)))" | Tee-Object -FilePath $logPath -Append
