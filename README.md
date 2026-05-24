# Airport Permits — Static HTML Demo

Single-file SPA for the Riyadh Airports permit workflow (Arabic UI). Deployable to GitHub Pages, Netlify, or any static host. No build step.

## Files

| File | Purpose |
|---|---|
| `index.html` | **Demo build** — six pre-seeded test accounts. Login credentials shown on the login page. Use this when you want anyone with the link to be able to try the app. |
| `secure.html` | **Strict build** — no preset accounts. First visitor is forced through an admin bootstrap (sets the password themselves). Use this when you want only invited people to access the app. |
| `.nojekyll` | Tells GitHub Pages to serve files raw, no Jekyll processing. |

## Deploy to GitHub Pages

1. **Create a new repo** on github.com (public or private; private repos need GitHub Pro for Pages).
2. **Upload everything in this folder** — drag-and-drop on the repo page, or:
   ```bash
   git init
   git add .
   git commit -m "Airport permits v3.2"
   git branch -M main
   git remote add origin https://github.com/<YOUR_USER>/<YOUR_REPO>.git
   git push -u origin main
   ```
3. **Enable Pages**: Repo → Settings → Pages → Source: `Deploy from a branch` → Branch: `main` / Folder: `/ (root)` → Save.
4. Wait ~30 seconds. Your app is live at `https://<YOUR_USER>.github.io/<YOUR_REPO>/`.

## Login credentials (demo build only)

The `index.html` (demo) loads six seed accounts on first visit. Credentials are also displayed on the login page itself.

| Username | Password | Role |
|---|---|---|
| `admin` | `AdminPass1` | مدير النظام |
| `operator1` | `OperPass1` | موظف تصاريح |
| `customs` | `CustPass1` | مندوب الجمارك |
| `security` | `SecPass1` | مندوب الأمن العام |
| `gaca` | `GacaPass1` | هيئة الطيران المدني |
| `user1` | `UserPass1` | مستخدم |

Passwords are stored as PBKDF2-SHA-256 hashes (200,000 iterations, per-user 16-byte salt) — the cleartext appears only on the login hint, not in the auth path.

## Reset the app

All data lives in browser `localStorage` under key `rac_airport_permits_v3_1`. To wipe:

- **In the browser:** DevTools → Application → Local Storage → delete the key → reload
- **Or:** open the page in an Incognito/Private window

## Security model (what the static build does and doesn't do)

**Does:**
- PBKDF2-SHA-256 password hashing with per-user salts (200k iterations)
- Idle (30 min) and absolute (8 h) session expiry
- Login rate limiting (5 fails → 15 min lockout per username)
- HMAC-SHA-256 signed QR payloads
- Hash-chained audit log (each approval links to the previous via SHA-256)
- Strict Content-Security-Policy, Subresource Integrity on CDN scripts
- All inline `onclick` removed (event delegation)
- Input validation (Saudi phone format, national-ID digit length, etc.)
- `crypto.randomUUID` for IDs

**Does NOT (architectural limit of any client-only app):**
- Stop a user with DevTools from editing `localStorage` directly to forge approvals
- Run authorization on a server (every check is in JS the user controls)
- Encrypt data at rest (localStorage is unencrypted)
- Survive a browser reset

For real production use (e.g., guards actually trusting the QR codes), the server-backed version under [`airport-permit-server/`](../airport-permit-server) puts all authorization behind an API.

## Notes for production

If you publish the demo build publicly, **delete the seed accounts** before going live:
1. Open `index.html` in a text editor
2. Set `const DEFAULT_USERS = [];`
3. Delete the `<div class="login-hint">` block in `renderLogin()`
4. Or just use `secure.html` instead

---

تنبيه: هذا التطبيق يعمل بالكامل في المتصفح وبيانات الاعتماد للعرض فقط. للاستخدام الفعلي يجب نقل المنطق إلى خادم.
