# SGS Cashier — Unified Payment & Voucher System

A web-based cashier terminal for **Saudi Ground Services (SGS)** that standardises payment transactions at airport counters (check-in, excess baggage, seat selection, lounge access, etc.) through a unified **payment terminal** — cards, mobile wallets, cash, and online / BNPL methods — with real-time automated voucher generation and dynamic airline-specific pricing.

Built around the SGS brand palette (green & white) matching [www.saudiags.com](https://www.saudiags.com).

---

## Features

### Authentication
- **Microsoft Entra ID (Azure AD) sign-in** scoped to `@saudiags.com` corporate emails only
- **Two MFA methods** offered after email entry:
  - **WhatsApp OTP** — 6-digit code delivered to the user's registered number
  - **Microsoft Authenticator** — push notification with the modern number-match prompt
- Role-based access (Admin / Agent)

### Roles & Access Levels

Each account type is assigned an **access level (L1–L4)** that determines what they can and can't do. The role badge in the top-right is **clickable** — it opens a detailed permissions modal. Admins and Account Managers also get an **🔐 Access Control** tab showing the full permission matrix.

| Level | Role | Email | Summary |
|-------|------|-------|---------|
| **L4** | **Admin** | `admin@saudiags.com` | Full access — manage users, edit prices directly, approve requests, view everything |
| **L3** | **Account Manager** | `am@saudiags.com`, `accountmanager@saudiags.com` (or `am.*@saudiags.com`) | Review & approve airline price-change requests; read access to pricing and transactions |
| **L2** | **Airline Partner** | `<anyone>@<airline-domain>` e.g. `manager@saudia.com`, `pricing@emirates.com` | Self-service portal scoped to **their own** airline; propose prices that go through approval |
| **L1** | **Agent (Cashier)** | `agent@saudiags.com` (or any other `@saudiags.com`) | Cashier interface — process payments and issue vouchers |

#### Permission Matrix

| Permission | Admin (L4) | Account Mgr (L3) | Airline (L2) | Agent (L1) |
|-----------|:---:|:---:|:---:|:---:|
| Process payments | ✕ | ✕ | ✕ | ✓ |
| Generate / print vouchers | ✕ | ✕ | ✕ | ✓ |
| View all airline prices | ✓ | ✓ | own only | ✓ |
| Edit prices directly | ✓ | ✕ | ✕ | ✕ |
| Submit price change request | ✕ | ✕ | ✓ | ✕ |
| Approve / reject price requests | 👁 oversight | ✓ | ✕ | ✕ |
| View operations dashboard | ✓ | ✓ | ✕ | ✕ |
| View all transactions log | ✓ | ✓ | ✕ | ✕ |
| Export reports / data | ✓ | ✓ | own only | ✕ |
| Manage user accounts & roles | ✓ | ✕ | ✕ | ✕ |
| Configure system settings | ✓ | ✕ | ✕ | ✕ |
| View access permissions matrix | ✓ | ✓ | ✕ | ✕ |

### Price Change Approval Workflow
1. **Airline** signs in (via their corporate domain) → sees only their airline's services and prices
2. They adjust one or more prices → click **Submit for Approval** → request goes to **Pending** state
3. **Account Manager** opens the **Approval Queue** → sees the request with a side-by-side diff (current → proposed, with % change). Admin can open the same queue **read-only for oversight** but cannot approve/reject.
4. The Account Manager optionally adds a review note → clicks **✓ Approve** or **✕ Reject**
5. On approval: live `PRICES` are updated immediately; cashier terminal uses new prices on the next transaction
6. On rejection: the airline sees the rejection note in their "My Recent Requests" history

A pending-count badge shows on the Approval Queue tab. The Price Management table marks airlines with pending changes (`pending review` tag next to their name).

### Cashier Terminal (Agent)
- Select **airline** from a regionally-grouped dropdown of **45 carriers** that operate at SGS-handled Saudi airports (Saudia, Flynas, Flyadeal, Emirates, flydubai, Etihad, Qatar Airways, Turkish Airlines, Lufthansa, British Airways, Singapore Airlines, Cathay Pacific, ANA, Japan Airlines, Air India, IndiGo, PIA, Ethiopian, EgyptAir, American, Delta, United, and more) — logo chip appears on selection
- Select **service** (excess baggage, sports equipment, priority check-in, lounge pass, seat selection)
- Enter **quantity / weight, flight number, passenger name**
- Auto-calculation: Subtotal → **Service Charge** → **VAT 15% (KSA standard)** → Total
- **Payment** button opens a dedicated method page: **Cash**, cards (Visa, Mastercard, Amex, mada), mobile wallets (Apple Pay, Google Pay, Samsung Pay, STC Pay), and online / BNPL (PayPal, Klarna, Alipay, WeChat Pay, UPI) — NFC tap-zone simulation for cards/wallets, payment-link (4-hour auto-cancel) for online
- Voucher generation with airline + SGS logos, full breakdown, and scannable QR code
- Print / email / close actions on voucher

### Admin Console
- **📊 Dashboard** — transaction count, total revenue (incl. VAT), VAT collected, revenue-per-airline bar chart
- **💰 Price Management** — editable price table per airline; changes take effect immediately at the cashier terminal (matches the self-service portal in the spec)
- **📋 Transactions** — chronological log of every payment with airline, service, passenger, amounts, cashier email; filter by **date range, airline, and cashier / user**; SAR totals are derived from the breakdown so the log always reconciles (robust against legacy records)

### Compliance
- **VAT 15%** applied per KSA / ZATCA standard
- Voucher itemises Subtotal + VAT + Total Paid
- Cashier email captured on every transaction (audit trail)
- VAT Registration footer (placeholder: `300012345600003`)

---

## Demo Accounts

Four shortcut buttons on the login page:

| Demo button | Email | Role |
|-------------|-------|------|
| **Admin** | `admin@saudiags.com` | admin |
| **Account Mgr** | `am@saudiags.com` | account_manager |
| **Agent** | `agent@saudiags.com` | agent |
| **Airline** | `manager@saudia.com` | airline (Saudia) |

For any other airline, sign in manually with that airline's domain — e.g. `pricing@emirates.com`, `manager@flynas.com`, `ops@qatarairways.com`. The system maps the domain to the airline's IATA code automatically.

All accounts go through the same MFA flow. Use either WhatsApp (OTP is shown on screen for demo) or Microsoft Authenticator (number-match shown on screen, three buttons appear — tap the matching one).

### End-to-end demo flow
1. Sign in as **Airline** (manager@saudia.com) → adjust a few prices → Submit for Approval
2. Sign out → sign in as **Account Mgr** (am@saudiags.com) → open Approval Queue → see Saudia's request → click Approve
3. Sign out → sign in as **Agent** (agent@saudiags.com) → process a Saudia transaction → prices reflect the approved values

---

## How to Run

This is a **single-file static prototype** — no build, no server required.

1. Double-click `cashier.html` (or right-click → Open With → browser)
2. Or drag the file into Chrome / Edge / Firefox
3. Sign in with one of the demo accounts

Data (prices, transactions) is persisted to **localStorage** in your browser, so admin edits and agent transactions survive page refreshes.

---

## Airline Coverage

**45 carriers** grouped into 6 regions, covering virtually every airline operating at SGS-handled Saudi airports:

| Region | Carriers |
|--------|----------|
| **Saudi Arabia & GCC** | Saudia, Flynas, Flyadeal, Emirates, flydubai, Etihad, Air Arabia, Qatar Airways, Oman Air, Gulf Air, Kuwait Airways, Jazeera |
| **Middle East & Africa** | MEA, Royal Jordanian, EgyptAir, Royal Air Maroc, Ethiopian, Kenya Airways |
| **Turkey & Europe** | Turkish, Pegasus, British Airways, Lufthansa, Air France, KLM, Swiss, Iberia, ITA |
| **South Asia** | Air India, IndiGo, SpiceJet, PIA, SriLankan, Biman |
| **East & Southeast Asia** | Singapore, Cathay, Thai, Malaysia, Garuda, Philippine, Korean Air, ANA, JAL, China Southern, Air China, China Eastern |
| **Americas** | American, Delta, United |

### Logo sources
- **SGS**: [Saudi Gazette](https://saudigazette.com.sa/uploads/images/2018/04/18/808590.png)
- **Saudia, Flynas, Emirates, Qatar Airways, Turkish Airlines**: [Wikimedia Commons](https://commons.wikimedia.org/) (free-licensed)
- **All other carriers**: [Airhex CDN](https://airhex.com) (standard service used by Skyscanner, Kayak, and other booking platforms)

All logos load with graceful `onerror` fallbacks.

### Pricing model
Real ground-handling prices are **commercially negotiated per-carrier contract** and not publicly published on airline websites. The default prices in the system use a **4-tier model** as a realistic baseline:

| Tier | Excess Baggage | Sports Eq. | Priority | Lounge | Seat |
|------|----------------|------------|----------|--------|------|
| **Premium** (EK, EY, QR, SQ, CX, LH, BA, AF, KL, LX, IB, KE, NH, JL, TK) | 95 SAR | 260 | 75 | 220 | 65 |
| **Major** (SV, RJ, MS, GF, WY, KU, AI, MH, TG, GA, PR, CZ, CA, MU, ET, KQ, ME, AT, AZ, BG, UL, PK) | 75 SAR | 210 | 55 | 160 | 45 |
| **LCC** (XY, F3, FZ, G9, PC, 6E, SG, J9) | 60 SAR | 180 | 40 | 120 | 30 |
| **North American** (AA, DL, UA) | 90 SAR | 250 | 70 | 200 | 60 |

**Admin should adjust these values via the Price Management UI to match SGS's actual contracted rates** — that's exactly what the self-service portal is designed for.

---

## Brand Palette

Matches the SGS corporate identity (`www.saudiags.com`):

| Token | Hex | Use |
|-------|-----|-----|
| `--sgs-green` | `#006C35` | Primary brand, buttons, headers |
| `--sgs-green-dark` | `#00471f` | Hover states, gradients |
| `--sgs-green-light` | `#e8f4ee` | Backgrounds, accents |
| `--sgs-gold` | `#C9A24B` | Highlight accents |
| `--sgs-grey` | `#5a6b7b` | Secondary text |
| `--sgs-bg` | `#f5f7f8` | Page background |

---

## Going to Production

### 1. Enable real Microsoft sign-in
Open `cashier.html` and locate the config block at the top of `<script>`:

```js
const USE_REAL_MSAL = false;        // → set to true
const MSAL_CONFIG = {
  auth: {
    clientId: "YOUR-AZURE-CLIENT-ID",
    authority: "https://login.microsoftonline.com/YOUR-TENANT-ID",
    redirectUri: window.location.href
  }
};
```

Steps:
1. Go to **Azure Portal → Microsoft Entra ID → App registrations → New registration**
2. Set the platform to **Single-page application (SPA)** and add this page's URL as a redirect URI
3. Copy the **Application (client) ID** and **Directory (tenant) ID** into the config
4. Enforce **Conditional Access** policy requiring Microsoft Authenticator MFA for the app
5. Restrict to the `saudiags.com` tenant

The MSAL library (`msal-browser` 2.38) is already loaded from CDN.

### 2. Wire up real WhatsApp OTP
The demo generates a 6-digit code locally and displays it. For production, replace the `sendWaOtp` function with a call to a WhatsApp Business API provider:

- **Meta WhatsApp Business Cloud API** (official): https://developers.facebook.com/docs/whatsapp
- **Twilio WhatsApp API**
- **Unifonic** (popular in KSA)
- **MessageBird**

Typical flow: your backend receives `{ phone }`, generates an OTP, sends it via the API, and stores `{ phone, hashedOtp, expiresAt }`. The client then POSTs `{ phone, otp }` to verify.

### 3. Replace softPOS simulation
Hook `tapZone.click` into your softPOS SDK. KSA / regional providers:

- **Geidea softPOS**
- **HyperPay Tap to Phone**
- **PayTabs softPOS**
- **Visa Tap to Phone**
- **Mastercard Cloud Commerce**

### 4. Persist server-side
Replace `localStorage` for `PRICES` and `TRANSACTIONS` with a backend (REST / GraphQL) so multiple terminals share state and admin pricing updates propagate in real time.

---

## File Structure

```
SGS Project/
├── Cahair project SGS.md.txt   # Original project brief
├── cashier.html                # Single-page application (HTML + CSS + JS)
└── README.md                   # This file
```

---

## Tech Stack

- **Vanilla HTML / CSS / JavaScript** — zero build step
- **MSAL.js 2.38** (Microsoft Authentication Library) — loaded from CDN
- **QRCode.js** — voucher QR code generation, from CDN
- **localStorage** — client-side persistence for prototype

---

## Roadmap

### v1.x — Enhancements (in progress)

#### Latest additions (round 3)
- [x] **Terminology: "softPOS" → "Payment"** — the cashier CTA, terminal panel, header, and access descriptions now read "Payment" (the underlying softPOS/Tap-to-Phone SDK is still the production integration target)
- [x] **Terminology: "SGS Commission" → "Service Charge"** — every customer- and operator-facing label (summary, voucher, pay page, price table, CSV export) now says "Service Charge"
- [x] **Removed the 2 SAR FX buffer** — foreign-currency conversion now uses the straight rate with no surcharge and no buffer line on the invoice/voucher
- [x] **Admin = oversight-only on price approvals** — only the Account Manager can approve/reject airline price requests; Admin sees the queue read-only with an oversight banner (handlers hardened too)
- [x] **Transactions: per-airline _per-user_ filter** — added a Cashier / User filter alongside date + airline
- [x] **Transaction log amount integrity** — the SAR total is now derived from the breakdown (`subtotal + service charge + VAT`) via `sarTotal()`, so the log always reconciles even for legacy records that stored `total` in a foreign currency
- [x] **Single-screen payment** — removed the separate inline "Payment Terminal" panel; the agent now picks a method **and** completes the tap / cash / online payment on one dedicated full-screen page (method selection → complete payment as two steps)
- [x] **Agent cancellation & direct refund** — from "My Day", agents can **cancel an unpaid payment link** (before the 4-hour auto-cancel) and **process a refund directly** on a completed payment (10% deduction, justification + note required, recorded for admin oversight) — no airline-approval step for agent refunds

#### Latest additions (round 2)
- [x] **Refund flow** — Agent can refund a completed transaction with required justification (dropdown) and note; 10% deduction applied; refund tracked
- [x] **Agent's "My Day" view** — completed + refunded transactions for today with refund actions; gross/refunded/net stats for shift-end reconciliation
- [x] **Airline-specific dashboard** — when an airline user logs in, the portal shows *their* revenue snapshot (excluding VAT, since VAT goes to ZATCA) and a service breakdown
- [x] **Customer currency on voucher** — paying customer sees the voucher in their selected currency; agent/admin records always stored and displayed in SAR
- [x] **PayPal + global payment methods** — added Amex, PayPal, Klarna (BNPL), Alipay, WeChat Pay, UPI alongside the existing Cash/Visa/Mada/MC/Apple/Google/Samsung/STC Pay
- [x] **Auto-cancellation after 4 hours** — pending payment requests (e.g. PayPal links sent to passenger) auto-cancel if unpaid after 4 hours; background scan runs every 60s
- [x] **Admin: Refunds & Cancellations view** — full history with stats (count, refunded amount, SGS deduction earned, lost revenue) and filters
- [x] **Passenger self-service interface** — *new entry point* on the login screen ("Self-Service Payment →"); passengers can select airline/service, enter PNR + contact details, pay in any currency; voucher emailed to passenger + airline notified
- [x] **Configurable airline portal** — admin can disable a specific airline's price-update portal via a checkbox in Price Management
- [x] **Send payment link** — for online methods, agent can generate a payment link the customer pays later (creates a PENDING transaction; auto-cancels after 4h)
- [x] **Tightened access control** — Refunds & Cancellations history is *admin-only* (Account Manager doesn't see it, per spec)

#### Round 1 features

- [x] Multiple payment options — Cash, Visa, Mastercard, Mada, Apple Pay, Google Pay, Samsung Pay, STC Pay
- [x] Dynamic airline logo preview on login when email domain is recognized
- [x] Admin can configure **service charge %** per airline; applied to total and shown on voucher
- [x] Date-range CSV export of all transactions
- [x] Currency converter (USD, EUR, GBP, AED, EGP, INR, PKR, TRY, KWD → SAR) — straight-rate conversion, no FX buffer
- [x] Bilingual UI (English / العربية) with RTL support for Arabic
- [x] Resized & polished login page
- [x] SGS dashboard with per-airline income breakdown (incl. and excl. VAT)
- [x] Voucher emailed to passenger (button) — backend SMTP needed for real sending
- [x] All 45 airline logos sourced from web (Wikimedia + Airhex)
- [x] Airline-scoped post-login dashboard (each airline sees only their own numbers, all without VAT)

### Deferred to backend integration phase

- [ ] **Self-service passenger flow** — replace the agent with a passenger-facing kiosk / mobile flow; capture extended passenger details (ID, contact email, contact phone, frequent flyer no.)
- [ ] **Monthly automated finance reports** — auto-email income summary + ZATCA-formatted VAT report to SGS finance team
- [ ] **Auto-email voucher to airline** for every payment (not just to the passenger)
- [ ] **Live FX rates** from a real API (e.g. SAMA, exchangerate.host) instead of hardcoded fallbacks
- [ ] **Real WhatsApp Business API integration** for OTP (Meta / Twilio / Unifonic)
- [ ] **Real Microsoft Entra ID** sign-in (MSAL is wired — just needs Azure tenant config)
- [ ] **Real softPOS SDK** (Geidea / HyperPay / PayTabs / Visa Tap to Phone)
- [ ] **Multi-terminal sync** — replace localStorage with server-side state so price updates and transactions propagate across all cashier devices in real time

### v3 — Operational Extensions

- [ ] **Mobile app** for cashiers (iOS/Android wrapper around the same flow)
- [ ] **Integration with airline DCS / check-in systems** — auto-fetch passenger details from PNR
- [ ] **Real-time SGS ops dashboard** with terminal status, queue length, per-airport metrics
- [ ] **ZATCA Phase 2 (Fatoora) e-invoicing** — full e-invoice generation with cryptographic stamp
- [ ] **Loyalty / FFP integration** — earn miles for ancillary purchases
- [ ] **Role administration UI** — admin can create/edit/disable user accounts in-app
- [ ] **Audit log** for all admin actions and approvals (regulator-friendly)
- [ ] **Refund / void workflow** for incorrect transactions
- [ ] **Reporting suite** — daily/weekly/monthly PDF reports by airline, service, terminal

---

*Saudi Ground Services Co. — Ground Handling Excellence*
