-- Local dev seed: deterministic test users + households.
-- Applied by `supabase db reset`; never pushed to cloud.
-- Topology: household A (alice owner + bob member), household B (carol owner)
-- Reused by HRD-3 verification: cross-household reads must return empty.

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password,
  email_confirmed_at, created_at, updated_at,
  raw_app_meta_data, raw_user_meta_data
)
values
  (
    '00000000-0000-0000-0000-000000000000',
    '00000000-0000-0000-0000-00000000a1ce',
    'authenticated', 'authenticated', 'alice@hoardly.dev',
    crypt('alice1234', gen_salt('bf')),
    now(), now(), now(),
    '{"provider": "email", "providers": ["email"]}'::jsonb,
    '{"display_name": "Alice"}'::jsonb
  ),
  (
    '00000000-0000-0000-0000-000000000000',
    '00000000-0000-0000-0000-00000000b0bb',
    'authenticated', 'authenticated', 'bob@hoardly.dev',
    crypt('bob12345', gen_salt('bf')),
    now(), now(), now(),
    '{"provider": "email", "providers": ["email"]}'::jsonb,
    '{"display_name": "Bob"}'::jsonb
  ),
  (
    '00000000-0000-0000-0000-000000000000',
    '00000000-0000-0000-0000-00000000ca40',
    'authenticated', 'authenticated', 'carol@hoardly.dev',
    crypt('carol12345', gen_salt('bf')),
    now(), now(), now(),
    '{"provider": "email", "providers": ["email"]}'::jsonb,
    '{"display_name": "Carol"}'::jsonb
  )
on conflict (id) do nothing;

insert into auth.identities (
  provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at
)
values
  (
    '00000000-0000-0000-0000-00000000a1ce',
    '00000000-0000-0000-0000-00000000a1ce',
    '{"sub": "00000000-0000-0000-0000-00000000a1ce", "email": "alice@hoardly.dev", "email_verified": true}'::jsonb,
    'email', now(), now(), now()
  ),
  (
    '00000000-0000-0000-0000-00000000b0bb',
    '00000000-0000-0000-0000-00000000b0bb',
    '{"sub": "00000000-0000-0000-0000-00000000b0b", "email": "bob@hoardly.dev", "email_verified": true}'::jsonb,
    'email', now(), now(), now()
  ),
  (
    '00000000-0000-0000-0000-00000000ca40',
    '00000000-0000-0000-0000-00000000ca40',
    '{"sub": "00000000-0000-0000-0000-00000000ca40", "email": "carol@hoardly.dev", "email_verified": true}'::jsonb,
    'email', now(), now(), now()
  );

insert into public.profiles (id, display_name)
values
  ('00000000-0000-0000-0000-00000000a1ce', 'Alice'),
  ('00000000-0000-0000-0000-00000000b0bb', 'Bob'),
  ('00000000-0000-0000-0000-00000000ca40', 'Carol')
on conflict (id) do nothing;

insert into public.households (id, name, currency)
values
  ('10000000-0000-0000-0000-00000000aaaa', 'Apartment 12', 'ILS'),
  ('10000000-0000-0000-0000-00000000bbbb', 'Carol''s House', 'USD')
on conflict (id) do nothing;

insert into public.household_members (household_id, user_id, role)
values
  ('10000000-0000-0000-0000-00000000aaaa', '00000000-0000-0000-0000-00000000a1ce', 'owner'),
  ('10000000-0000-0000-0000-00000000aaaa', '00000000-0000-0000-0000-00000000b0bb', 'member'),
  ('10000000-0000-0000-0000-00000000bbbb', '00000000-0000-0000-0000-00000000ca40', 'owner')
on conflict (household_id, user_id) do nothing;
