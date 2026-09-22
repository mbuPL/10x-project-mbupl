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

Przykład z trwałym wolumenem: `DB_PATH=/data/skarb-kibica`. Docelowo jedna usługa Railway Hobby w Amsterdamie serwuje backend i Angulara, a H2 korzysta z wolumenu `/data`. Kontener odmawia startu bez hasła, właściwej ścieżki i rzeczywistego montowania tego wolumenu. H2 działa jako baza osadzona; konsola webowa jest wyłączona. Użytkownik zdecydował pozostawić snapshoty, eksport H2 i odtwarzanie poza MVP, akceptując ryzyko utraty danych. Trwały wolumen nie jest kopią zapasową.

Automatyczne tworzenie/usuwanie schematu Hibernate jest wyłączone (`ddl-auto=none`). Przed dodaniem encji należy przygotować migracje schematu; ten szkielet nie zawiera jeszcze tabel biznesowych.

## Weryfikacja

```sh
./mvnw verify
cd frontend
npm run build
npm test -- --watch=false
npm audit
```

Test backendu sprawdza także zapis w plikowej bazie H2 i odczyt po zamknięciu oraz ponownym uruchomieniu kontekstu aplikacji. Testy HTTP sprawdzają zasoby statyczne, routing SPA oraz oddzielenie API. Lokalne artefakty powstają w `target/` i `frontend/dist/`. Dockerfile buduje oba projekty i dołącza Angulara do JAR-a; produkcja nie korzysta z proxy developmentowego.

Jeśli lokalny build Angulara na macOS przerywa się w module cache LMDB, użyj `CI=1 npm run build`. Wyłącza to domyślny lokalny cache bez zmiany projektu. Kontener i GitHub Actions używają `CI=true`.

Audyt Java nie jest wbudowany w bootstrapper; można osobno skonfigurować OWASP Dependency-Check lub Snyk. Wyniki przeprowadzonej weryfikacji znajdują się w [dzienniku bootstrapowania](context/changes/bootstrap-verification/verification.md).

## Kontener i CI/CD

Z katalogu głównego, przy dostępnym Dockerze:

```sh
docker build --tag skarb-kibica:local .
bash scripts/smoke-container.sh skarb-kibica:local
```

Build uruchamia testy Angulara i Maven na Java 21. Test kontenera wymaga Node 24
na hoście, sprawdza HTTP, odrzucanie błędnej konfiguracji i ponowne uruchomienie
z tym samym wolumenem. Używa własnych tymczasowych kontenerów, hasła i danych.

Publiczną instancję można sprawdzić poleceniem:

```sh
bash scripts/smoke-http.sh https://NAZWA.up.railway.app
```

Workflow GitHub Actions wykonuje check `verify` na PR i `main`. Wdrażanie
jest początkowo wyłączone. Wymaga repozytoryjnej zmiennej
`RAILWAY_DEPLOY_ENABLED=true` oraz środowiska GitHub `production` z sekretem
`RAILWAY_TOKEN` i zmiennymi `PROJECT_ID`, `ENVIRONMENT_ID`, `SERVICE_ID`, `APP_URL`.
Token należy ograniczyć do projektu i środowiska produkcyjnego Railway.
Job wdrożeniowy działa dopiero po testach na `main`, czeka na status konkretnego
wdrożenia i wykonuje kontrolę HTTPS. PR nie otrzymują sekretów produkcji.

Konfiguracja konta, limity kosztów 8/10 USD, polecenia tworzenia zasobów,
rollback i aktualny stan publikacji są w [zatwierdzonym planie wdrożenia](context/deployment/deploy-plan.md).
Pierwszą publikację użytkownik zdecydował uruchomić na trial z kredytem 5 USD;
płatne Hobby oraz limity 8/10 USD skonfiguruje później.
Nie włączać dodatkowo natywnych autodeployów Railway ani środowisk PR.

## Zakres szkieletu

Funkcje koszykarskie, logowanie administratora i migracje pozostają do implementacji zgodnie z [PRD](context/foundation/prd.md). Na tym etapie dostępny jest techniczny szkielet, kontrola stanu backendu i bazy oraz konfiguracja kontenera i CI/CD. Publikacja wymaga konta Railway i podłączenia sekretów; samo istnienie workflow nie oznacza wdrożonej produkcji. Dokumentacja decyzji znajduje się w [wyborze stosu](context/foundation/tech-stack.md).
