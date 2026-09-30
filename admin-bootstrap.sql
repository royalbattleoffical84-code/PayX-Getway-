-- Run only after sxo@gmail.com has registered through the PayX signup page.
-- Confirm the email is yours before executing.
update public.users set role='admin' where lower(email)='sxo@gmail.com';
-- Verify exactly one intended admin exists:
select id,email,role,status from public.users where role='admin';
-- Remove ADMIN_BOOTSTRAP_SECRET from Vercel after setup. No public bootstrap endpoint is enabled.
