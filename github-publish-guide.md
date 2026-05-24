# Publish the Permit System (with Logo Files) to GitHub Pages

Complete guide for uploading the HTML file **plus the two logo PNGs as separate image files** in your GitHub repository.

**Result:** A live URL like `https://YOUR-USERNAME.github.io/airport-permit-system/` with the official RAC logo displayed on every page.

---

## The 3 files you'll upload

| File | Purpose |
|---|---|
| `index.html` | The permit system itself |
| `logo-color.png` | Full color logo (used on login screen + printed permits) |
| `logo-white.png` | White version of logo (used on the dark blue topbar) |

> **Important:** The HTML references the logos as `src="logo-color.png"` and `src="logo-white.png"` — they **must** be in the **same folder** as `index.html`, with **exactly those filenames** (case-sensitive on GitHub).

---

## Before you start

- A **GitHub account** (free — sign up at github.com if needed)
- All three files downloaded to your computer

---

## Step 1 — Create the repository

1. Go to **https://github.com/new**
2. Fill in:
   - **Repository name:** `airport-permit-system`
   - Select **Public**
   - Tick **"Add a README file"**
3. Click the green **"Create repository"** button

---

## Step 2 — Upload all three files together

1. On your new repository page, click **"Add file"** → **"Upload files"**
2. Drag **all three files** (`airport-permit-v4-RAC-branded.html`, `logo-color.png`, `logo-white.png`) into the upload area at the same time
3. Scroll down → click **"Commit changes"**

You should now see all three files listed in the repo.

---

## Step 3 — Rename the HTML to `index.html`

1. Click on `airport-permit-v4-RAC-branded.html`
2. Click the **pencil icon** (Edit) at top right
3. At the top of the editor, change the filename to exactly: **`index.html`**
4. Scroll down → click **"Commit changes"**

> **Why?** GitHub Pages serves `index.html` automatically at the root URL. Without renaming, your URL would be `…/airport-permit-v4-RAC-branded.html` instead of just `…/`.

**Do NOT rename the logo files** — they must stay as `logo-color.png` and `logo-white.png` because the HTML references those exact names.

---

## Step 4 — Turn on GitHub Pages

1. In your repository, click the **"Settings"** tab (top right)
2. In the left sidebar, click **"Pages"**
3. Under **"Build and deployment"**:
   - **Source:** select `Deploy from a branch`
   - **Branch:** select `main`, folder `/ (root)`
4. Click **"Save"**

Wait about **1–2 minutes**.

---

## Step 5 — Visit your live site

1. Refresh the Pages settings page
2. You'll see: **"Your site is live at https://YOUR-USERNAME.github.io/airport-permit-system/"**
3. Click the URL — your branded permit system is live 🎉

---

## Verifying the logo loads correctly

When the site opens:

✅ **Login screen** — the full color logo with both Arabic and English wordmarks should appear above the login form
✅ **Topbar (after login)** — the white version of the logo should appear in the dark blue bar at the top
✅ **Printed permit** — when you print/save an issued permit as PDF, the color logo should appear in the header

**If you see broken image icons (📷) instead of the logo:**
- Open browser DevTools (F12) → Console tab → look for 404 errors
- Most likely cause: the logo filename is wrong (case sensitive — `Logo-Color.PNG` ≠ `logo-color.png`)
- Fix: rename the file in GitHub back to lowercase exactly as `logo-color.png` and `logo-white.png`

---

## Updating files later

**To replace the logo:**
1. Open the repo on GitHub → click `logo-color.png` (or `logo-white.png`)
2. Click the trash icon to delete it
3. Upload a new file with the **exact same filename**
4. Site refreshes within ~1 minute

**To edit the HTML:**
1. Click `index.html` → pencil icon → paste new content → Commit
2. Site refreshes within ~1 minute

---

## Repository file structure (what it should look like)

```
airport-permit-system/
├── README.md          ← optional, auto-generated
├── index.html         ← the permit system
├── logo-color.png     ← full color logo
└── logo-white.png     ← white logo for dark topbar
```

---

## Troubleshooting

| Problem | Fix |
|---|---|
| 404 on first load | Wait 2 more minutes, then hard-refresh (Ctrl+Shift+R / Cmd+Shift+R) |
| Broken image icons where logos should be | Filenames are case-sensitive — must be exactly `logo-color.png` and `logo-white.png` |
| Logo appears on login but not topbar (or vice versa) | One of the two PNGs failed to upload — check the repo has both files |
| Site is live but Arabic looks broken | HTML file didn't upload fully — re-upload and verify size (~92 KB) |

---

## Why use external files instead of embedding?

✅ **Smaller HTML file** (92 KB vs 230 KB) → faster initial load
✅ **Browser caches the logo separately** → repeat visits are instant
✅ **Easy to swap the logo** without editing HTML
✅ **Standard web practice** → easier for developers to maintain later

---

## What this URL is good for

✅ Sharing a working demo with the board, CEO, and stakeholders
✅ Letting reviewers click through the system on their own devices
✅ Quick iterations — push edits and see the live site update in seconds

❌ Not for storing real production permit data (browser-local storage, no shared database)
❌ Not for sensitive PII (the URL is public)

When you're ready for shared production data, the next step is a backend — Supabase or Firebase can replace `localStorage` with a real database while keeping this same frontend.
