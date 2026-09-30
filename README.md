# PayX — payment-link platform starter

Configured from the supplied requirements:
- User site: `http://payxoffical.infinityfreeapp.com/`
- API: Vercel project named `api` (deploy the `backend/` folder as the Vercel project root)
- Database: Supabase PostgreSQL
- Provider: FamApi, shared provider account (server-side key only)
- Default link expiry: 10 minutes
- Platform fee: 2% (recorded for reporting; no split settlement/withdrawals are implemented)
- Admin login email: `sxo@gmail.com`
- Admin APK: PayX, package `com.payx.io`, WebView

## Important provider limitations
The FamApi reference supplied in chat documents order creation and live status lookup, but does not document a QR-image field, settlement, split payouts, or refunds. This build displays the returned UPI ID and offers copy/manual-pay instructions. It does not invent a QR or claim settlement is supported. Confirm these capabilities with FamApi before enabling real-money use.
The FamApi key previously shared in chat should be revoked and replaced. Never paste the replacement into source files or chat.

## Deploy
1. Supabase Project URL is prefilled in `backend/.env.example` as `https://qkpnvynwkxalmnhzmfvc.supabase.co`. Open Supabase SQL Editor and run `database/schema.sql`; source code cannot create tables in your account until you configure the server-side key in Vercel.
2. In Supabase Auth is not used for this starter's app login; PayX uses bcrypt password hashes and signed JWTs in the API. Keep the Supabase service-role key server-only.
3. Deploy `backend/` as a Vercel project. Set environment variables from `backend/.env.example`.
4. Add `https://payxoffical.infinityfreeapp.com` to `FRONTEND_ORIGIN` (use the exact origin matching the live site; InfinityFree may enforce HTTPS).
5. In `frontend/config.js`, set `API_BASE` to the deployed Vercel URL, e.g. `https://api-your-team.vercel.app`.
6. Upload the contents of `frontend/` to InfinityFree `htdocs/`. The supplied HTTP URL may redirect or may not support secure contexts; use HTTPS if available.
7. In Vercel set `ADMIN_BOOTSTRAP_SECRET` to a long random value, then register `sxo@gmail.com` through the public signup page. Run the one-time admin promotion SQL in `database/admin-bootstrap.sql` using the secret workflow described there. Remove/rotate the bootstrap secret after promoting.
8. Set `FAMAPI_KEY` to a newly generated, rotated FamApi key in Vercel environment variables. Never expose it to the browser.
9. Test with FamApi's approved test setup first: signup/login, create link, open checkout, create order, confirm UPI ID, verify pending/success/failed/expired states, test invalid key/network/rate-limit handling, verify fee calculation and webhook delivery if configured.
10. Build the APK using Android Studio from `admin-apk/`. Set `ADMIN_URL` in `MainActivity.java` to the actual hosted admin URL. Do not distribute a debug APK as a production release.

## Notes
- No actual payment can be tested without valid FamApi merchant/API credentials and provider authorization.
- Public checkout polls the server-side FamApi status endpoint. Browser redirect/callback is never treated as proof.
- The 2% platform fee is stored as a reporting value only. This code does not collect an extra fee, split funds, or settle balances.
- Email notification delivery requires SMTP environment variables. Without them, notifications remain in-app/database only.
- This is an integration starter, not a certified payment aggregator. Obtain required legal, tax, privacy, security, and provider approvals before processing public payments.
