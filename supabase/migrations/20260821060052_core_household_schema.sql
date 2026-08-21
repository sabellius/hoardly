create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  display_name text,
  created_at timestamptz not null default now()
);

create table public.households (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  currency char(3),
  created_at timestamptz not null default now(),
  constraint currency_iso_4217_format check (
    currency is null or currency ~ '^[A-Z]{3}$'
  )
);

create table public.household_members (
  household_id uuid not null references public.households (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  role text not null,
  joined_at timestamptz not null default now(),
  primary key (household_id, user_id),
  constraint member_role_valid check (role in ('owner', 'member'))
);

create unique index household_members_one_owner_idx
  on public.household_members (household_id)
  where (role = 'owner');

create index household_members_user_id_idx on public.household_members (user_id);

alter table public.profiles enable row level security;
alter table public.households enable row level security;
alter table public.household_members enable row level security;
