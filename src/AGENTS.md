# Repository Guidelines

This guide covers the Java 21 / Spring Boot backend in `src/`. See @../AGENTS.md for repository-wide instructions and @../README.md for full-stack setup.

## Persistence and Configuration

Preserve the file-backed H2 default in @main/resources/application.properties. Hibernate schema generation is disabled (`ddl-auto=none`); introduce schema migrations before adding business entities. Tests must use in-memory or temporary databases, never the development database.

Supply configuration through `DB_PATH`, `DB_USERNAME`, `DB_PASSWORD`, and `PORT`. Keep database files and credentials out of Git. When changing the backend port, update @../frontend/proxy.conf.json.

## Build, Test, and Development Commands

Run commands from the repository root (`cd ..` from this directory) so the relative database path stays consistent. Use the checked-in Maven wrapper. See @../README.md for requirements, startup, full verification, and the health endpoint; @../pom.xml defines the compilation target.

- `./mvnw -Dtest=H2PersistenceTests test` — run the persistence regression test.

## Source Layout and Coding Style

- `main/java/pl/skarbkibica/`: application sources; place backend packages beneath `pl.skarbkibica`.
- `../frontend/`: separate Angular application; static assets live in `../frontend/public/`.

Follow @main/java/pl/skarbkibica/SkarbKibicaApplication.java: tab indentation and opening braces on the declaration line. No Java formatter or linter is configured.

## Testing Guidelines

Use JUnit Jupiter and AssertJ, with classes named `*Tests.java`. Name test methods in camelCase to state the expected behavior and condition, as in `dataSurvivesApplicationRestart` in @test/java/pl/skarbkibica/H2PersistenceTests.java. Follow @test/java/pl/skarbkibica/SkarbKibicaApplicationTests.java for context tests using in-memory H2.

For persistence changes, follow @test/java/pl/skarbkibica/H2PersistenceTests.java: use `@TempDir`, close the application context, then reopen the same database and assert retained data. No coverage threshold or CI workflow is currently configured; run `./mvnw verify` locally.

## Commit and Pull Request Guidelines

History primarily uses short Polish commit subjects, with one `chore:` prefix; no consistent Conventional Commits convention is established. Name the affected backend element and the change in the commit subject, e.g. "Dodaj test trwałości danych H2 po restarcie".

No PR template exists. Include the backend behavior changed, validation commands and results, and any schema or configuration impacts in the PR description.
