# Repository Guidelines

This guide covers the Java 21 / Spring Boot backend in `src/`. See @../AGENTS.md for repository-wide instructions and @../README.md for full-stack setup.

## Persistence and Configuration

Preserve the file-backed H2 default in @main/resources/application.properties. Hibernate schema generation is disabled (`ddl-auto=none`); introduce schema migrations before adding business entities. Tests must use in-memory or temporary databases, never the development database.

Supply configuration through `DB_PATH`, `DB_USERNAME`, `DB_PASSWORD`, and `PORT`. Keep database files and credentials out of Git. When changing the backend port, update @../frontend/proxy.conf.json.

## Build, Test, and Development Commands

Run commands from the repository root (`cd ..` from this directory) so the relative database path stays consistent:

- `./mvnw spring-boot:run` — start the backend on port 8080 by default.
- `./mvnw verify` — run tests and package the executable JAR into `target/`.
- `./mvnw -Dtest=H2PersistenceTests test` — run the persistence regression test.

Use the checked-in Maven wrapper with JDK 21 or newer; @../pom.xml defines the Java 21 compilation target. The health endpoint is `/api/health`.

## Source Layout and Coding Style

- `main/java/pl/skarbkibica/`: application sources; place backend packages beneath `pl.skarbkibica`.
- `main/resources/`: runtime configuration.
- `test/java/pl/skarbkibica/`: backend tests.
- `../frontend/`: separate Angular application; static assets live in `../frontend/public/`.

Follow @main/java/pl/skarbkibica/SkarbKibicaApplication.java: tab indentation, opening braces on the declaration line, PascalCase class filenames, and camelCase methods. No Java formatter or linter is configured.

## Testing Guidelines

Use JUnit Jupiter and AssertJ, with classes named `*Tests.java` and descriptive camelCase test methods. Follow @test/java/pl/skarbkibica/SkarbKibicaApplicationTests.java for context tests using in-memory H2.

For persistence changes, follow @test/java/pl/skarbkibica/H2PersistenceTests.java: use `@TempDir`, close the application context, then reopen the same database and assert retained data. No coverage threshold or CI workflow is currently configured; run `./mvnw verify` locally.

## Commit and Pull Request Guidelines

History primarily uses short Polish commit subjects, with one `chore:` prefix; no consistent Conventional Commits convention is established. Keep subjects descriptive of the change.

No PR template exists. Include the backend behavior changed, validation commands and results, and any schema or configuration impacts in the PR description.
