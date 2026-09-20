# Repository Guidelines

This guide covers the Skarb Kibica frontend: Angular 22, TypeScript, standalone components, and SCSS. Paths below are relative to `frontend/`; see @../AGENTS.md for repository-wide instructions.

## Build, Test, and Development Commands

Run commands from `frontend/` using npm. See @package.json for the package manager version and available scripts; @README.md documents Node.js requirements, setup, build, and test commands.

## Local API Configuration

Follow the "Uruchomienie lokalne" section in @README.md for backend connectivity, proxy restarts, and production forwarding requirements. Proxy configuration: @proxy.conf.json.

## Project Structure and Component Organization

See @angular.json for entry points, styles, and assets; @src/app/app.config.ts for application providers; @src/app/app.routes.ts for routes.

## Coding Style and Naming Conventions

Follow @src/app/app.ts: named component exports, `app-` selectors, and separate `.ts`, `.html`, and `.scss` files sharing a basename. The existing root component is `App` in `app.ts`.

Follow @.editorconfig and @.prettierrc for formatting; consult @tsconfig.json for compiler settings. No lint script is configured.

## Testing Guidelines

Use Vitest with Angular TestBed; follow @src/app/app.spec.ts and colocate `*.spec.ts` files with source. No coverage threshold is configured. Update the starter heading assertion when replacing the placeholder screen.

## Commit and Pull Request Guidelines

Recent commits predominantly use short Polish descriptions; one uses `chore:`, so Conventional Commits are not established. No PR template or CI workflow is present. Recommended PR contents: change summary, build/test results, related issue when applicable, and screenshots for visible UI changes.
