# Repository Guidelines

This guide covers the Skarb Kibica frontend: Angular 22, TypeScript, standalone components, and SCSS. Paths below are relative to `frontend/`; see @../AGENTS.md for repository-wide instructions.

## Build, Test, and Development Commands

Run commands from `frontend/`. Use npm; @package.json declares npm 11.19.0. See @README.md for compatible Node.js versions.

- `npm ci` — install dependencies from the lockfile.
- `npm start` — serve locally at `http://localhost:4200/`.
- `npm run build` — create the production bundle in `dist/skarb-kibica/browser/`.
- `npm test -- --watch=false` — run unit tests once; `npm test` enables watch mode.
- `npm run watch` — rebuild the development bundle on changes.

## Local API Configuration

Start the backend separately using @../README.md. @proxy.conf.json forwards `/api/**` to `http://127.0.0.1:8080`, preserving paths. Restart `npm start` after proxy changes. With both services running, verify connectivity using `curl --fail http://localhost:4200/api/health`. Production hosting needs its own API forwarding configuration.

## Project Structure and Component Organization

- `src/main.ts` bootstraps the application.
- `src/app/` contains components, templates, styles, and colocated tests.
- @src/app/app.config.ts registers application providers, including HTTP; @src/app/app.routes.ts defines routes and is currently empty.
- `src/styles.scss` holds global styles; `public/` contains static assets.
- `dist/` and `.angular/cache/` are generated and ignored.

## Coding Style and Naming Conventions

Follow @src/app/app.ts: named component exports, `app-` selectors, and separate `.ts`, `.html`, and `.scss` files sharing a basename. The existing root component is `App` in `app.ts`.

Use two-space indentation and single-quoted TypeScript strings. @.editorconfig defines whitespace rules; @.prettierrc configures Prettier with a 100-column print width and Angular HTML parsing. No lint script is configured. Consult @tsconfig.json for compiler settings.

## Testing Guidelines

Use Vitest with Angular TestBed; follow @src/app/app.spec.ts and colocate `*.spec.ts` files with source. No coverage threshold is configured. Update the starter heading assertion when replacing the placeholder screen.

## Commit and Pull Request Guidelines

Recent commits predominantly use short Polish descriptions; one uses `chore:`, so Conventional Commits are not established. No PR template or CI workflow is present. Recommended PR contents: change summary, build/test results, related issue when applicable, and screenshots for visible UI changes.
