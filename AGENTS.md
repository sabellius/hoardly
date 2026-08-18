# Hoardly

Pantry management app (inventory, shopping lists, expiry reminders) for shared households.

## Expo HAS CHANGED

Read the exact versioned docs at https://docs.expo.dev/versions/v57.0.0/ before writing any code.
Never assume pre-SDK-57 patterns: verify an API exists in the v57 docs before using any `expo-*` module, plugin config, or CLI flag.

## Commands

Package manager is pnpm. Never use npm or yarn. Use `pnpm exec` for local binaries, not `npx`.

- Install: `pnpm install`
- Dev server: `pnpm start` (or `pnpm android` / `pnpm ios`)
- Lint/format: `pnpm lint` / `pnpm format` (Biome — config in `biome.json`)
- Typecheck: `pnpm typecheck`
- Test: TODO: no test runner yet (HRD-36)

## Stack & architecture (locked in MVP planning, Aug 2026)

- Expo SDK 57 (RN 0.86, React 19.2, TypeScript strict), Expo Router v57, `src/app/` = routes. iOS + Android only.
- Styling: NativeWind (Tailwind) if spike HRD-1 passes; fallback `src/theme/tokens.ts` + StyleSheet. Tokens live in one place either way.
- Backend: Supabase — magic-link auth, Postgres + RLS (household-scoped security), realtime, private storage bucket. Free tier; auth SMTP via free Brevo.
- Client data: TanStack Query + async-storage persister = offline-read snapshot cache. Online-first; offline writes are rejected with a clear state (locked decision "C"). No local DB, no sync engine in v1.
- Tests: jest-expo + @testing-library/react-native.
- i18n: English-only UI, but every string through `t()` with dictionary in `src/i18n/en.ts`.
- Import via `@/*` path alias → `src/*` (see tsconfig.json)

### Architecture rules (feature-first)

- Structure: `src/app/` = thin Expo Router routes only → `src/features/<area>/{components,hooks}` = product areas (inventory, shopping, household, …) → `src/shared/{ui,repo,lib,i18n}` = cross-cutting → `src/domain/` = pure logic. A feature's work happens inside its folder.
- `supabase-js` may only be imported inside `src/shared/repo/*`; routes never import `@/shared/repo` (data flows through feature hooks); `src/domain/` imports nothing outside domain. Enforced by Biome `noRestrictedImports` overrides.
- Features may import each other when justified; prefer moving shared code to `src/shared/`.
- Schema changes only via new files in `supabase/migrations/` — append-only, forward-only. Never via dashboard SQL editor on shared projects.
- Dev backend: `supabase start` local emulator (primary); `supabase db push` to the cloud dev project for on-device testing.

## Ticket-driven git workflow

- All work is tracked in YouTrack project `HRD` — no ticket, no code.
- One ticket = one branch named `HRD-<n>-<kebab-desc>` (e.g. `HRD-15-inventory-list-screen`). Never commit directly to `main`.
- Land branches with `git merge --no-ff` preserving atomic commits.
- Reference the ticket at the end of the message, never in the title — last line as a trailer: `Refs: HRD-15`.
- Move ticket states in YouTrack manually — commit messages never auto-resolve tickets.

## Security — repo is PUBLIC

- Treat every commit as published. Never commit secrets, keys, or `.env` files.
- `EXPO_PUBLIC_*` env vars are inlined into the client bundle: only safe-to-expose values (e.g. Supabase anon key). Everything else stays server-side.
- When introducing env vars, ship a `.env.example` with placeholder keys.

## Workflow & git

- Plan-first: non-trivial work starts as a written plan/spec that the user reviews before implementation. Match the documented spec.
- Commit automatically as logical units of work complete — do not wait to be asked. One concern per commit; never bundle unrelated changes; every commit leaves the codebase in a working state.
- Conventional commits (`feat:`, `fix:`, `chore:`, …). Messages brief and informative, describing the specific change.
- No AI markers in commit messages: no `Co-Authored-By`, no "Generated with …", no robot emoji. Use the `stop-slop` skill when in doubt.
- Before finishing code changes: lint + typecheck must pass; fix root causes, never suppress errors.
