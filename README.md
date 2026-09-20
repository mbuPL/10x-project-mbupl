# Skarb kibica ligi koszykówki

Szkielet aplikacji: Spring Boot 4.1.1, Java 21, Maven Wrapper, Angular 22 i H2 w trwałym trybie plikowym. Backend pochodzi ze Spring Initializr, frontend z Angular CLI 22.1.8.

## Wymagania

- JDK 21 lub nowszy zgodny ze Spring Boot (zweryfikowano na JDK 25).
- Node.js 24.15+ z linii 24 i npm (zweryfikowano na Node 24.20.0 i npm 11.19.0).
- Maven pobierze się przez dołączony wrapper przy pierwszym uruchomieniu.

## Uruchomienie lokalne

W katalogu głównym uruchom backend:

```sh
./mvnw spring-boot:run
```

W drugim terminalu uruchom frontend:

```sh
cd frontend
npm ci
npm start
```

Otwórz `http://localhost:4200`. Angular wyświetla startowy ekran generatora. Backend działa na porcie 8080. Lokalny serwer Angulara przekazuje `/api/**` do backendu, więc `http://localhost:4200/api/health` powinien zwrócić JSON z polem `"status":"UP"`. Bezpośredni adres kontroli backendu i jego połączenia z bazą: `http://localhost:8080/api/health`.

## Baza danych

Domyślna baza to `jdbc:h2:file:./data/skarb-kibica`, czyli plik `data/skarb-kibica.mv.db` przy uruchomieniu z katalogu projektu. Dane pozostają po zamknięciu aplikacji. Pliki bazy są ignorowane przez Git. Testy korzystają z osobnych baz w pamięci lub w katalogach tymczasowych.

Konfigurację można przekazać zmiennymi środowiskowymi:

| Zmienna | Wartość domyślna | Znaczenie |
| --- | --- | --- |
| `DB_PATH` | `./data/skarb-kibica` | Ścieżka bazy bez rozszerzenia `.mv.db`. |
| `DB_USERNAME` | `sa` | Użytkownik lokalnej bazy. |
| `DB_PASSWORD` | pusta | Hasło bazy; ustaw w środowisku docelowym. |
| `PORT` | `8080` | Port backendu; zmiana wymaga też dopasowania proxy frontendu. |

Przykład z trwałym wolumenem: `DB_PATH=/data/skarb-kibica`. Wdrożenie na Fly.io wymaga jednej instancji backendu, zamontowanego trwałego wolumenu oraz kopii zapasowych poza wolumenem. Konfiguracja wdrożenia i automatyzacja kopii zapasowych pozostają do przygotowania. H2 działa jako baza osadzona w backendzie; konsola webowa jest wyłączona.

Automatyczne tworzenie/usuwanie schematu Hibernate jest wyłączone (`ddl-auto=none`). Przed dodaniem encji należy przygotować migracje schematu; ten szkielet nie zawiera jeszcze tabel biznesowych.

## Weryfikacja

```sh
./mvnw verify
cd frontend
npm run build
npm test -- --watch=false
npm audit
```

Test backendu sprawdza także zapis w plikowej bazie H2 i odczyt po zamknięciu oraz ponownym uruchomieniu kontekstu aplikacji. Artefakt backendu powstaje w `target/`, a frontendu w `frontend/dist/`. Są budowane osobno; proxy opisane powyżej działa podczas developmentu. Docelowy hosting frontendu i routing `/api` należy skonfigurować przy wdrożeniu.

Audyt Java nie jest wbudowany w bootstrapper; można osobno skonfigurować OWASP Dependency-Check lub Snyk. Wyniki przeprowadzonej weryfikacji znajdują się w [dzienniku bootstrapowania](context/changes/bootstrap-verification/verification.md).

## Zakres szkieletu

Funkcje koszykarskie, logowanie administratora, migracje, CI i wdrożenie pozostają do implementacji zgodnie z [PRD](context/foundation/prd.md). Na tym etapie dostępny jest techniczny szkielet oraz kontrola stanu backendu i bazy. Dokumentacja decyzji znajduje się w [wyborze stosu](context/foundation/tech-stack.md).
