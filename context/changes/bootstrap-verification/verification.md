---
bootstrapped_at: 2026-09-20T15:09:23Z
starter_id: spring
starter_name: Spring Boot
project_name: skarb-kibica-ligi-koszykowki
language_family: java
package_manager: maven
cwd_strategy: subdir-then-move
bootstrapper_confidence: verified
phase_3_status: ok
audit_command: null
---

## Hand-off

Source: `context/foundation/tech-stack.md`. Verbatim hand-off:

```markdown
---
starter_id: spring
package_manager: maven
project_name: skarb-kibica-ligi-koszykowki
hints:
  language_family: java
  team_size: solo
  deployment_target: fly
  ci_provider: github-actions
  ci_default_flow: auto-deploy-on-merge
  bootstrapper_confidence: verified
  path_taken: custom
  quality_override: false
  self_check_answers:
    typed: true
    from_official_starter: true
    conventions: true
    docs_current: true
    can_judge_agent: false
  has_auth: true
  has_payments: false
  has_realtime: false
  has_ai: false
  has_background_jobs: false
---

## Why this stack

Wybrano Spring Boot (Java, Maven, Spring Initializr) jako główny starter oraz frontend Angular (TypeScript, npm, Angular CLI) i bazę H2 w trwałym trybie plikowym. Autor pracuje solo, ma niewielkie doświadczenie w obu frameworkach i lepiej zna Spring Boot; mała skala oraz cztery tygodnie pracy po godzinach przemawiają za wykorzystaniem tych znanych technologii. Oba startery spełniają cztery kryteria przyjazności agentom. Ocena verified pochodzi z karty Spring Boot i nie oznacza zweryfikowania całej integracji Spring Boot–Angular–H2. Frontmatter opisuje główny starter; Angular i H2 są wymaganymi uzupełnieniami, które trzeba uwzględnić przy generowaniu projektu. Wdrożenie na Fly.io zakłada jedną instancję backendu i trwały wolumen dla H2, z kopiami zapasowymi poza wolumenem oraz konfiguracją zachowującą dane przy restartach i wdrożeniach. GitHub Actions ma uruchamiać kontrole i automatyczne wdrożenie po połączeniu zmian z main. MVP wymaga logowania wcześniej przygotowanego administratora oraz publicznego odczytu; płatności, AI, komunikacja push i zadania w tle nie są wymagane. Samoocena potwierdza typowanie, oficjalne generatory, konwencje i dokumentację; autor potrzebuje wsparcia w ocenie zgodności propozycji agenta z praktyką stosu.
```

## Pre-scaffold verification

| Signal | Value | Severity | Notes |
| --- | --- | --- | --- |
| Spring npm package | not run | n/a | Java starter uses Spring Initializr, not npm. |
| Spring GitHub repo | not run | n/a | Card docs_url is https://docs.spring.io/spring-boot/, not a GitHub repository; no recency signal available under the skill's rules. |
| Spring Initializr metadata | stable default 4.1.1 | informational | Live metadata at https://start.spring.io confirmed Spring Boot 4.1.1 and Java 21 availability. Snapshot and milestone releases were excluded. |
| Angular npm package | @angular/cli 22.1.8; time.modified 2026-09-16T12:05:16.978Z | fresh | Additional check for the explicitly requested Angular frontend; npm package modification time, not a claimed release timestamp. |
| Angular GitHub repo | not run | n/a | Angular card docs_url is https://angular.dev, not GitHub. |
| Local toolchain | Java 25.0.4.1, Node 24.20.0, npm 11.19.0, Maven 3.9.16 | compatible | Java compilation targets release 21. Angular CLI requires Node ^22.22.3 or ^24.15.0 or >=26.0.0. |

The first sandboxed `npm view @angular/cli version time.modified engines --json` failed with EPERM while writing the npm cache. The approved retry outside the sandbox succeeded. No cache ownership changes were made.

Official references consulted: [Spring Boot system requirements](https://docs.spring.io/spring-boot/system-requirements.html), [Spring Initializr API](https://docs.spring.io/initializr/docs/current/reference/html/), [Angular new command](https://angular.dev/cli/new), [Angular compatibility](https://angular.dev/reference/versions), [H2 file database documentation](https://h2database.github.io/html/features.html).

## Scaffold log

**Strategy**: subdir-then-move  
**Exit code**: 0 for both generators  
**Files moved**: 34, excluding installed node_modules contents; includes the two added integration files (proxy configuration and persistence test).  
**Conflicts (.scaffold siblings)**: none  
**.gitignore handling**: append-merged with the `# from spring` separator; original lines preserved, duplicate lines omitted. H2 data exclusions added separately.  
**.bootstrap-scaffold cleanup**: deleted after successful moves; the merged temporary .gitignore was removed, then the empty temporary directory was removed.  
**Existing files preserved**: AGENTS.md and all pre-existing context files, including the hand-off, PRD and archive. Existing .git history preserved.  
**New root documentation**: README.md, containing run, build, storage and verification instructions.  
**New agent/CI/deployment configuration**: none.

The user's explicit instruction to include Angular and H2 was already reflected in the hand-off rationale. The Spring card remains the primary starter. Angular was generated with the official CLI from the registered Angular card, and H2 was requested from Spring Initializr.

Routine adaptations to the registry commands:

- The Spring card's archive extraction writes to its working directory; artifactId does not choose an extraction directory. Extraction therefore explicitly targets `.bootstrap-scaffold/` and the project name is used as the Maven artifactId. This avoids writing the archive into the populated root or creating dot-prefixed Java identifiers.
- Spring Boot is pinned to the verified stable 4.1.1 release; the Java 21 target and Maven build are retained. `data-jpa,h2` supply the requested persistence layer and `actuator` supplies the integration health endpoint.
- Angular uses a valid project name and an explicit nested directory, pins CLI 22.1.8, disables git initialization and AI configuration generation, and retains generated tests for verification.

**Resolved Spring invocation** (run from project root):

```sh
mkdir .bootstrap-scaffold && set -o pipefail && curl --fail --silent --show-error --max-time 60 https://start.spring.io/starter.tgz -d dependencies=web,devtools,data-jpa,h2,actuator -d type=maven-project -d javaVersion=21 -d bootVersion=4.1.1 -d groupId=pl.skarbkibica -d artifactId=skarb-kibica-ligi-koszykowki -d name=SkarbKibica -d packageName=pl.skarbkibica -d description='Skarb kibica ligi koszykowki' | tar -xzvf - -C .bootstrap-scaffold
```

**Captured Spring output** (archive paths were emitted on stderr by tar; curl stdout was the archive piped into tar):

```text
x mvnw
x src/
x src/test/
x src/test/java/
x src/test/java/pl/
x src/test/java/pl/skarbkibica/
x src/test/java/pl/skarbkibica/SkarbKibicaApplicationTests.java
x src/main/
x src/main/java/
x src/main/java/pl/
x src/main/java/pl/skarbkibica/
x src/main/java/pl/skarbkibica/SkarbKibicaApplication.java
x src/main/resources/
x src/main/resources/application.properties
x src/main/resources/templates/
x src/main/resources/static/
x mvnw.cmd
x pom.xml
x .gitattributes
x .gitignore
x .mvn/
x .mvn/wrapper/
x .mvn/wrapper/maven-wrapper.properties
x HELP.md
```

**Resolved Angular invocation** (run from project root):

```sh
npx --yes --package=@angular/cli@22.1.8 ng new skarb-kibica --directory=.bootstrap-scaffold/frontend --defaults --standalone=true --strict=true --routing=true --style=scss --ssr=false --package-manager=npm --skip-git=true --ai-config=none --interactive=false
```

**Captured Angular stdout/stderr**:

```text
CREATE .bootstrap-scaffold/frontend/.prettierrc (161 bytes)
CREATE .bootstrap-scaffold/frontend/README.md (1464 bytes)
CREATE .bootstrap-scaffold/frontend/.editorconfig (314 bytes)
CREATE .bootstrap-scaffold/frontend/.gitignore (622 bytes)
CREATE .bootstrap-scaffold/frontend/angular.json (2051 bytes)
CREATE .bootstrap-scaffold/frontend/package.json (788 bytes)
CREATE .bootstrap-scaffold/frontend/tsconfig.json (908 bytes)
CREATE .bootstrap-scaffold/frontend/tsconfig.app.json (398 bytes)
CREATE .bootstrap-scaffold/frontend/tsconfig.spec.json (409 bytes)
CREATE .bootstrap-scaffold/frontend/.vscode/extensions.json (130 bytes)
CREATE .bootstrap-scaffold/frontend/.vscode/launch.json (470 bytes)
CREATE .bootstrap-scaffold/frontend/.vscode/tasks.json (978 bytes)
CREATE .bootstrap-scaffold/frontend/src/main.ts (222 bytes)
CREATE .bootstrap-scaffold/frontend/src/index.html (297 bytes)
CREATE .bootstrap-scaffold/frontend/src/styles.scss (80 bytes)
CREATE .bootstrap-scaffold/frontend/src/app/app.scss (0 bytes)
CREATE .bootstrap-scaffold/frontend/src/app/app.spec.ts (686 bytes)
CREATE .bootstrap-scaffold/frontend/src/app/app.ts (296 bytes)
CREATE .bootstrap-scaffold/frontend/src/app/app.html (20144 bytes)
CREATE .bootstrap-scaffold/frontend/src/app/app.config.ts (312 bytes)
CREATE .bootstrap-scaffold/frontend/src/app/app.routes.ts (77 bytes)
CREATE .bootstrap-scaffold/frontend/public/favicon.ico (15086 bytes)
- Installing packages (npm)...
✔ Packages installed successfully.
```

### File move record

Every destination below was absent and received its generated or supplemented file. Installed `frontend/node_modules/` was moved along with the frontend, but dependency files are excluded from the source-file count.

| Destination | Result |
| --- | --- |
| `.gitattributes` | moved |
| `.mvn/wrapper/maven-wrapper.properties` | moved |
| `HELP.md` | moved |
| `frontend/.editorconfig` | moved |
| `frontend/.gitignore` | moved |
| `frontend/.prettierrc` | moved |
| `frontend/.vscode/extensions.json` | moved |
| `frontend/.vscode/launch.json` | moved |
| `frontend/.vscode/tasks.json` | moved |
| `frontend/README.md` | moved |
| `frontend/angular.json` | moved |
| `frontend/package-lock.json` | moved |
| `frontend/package.json` | moved |
| `frontend/proxy.conf.json` | moved |
| `frontend/public/favicon.ico` | moved |
| `frontend/src/app/app.config.ts` | moved |
| `frontend/src/app/app.html` | moved |
| `frontend/src/app/app.routes.ts` | moved |
| `frontend/src/app/app.scss` | moved |
| `frontend/src/app/app.spec.ts` | moved |
| `frontend/src/app/app.ts` | moved |
| `frontend/src/index.html` | moved |
| `frontend/src/main.ts` | moved |
| `frontend/src/styles.scss` | moved |
| `frontend/tsconfig.app.json` | moved |
| `frontend/tsconfig.json` | moved |
| `frontend/tsconfig.spec.json` | moved |
| `mvnw` | moved |
| `mvnw.cmd` | moved |
| `pom.xml` | moved |
| `src/main/java/pl/skarbkibica/SkarbKibicaApplication.java` | moved |
| `src/main/resources/application.properties` | moved |
| `src/test/java/pl/skarbkibica/H2PersistenceTests.java` | moved |
| `src/test/java/pl/skarbkibica/SkarbKibicaApplicationTests.java` | moved |
| `.gitignore` | append-merged; original retained |

### Integration configuration

- Backend: `spring.datasource.url=jdbc:h2:file:${DB_PATH:./data/skarb-kibica}`; H2 runtime version 2.4.240 is managed by Spring Boot.
- Schema lifecycle: `ddl-auto=none`; no application tables, automatic schema deletion or business data seeds are created.
- H2 web console disabled; database credentials and path can be supplied through environment variables.
- Test data isolation: context-load test uses in-memory H2; persistence test uses JUnit's temporary directory.
- Health endpoint: `/api/health`, with database health checked and details hidden.
- Frontend: routing, standalone components, SCSS, HttpClient provider and `/api/**` proxy to `http://127.0.0.1:8080`; generated welcome page retained.
- Angular analytics was declined during the first local server run; the CLI recorded `analytics: false` in the workspace configuration.
- Actual installed frontend versions: Angular 22.1.7, Angular CLI/build 22.1.8, TypeScript 6.0.3, Vitest 4.1.11.
- No domain features, administrator login, schema migration system, CI workflow or deployment were implemented.

### Build and runtime verification

| Check | Outcome |
| --- | --- |
| `./mvnw --batch-mode --no-transfer-progress verify` | PASS; 2 tests, 0 failures/errors/skips; executable JAR built. |
| H2 restart persistence test | PASS; create and insert through the application, close its context and pool, reopen the same file in a new application context and read the saved value. |
| `npm run build` in frontend | PASS on approved retry outside sandbox; production bundle 236.50 kB, estimated transfer 64.78 kB. |
| `npm test -- --watch=false` in frontend | PASS; 1 test file, 2 tests. |
| Packaged JAR startup | PASS; Java 25, port 8080, isolated in-memory database for this HTTP smoke check. |
| `GET http://127.0.0.1:8080/api/health` | PASS; HTTP 200, status UP. |
| `GET http://localhost:4200/api/health` | PASS; HTTP 200 through Angular proxy, status UP. |
| `GET http://localhost:4200/` | PASS; Angular index HTML returned. |
| Angular dev server outside sandbox | PASS; no watcher errors on approved retry. |
| `git diff --check` | PASS. |
| Diff of AGENTS.md, context/foundation and context/archive | Empty; original content preserved. |

Observed health response:

```json
{"groups":["liveness","readiness"],"status":"UP"}
```

Environment notes:

- The initial sandboxed frontend build exited 134 without a diagnostic beyond "Building..."; the same command succeeded outside the sandbox. This occurred during verification, after both scaffold generators had already succeeded.
- The first sandboxed Angular server reported `EMFILE: too many open files, watch`. It served HTTP requests successfully, then was stopped and restarted with approved sandbox escalation. The second run built and served requests without the watcher errors.
- Maven's generated context test triggered the current Mockito dynamic-agent warning on Java 25. Tests passed; no dependency modifications or warning-suppression flags were applied.
- Verification servers were stopped gracefully after the HTTP checks; no server is intentionally left running.
- A separate browser visual inspection was not performed; frontend verification consisted of production compilation, generated component tests and HTTP checks.
- Frontend build and backend JAR remain separate artifacts; deployment routing and persistent volume provisioning are future work.

## Post-scaffold audit

### Java

**Tool**: skipped — no built-in audit tool for java  
**Recommended external tool**: OWASP Dependency-Check or Snyk, configured separately.  
**Findings**: unavailable; this is not a claim of zero Java vulnerabilities. Maven verify is a build/test check, not a vulnerability scan.

### Angular / npm

**Tool**: `npm audit --json`, run in `frontend/`  
**Exit code**: 0  
**Summary**: 0 CRITICAL, 0 HIGH, 0 MODERATE, 0 LOW, 0 INFO.  
**Direct vs transitive**: 0 findings in both categories; no advisory entries were returned. Dependency metadata reports 503 total dependencies.

#### CRITICAL findings

None.

#### HIGH findings

None.

#### MODERATE findings

None.

#### LOW / INFO findings

None.

#### Full raw audit output

```json
{
  "auditReportVersion": 2,
  "vulnerabilities": {},
  "metadata": {
    "vulnerabilities": {
      "info": 0,
      "low": 0,
      "moderate": 0,
      "high": 0,
      "critical": 0,
      "total": 0
    },
    "dependencies": {
      "prod": 11,
      "dev": 493,
      "optional": 150,
      "peer": 0,
      "peerOptional": 0,
      "total": 503
    }
  }
}
```

No automatic audit fixes or dependency upgrades were run.

## Hints recorded but not acted on

| Hint | Value |
| --- | --- |
| bootstrapper_confidence | verified |
| quality_override | false |
| path_taken | custom |
| self_check_answers | {typed: true, from_official_starter: true, conventions: true, docs_current: true, can_judge_agent: false} |
| team_size | solo |
| deployment_target | fly |
| ci_provider | github-actions |
| ci_default_flow | auto-deploy-on-merge |
| has_auth | true |
| has_payments | false |
| has_realtime | false |
| has_ai | false |
| has_background_jobs | false |

These hints were preserved without generating their corresponding features or infrastructure. The registry's verified confidence describes the Spring starter; integration checks performed for this run are listed separately above.

## Next steps

The project is scaffolded; build, test, persistence and local proxy checks passed. Java vulnerability auditing remains a separate task.

Run the backend with `./mvnw spring-boot:run` and the frontend with `cd frontend && npm start`. Detailed instructions are in the root README.

The next lesson's agent-context workflow can configure project instructions. Implement administrator authentication, business functionality and database migrations according to the PRD. Before deployment, configure the frontend/backend routing, a persistent H2 volume with one backend instance and off-volume backups. No deployment or CI automation was performed in this run.

