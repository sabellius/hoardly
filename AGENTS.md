# Hoardly

Pantry management app (inventory, shopping lists, expiry reminders) for shared households.

## Expo HAS CHANGED

Read the exact versioned docs at https://docs.expo.dev/versions/v57.0.0/ before writing any code.
Never assume pre-SDK-57 patterns: verify an API exists in the v57 docs before using any `expo-*` module, plugin config, or CLI flag.

## Commands

Package manager is pnpm. Never use npm or yarn. Use `pnpm exec` for local binaries, not `npx`.

- Install: `pnpm install`
- Dev server: `pnpm start` (or `pnpm android` / `pnpm ios`)
- Lint: `pnpm lint` (`expo lint`)
- Typecheck: `pnpm typecheck` — TODO: script not yet added; meanwhile `pnpm exec tsc --noEmit`
- Test: TODO: no test runner yet

## Stack & architecture (tentative — pre-planning)

Scaffold decisions and current plan; will be finalized in the MVP plan doc, then updated here.

- Expo SDK 57 (RN 0.86, React 19.2, TypeScript strict), Expo Router v57, `src/app/` = routes
- Planned: expo-sqlite + Drizzle ORM, offline-first; sync via Supabase (auth/RLS) + PowerSync; expo-notifications local reminders; expo-camera barcode scanning; OpenFoodFacts product lookup
- Import via `@/*` path alias → `src/*` (see tsconfig.json)

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
