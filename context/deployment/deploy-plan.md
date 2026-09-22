---
project: skarb-kibica-ligi-koszykowki
approved_at: 2026-09-22
approval: User accepted the proposed plan with "Implement the plan."
status: implementation_in_progress
deployment_status: not_deployed
platform: Railway
current_billing: trial_5_usd_user_authorized
environment: production
service: backend
region: europe-west4-drams3a
---

# Pierwsze wdrożenie Skarbu Kibica

## Zatwierdzony zakres

Publiczny szkielet Angular + Spring Boot + plikowa H2, jedna domena HTTPS,
jedna usługa Railway Hobby w Amsterdamie. GitHub Actions sprawdza obraz na PR
i wdraża po merge do `main`. Bez płatnych środowisk PR.

Właściciel wybrał alert kosztów **8 USD** i hard limit **10 USD**. Limit może
zatrzymać aplikację; nie zmieniamy go automatycznie. Limit obejmuje zużycie
workspace, a nie gwarancję stałej dostępności ani całkowitego rachunku z podatkami.

**Aktualizacja użytkownika podczas implementacji, 2026-09-22:** pierwsze wdrożenie
korzysta z bezpłatnego okresu próbnego i kredytu **5 USD**. Użytkownik przełączy
konto na Hobby i ustawi limity 8/10 USD później. Akceptuje publikację przed tą
zmianą. Nie aktywować płatnej subskrypcji automatycznie. API obecnie zwraca plan
HOBBY bez aktywnej subskrypcji; odrzuca ustawianie limitów. Dostępność po końcu
okresu/kredytu nie jest zapewniona; konfiguracja zasobów musi mieścić się w trial.

Pełny eksport H2 do prywatnego bucketu i test odtwarzania są odłożone do etapu
przed przyjęciem rzeczywistych danych. W tym wdrożeniu nie powstają funkcje
koszykarskie, konto administratora ani migracje pustego schematu.

Plan zaakceptowano przed zmianami infrastruktury. Poniższe kroki określają
zamierzone wykonanie; wynik i niewykonane działania rejestruje końcowy dziennik.

## 1. Przygotowanie aplikacji i testów

1. Wieloetapowy Dockerfile: Node 24.20.0 / npm 11.19.0, `npm ci`, testy i build
   Angulara z `CI=true`; JDK 21 / Maven Wrapper z `./mvnw -B verify`; JRE 21
   z gotowym JAR-em. Obrazy bazowe przypięte do zweryfikowanych digestów.
2. Pliki `frontend/dist/skarb-kibica/browser/` kopiowane podczas budowania
   do statycznych zasobów Springa. Jedna domena i względne `/api`.
3. SPA fallback tylko dla GET/HEAD żądających HTML i tras bez rozszerzeń.
   Istniejące zasoby mają pierwszeństwo; API, zastrzeżone ścieżki, brakujące
   zasoby i żądania zapisu nie zwracają zastępczego `index.html`.
4. Entrypoint wymaga niepustego `DB_PASSWORD`, dokładnego
   `DB_PATH=/data/skarb-kibica`, rzeczywistego montowania `/data` i możliwości
   zapisu. Kończy błędem przed startem H2 przy błędnej konfiguracji.
   Runtime używa UID 0 zgodnego z montowaniem Railway; uruchamia JVM przez `exec`.
5. Zachować `ddl-auto=none`, wyłączoną konsolę H2, `/api/health` bez szczegółów.
   Migracje przygotować przed dodaniem encji biznesowych.
6. Wykluczyć z uploadu/obrazu sekrety, bazy, cache, lokalne artefakty i narzędzia
   agentowe. Uaktualnić aktywny kontrakt stacka i README z Fly.io na Railway.
7. CI uruchamia gotowy kontener na Linuxie/Java 21, testuje HTTP, błędny start
   i zachowanie wolumenu po zamknięciu oraz utworzeniu kolejnego kontenera.

## 2. Konto i przygotowanie zasobów

Właściciel zakłada konto Railway, aktywuje Hobby, ustawia alert i limit kosztów,
wykonuje logowanie oraz wprowadza poufne wartości bezpośrednio w panelach.
Agent nie przyjmuje haseł/tokenów w rozmowie ani nie zapisuje ich w repozytorium.

Po uzyskaniu konta wykonać kolejno (zmienne `*_ID` pochodzą z odpowiedzi CLI):

```sh
npm install --global @railway/cli@5.59.0
railway login --browserless
railway init --name skarb-kibica-ligi-koszykowki --workspace "$WORKSPACE_ID" --json
railway add --service backend --json
railway link --project "$PROJECT_ID" --environment production --service "$SERVICE_ID" --json
```

Usługa jest pusta, bez połączenia `--repo`. Publikacją zarządza wyłącznie
GitHub Actions. Nie dodawać starego `railway.toml/json`: Config as Code jest
wycofywane i niedostępne dla nowych usług; Dockerfile i jawne ustawienia API
wystarczają dla tego wdrożenia.

Przed utworzeniem wolumenu ustawić konfigurację:

```sh
railway api 'mutation($serviceId:String!,$environmentId:String!,$input:ServiceInstanceUpdateInput!){serviceInstanceUpdate(serviceId:$serviceId,environmentId:$environmentId,input:$input)}' \
  --raw-var "serviceId=$SERVICE_ID" \
  --raw-var "environmentId=$ENVIRONMENT_ID" \
  --var 'input={"rootDirectory":"/","dockerfilePath":"Dockerfile","healthcheckPath":"/api/health","healthcheckTimeout":300,"numReplicas":1,"sleepApplication":false,"restartPolicyType":"ON_FAILURE","restartPolicyMaxRetries":3}' \
  --compact
```

Region wymaga osobnej konfiguracji środowiska przed utworzeniem wolumenu.
Weryfikacja live wykazała, że legacy `serviceInstanceUpdate.region` nie zmienia
`deploy.multiRegionConfig`, a odczyt `serviceInstance.region` pozostaje null.
CLI 5.59.0 ma też błąd parsowania `railway scale --project`; użyć jawnego API:

```sh
railway api 'mutation($environmentId:String!,$input:EnvironmentConfig!){environmentStageChanges(environmentId:$environmentId,input:$input,merge:true){id status}}' \
  --raw-var "environmentId=$ENVIRONMENT_ID" \
  --var "input={\"services\":{\"$SERVICE_ID\":{\"deploy\":{\"multiRegionConfig\":{\"sfo\":null,\"europe-west4-drams3a\":{\"numReplicas\":1}}}}}}" \
  --compact
railway api 'mutation($environmentId:String!){environmentPatchCommitStaged(environmentId:$environmentId,skipDeploys:true,commitMessage:"Set Amsterdam before creating volume")}' \
  --raw-var "environmentId=$ENVIRONMENT_ID" --compact
```

Przed commitowaniem sprawdzić nazwy i zakres staged zmian bez odczytu wartości
sekretów. Weryfikować rzeczywistą konfigurację środowiska i region utworzonego
wolumenu; sama odpowiedź mutacji `true` nie stanowi potwierdzenia lokalizacji.
Istniejący wolumen przenosi się wraz ze zmianą regionu usługi przy następnym
deploymentcie. Po `skipDeploys:true` konfiguracja usługi może już wskazywać
Amsterdam, a fizyczny wolumen nadal `sfo`. Pierwsze wdrożenie należy obserwować
do zakończenia migracji i potwierdzenia regionu oraz stanu `READY`; nie usuwać
ani nie odłączać wolumenu. [Migracja regionu](https://docs.railway.com/deployments/regions#volumes).

W panelu usługi ustawić limit **1 vCPU / 1 GB RAM**. JVM ma
`-Xmx256m -XX:+ExitOnOutOfMemoryError`; limit kontenera uwzględnia pamięć poza
stertą. Opłata zależy od zużycia, a nie od samego limitu RAM.

Po sprawdzeniu, że wolumen jeszcze nie istnieje:

```sh
railway volume --project "$PROJECT_ID" --environment production \
  --service "$SERVICE_ID" add --mount-path /data --json
railway variable set PORT=8080 DB_PATH=/data/skarb-kibica DB_USERNAME=sa \
  --project "$PROJECT_ID" --environment production --service "$SERVICE_ID" --skip-deploys
railway domain --project "$PROJECT_ID" --environment production \
  --service "$SERVICE_ID" --port 8080 --json
```

- `DB_PASSWORD`: sealed variable w Railway, ustawiona przed pierwszym startem.
- Wolumen: domyślna pojemność Hobby, dzienne snapshoty z retencją 6 dni.
- Domena: wygenerowane `*.up.railway.app`, port 8080, zapisać URL jako `APP_URL`.
- Właściciel tworzy Project Token wyłącznie dla `production`.
- GitHub environment `production`: sekret `RAILWAY_TOKEN`, zmienne
  `PROJECT_ID`, `ENVIRONMENT_ID`, `SERVICE_ID`, `APP_URL`; dozwolona gałąź `main`.
- Repozytoryjna zmienna `RAILWAY_DEPLOY_ENABLED=true` dopiero po ukończeniu
  powyższej konfiguracji. Domyślnie workflow wykonuje same kontrole; jest to
  bramka pierwszego uruchomienia, zapobiegająca wdrożeniu niepełnej konfiguracji.
- Ochrona `main`: wymagany PR oraz check `verify`, bez obowiązkowej recenzji
  drugiej osoby w projekcie solo. Nie włączać natywnych autodeployów Railway.

## 3. CI/CD i publikacja

Workflow działa dla PR, `push main` i ręcznego `workflow_dispatch`. Kontrole
mają uprawnienie `contents: read` i nie otrzymują sekretów produkcji. Job
wdrożeniowy wymaga udanych kontroli, `main`, włączonej bramki repozytorium
i środowiska GitHub `production`. Jego concurrency serializuje produkcję
z `cancel-in-progress: false`; przed uploadem pomija nieaktualny commit main.

Pierwszy merge następuje po ukończeniu przygotowania konta/sekretów i kontroli
PR. Workflow publikuje dokładny commit za pomocą przypiętego CLI 5.59.0:

```sh
railway up --project "$PROJECT_ID" --environment "$ENVIRONMENT_ID" \
  --service "$SERVICE_ID" --detach --json --message "$GITHUB_SHA"
```

Odczytać `deploymentId`. Co 10 sekund, maksymalnie przez 20 minut:

```sh
railway deployment list --project "$PROJECT_ID" --environment "$ENVIRONMENT_ID" \
  --service "$SERVICE_ID" --limit 100 --json
```

Sprawdzać wyłącznie otrzymane ID. Wymagać `SUCCESS`, następnie wykonać testy
HTTPS. `FAILED`, `CRASHED`, `REMOVED`, `REMOVING`, `SKIPPED`, błędy CLI/JSON
i timeout kończą workflow błędem. Zakolejkowanie nie oznacza udanego wdrożenia.
Podsumowanie joba zapisuje SHA, ID wdrożenia i URL, bez wartości sekretów.

## 4. Kryteria odbioru i odzyskiwanie

- Testy backendu i frontendu oraz produkcyjny build przechodzą na Linux/Java 21.
- `/`, rzeczywiste JS/CSS i `/api/health` działają. Nieznane API i brakujące
  zasoby dają 404, syntetyczna trasa SPA HTML; POST nie otrzymuje SPA fallback.
- Brak hasła, wolumenu lub prawidłowej ścieżki zatrzymuje kontener.
- Istniejący test JDBC potwierdza zachowanie rekordów H2 po ponownym otwarciu.
- Na Railway po restarcie i ponownym wdrożeniu sprawdzić marker wolumenu,
  obecność `.mv.db` i health. Marker dowodzi trwałości dysku, nie poprawności
  rekordów ani odzyskiwania danych. Nie dodawać publicznego endpointu SQL.
- Zmierzyć pamięć po rozgrzaniu i sprawdzić prognozę kosztów; nie zwiększać
  automatycznie zaakceptowanego limitu 10 USD.
- Po dwóch udanych wdrożeniach przećwiczyć Railway Deployments → poprzednie
  wdrożenie → Rollback; sprawdzić stronę, health i wolumen, zapisać czas.
  Rollback kodu nie cofa H2. Usuwanie zasobów i rotacja sekretów należą do właściciela.
- Snapshoty nie są sprawdzonym eksportem H2. Przed rzeczywistymi danymi wdrożyć
  uwierzytelnianie administratora, migracje, spójny eksport poza wolumen i test restore.

## Dziennik wykonania

| Element | Stan |
|---|---|
| Zatwierdzenie planu | 2026-09-22, „Implement the plan.” |
| Gałąź | `codex/railway-first-deploy` |
| Konto Railway / Hobby | Konto połączone; użytkownik zatwierdził publikację na trial z kredytem 5 USD; przejście na płatne Hobby i limity 8/10 USD wykona później |
| Workspace ID | `4a55daa4-f5c2-47ae-b3c1-b9163b610fa5` |
| Project ID | `2408bd1a-2c83-4ea5-9619-c22e3bc99e5b` |
| Environment ID | `948f164e-3d86-4795-9414-e770dd8d3a91` (`production`) |
| Service ID | `af163e6c-7d97-4dff-9b52-8d75f1e7d3a9` (`backend`) |
| Konfiguracja usługi | Amsterdam, Dockerfile, jedna replika, sleep off, `/api/health`, timeout 300 s, ON_FAILURE/3, limit 1 vCPU / 1 GB; zapisane przez API |
| GitHub | CLI połączone; environment `production` dopuszcza wyłącznie `main`; `RAILWAY_DEPLOY_ENABLED=false`; main wymaga PR i udanego checka `verify` |
| Pull request | [#1](https://github.com/mbuPL/10x-project-mbupl/pull/1), commit `c8daf221f647e619b80663c013b19cae0f1d0757` |
| Domena produkcji | `https://backend-production-21c1.up.railway.app` — domena utworzona, aplikacja jeszcze nieopublikowana |
| Wolumen | `3b76aa77-f42a-4b90-9fc7-78f2fb69f74e`; instance `73c27ca5-90da-41e7-883f-18024f2eaa96`, 500 MB trial, `/data`; weryfikacja/migracja regionu przed publikacją |
| Sekrety Railway / GitHub | Właściciel potwierdził sealed `DB_PASSWORD`; zmiana zatwierdzona w środowisku. `RAILWAY_TOKEN` zapisany przez właściciela w GitHub production, potwierdzono wyłącznie nazwę sekretu |
| Publikacja / rollback / pomiary | Niewykonane |
| Testy Java 21.0.6 | 38 PASS, w tym 36 przypadków HTTP SPA i trwałość rekordów H2 |
| Testy skryptu wdrażania | 25 PASS, obejmujące sukces właściwego ID, błędy, timeout i nieaktualny SHA |
| Zintegrowany JAR | Zbudowany w katalogu tymczasowym z Angulariem; pełny `smoke-http.sh` PASS na Java 21 |
| Test kontenera Linux | [CI 35776436948](https://github.com/mbuPL/10x-project-mbupl/actions/runs/35776436948) PASS: Node 24.20.0, Java 21.0.12, 38 testów backendu, 2 frontendowe, 25 testów skryptu, 5 błędnych konfiguracji startu, HTTP oraz restart i wymiana kontenera |

Wpisy będą aktualizowane na podstawie wykonanych kontroli; przygotowany kod
nie oznacza wdrożonej produkcji.

## Źródła operacyjne

- [CLI v5.59.0](https://github.com/railwayapp/cli/tree/v5.59.0/src/commands)
- [Ustawienia usługi przez API](https://docs.railway.com/integrations/api/manage-services)
- [Dockerfile](https://docs.railway.com/builds/dockerfiles)
- [Wolumeny i uprawnienia](https://docs.railway.com/volumes)
- [Snapshoty](https://docs.railway.com/volumes/backups)
- [Kontrola kosztów](https://docs.railway.com/pricing/cost-control)
- [Wycofanie Config as Code](https://docs.railway.com/infrastructure-as-code)
