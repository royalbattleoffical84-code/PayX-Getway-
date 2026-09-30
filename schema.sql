create extension if not exists pgcrypto;
create table if not exists public.users (
 id uuid primary key,
 email text unique,
 mobile text unique,
 full_name text not null,
 password_hash text not null,
 role text not null default 'merchant' check(role in ('merchant','admin')),
 status text not null default 'active' check(status in ('active','suspended')),
 business_name text,
 checkout_note text,
 support_email text,
 created_at timestamptz not null default now(),
 check (email is not null or mobile is not null)
);
create table if not exists public.plans (
 id uuid primary key,
 name text not null,
 price numeric(12,2) not null check(price>0),
 validity_days integer not null check(validity_days>0),
 link_limit integer not null check(link_limit>0),
 api_access boolean not null default false,
 active boolean not null default true,
 created_at timestamptz not null default now()
);
create table if not exists public.subscriptions (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references public.users(id),
 plan_id uuid not null references public.plans(id),
 status text not null default 'active' check(status in ('active','expired','cancelled','pending')),
 starts_at timestamptz not null default now(),
 expires_at timestamptz not null,
 created_at timestamptz not null default now()
);
create table if not exists public.payment_links (
 id uuid primary key,
 user_id uuid not null references public.users(id),
 slug text not null unique,
 title text not null,
 description text,
 amount numeric(12,2) not null check(amount>=1),
 currency text not null default 'INR',
 status text not null default 'active' check(status in ('active','disabled','expired')),
 expires_at timestamptz not null,
 platform_fee_percent numeric(5,2) not null default 2,
 metadata jsonb not null default '{}'::jsonb,
 created_at timestamptz not null default now()
);
create table if not exists public.payment_orders (
 id uuid primary key,
 link_id uuid not null references public.payment_links(id),
 user_id uuid not null references public.users(id),
 provider_order_id text not null unique,
 amount numeric(12,2) not null,
 status text not null default 'pending' check(status in ('pending','success','failed','expired','refunded')),
 upi_id text,
 platform_fee numeric(12,2) not null default 0,
 created_at timestamptz not null default now(),
 checked_at timestamptz,
 paid_at timestamptz
);
create table if not exists public.api_keys (
 id uuid primary key,
 user_id uuid not null references public.users(id),
 key_hash text not null unique,
 label text not null default 'API key',
 created_at timestamptz not null default now(),
 last_used_at timestamptz,
 revoked_at timestamptz
);
create table if not exists public.audit_logs (
 id uuid primary key default gen_random_uuid(),
 user_id uuid references public.users(id),
 action text not null,
 detail jsonb not null default '{}'::jsonb,
 created_at timestamptz not null default now()
);
create index if not exists payment_links_user_created_idx on public.payment_links(user_id,created_at desc);
create index if not exists payment_orders_user_created_idx on public.payment_orders(user_id,created_at desc);
create index if not exists payment_orders_link_status_idx on public.payment_orders(link_id,status);
create index if not exists subscriptions_user_status_idx on public.subscriptions(user_id,status,expires_at);
-- Keep RLS enabled. This app accesses tables only through server-side service role.
alter table public.users enable row level security;
alter table public.plans enable row level security;
alter table public.subscriptions enable row level security;
alter table public.payment_links enable row level security;
alter table public.payment_orders enable row level security;
alter table public.api_keys enable row level security;
alter table public.audit_logs enable row level security;
