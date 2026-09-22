---
project: skarb-kibica-ligi-koszykowki
researched_at: 2026-09-22
recommended_platform: Railway
runner_up: Fly.io
context_type: mvp
tech_stack:
  language: Java 21 / TypeScript 6.0.3
  framework: Spring Boot 4.1.1 / Angular 22.1.7
  runtime: JVM 21; Node.js 24.15+ z linii 24 podczas budowania frontendu
decision_status: accepted
decision_by: user
deployment_status: deployed
production_url: https://backend-production-21c1.up.railway.app
current_billing: trial_5_usd_user_authorized
backup_status: disabled_user_accepted_risk_outside_mvp
region: europe-west4-drams3a
plan: Hobby
---

## Recommendation

**Deploy on Railway — Hobby, EU West Metal (Amsterdam).**

Railway uzyskało 33/34 punkty po uwzględnieniu kryteriów operacyjnych i preferencji użytkownika: koszt i wygoda są równie ważne, brak doświadczenia z platformami, użytkownicy w Polsce, preferowana obsługa usług w jednym miejscu. Platforma obsługuje Java/Maven, trwały wolumen H2, środowiska podglądowe i magazyn kopii zapasowych; orientacyjny koszt jednej stale działającej aplikacji wynosi **6–13 USD miesięcznie** przy założeniach poniżej. Użytkownik po przedstawieniu trzech perspektyw oceny ryzyka wybrał: „wybieram Railway”. [Railpack Java][railpack-java], [regiony][railway-regions], [cennik][railway-pricing].

Ta decyzja zastępuje wcześniejsze założenie Fly.io w `tech-stack.md` i opis wdrożenia w `README.md`. Technologie pozostają bez zmian; ponowny wybór stacka nie jest potrzebny. W ramach tej umiejętności zapisano wyłącznie niniejszy kontrakt. Plan wdrożenia musi uwzględnić aktualizację wcześniejszych odniesień do Fly.io przed wykonaniem zmian infrastrukturalnych.

### Inputs and constraints

Źródła lokalne: `context/foundation/tech-stack.md`, `context/foundation/prd.md`, `pom.xml`, `frontend/package-lock.json`, `frontend/angular.json`, `src/main/resources/application.properties` i `README.md`. Ocenę oparto na `.agents/skills/10x-infra-research/references/agent-friendly-criteria.md`.

| Obszar | Ustalenie |
|---|---|
| Trwałe połączenia | Nie; zwykłe żądania/odpowiedzi, bez realtime i stale działających workerów. |
| Koszt a wygoda | Równorzędne: niedrogo, ale prosto i szybko w codziennej pracy. |
| Znajomość platform | Brak; żadna platforma nie dostaje premii za wcześniejsze doświadczenie. |
| Geografia | Użytkownicy w Polsce; jeden region europejski wystarczy. Nie jest wymagane przechowywanie danych na terytorium Polski. |
| Usługi dodatkowe | Preferowany jeden dostawca/panel i rozliczenie. |
| Produkt | Autor i kilka osób; publiczny odczyt, jeden administrator, cztery tygodnie pracy po godzinach; brak wymagań SLA lub konkretnego czasu odpowiedzi. |
| Backend | Spring Boot 4.1.1, Java 21, Maven Wrapper 3.9.16. |
| Frontend | Angular 22.1.7, CLI/build 22.1.8, TypeScript 6.0.3, npm 11.19.0; dla budowania przyjmujemy Node 24.20.0, użyty przy bootstrapowaniu. |
| Dane | Osadzone H2 2.4.240, wersja zarządzana przez BOM Spring Boot; trwały plik, jedna instancja backendu. Pierwotnie rekomendowaną kopię poza wolumenem użytkownik odłożył poza MVP. |
| Stan repozytorium po wdrożeniu | Opublikowany szkielet i `/api/health`; Docker oraz CI/CD, wspólnie pakowane backend i frontend. Nadal brak logowania, migracji i funkcji biznesowych. |

Wdrożony wariant: jedna usługa `backend`, która serwuje również statyczne pliki Angulara z JAR-a. Jedna domena i względne `/api` upraszczają konfigurację. Node jest potrzebny w procesie budowania, nie jako drugi stale działający serwer. Wyniki wdrożenia i testów zawiera [dziennik planu](../deployment/deploy-plan.md).

## Platform Comparison

### Ustalenia wykonawcze zaakceptowane 2026-09-22

Zatwierdzony [plan pierwszego wdrożenia](../deployment/deploy-plan.md) konkretyzuje
poniższą historię operacyjną dla szkieletu:

- Podczas implementacji użytkownik wybrał pierwszą publikację na okresie próbnym
  z kredytem 5 USD; płatne Hobby i limity 8/10 USD ustawi później. Nie aktywować
  subskrypcji automatycznie. Rekomendacja Hobby dotyczy docelowego utrzymania,
  a trial nie zapewnia ciągłości po wyczerpaniu kredytu lub upływie okresu.

- Publikacja przez GitHub Actions po kontrolach PR i merge do `main`; wspólny
  obraz Docker buduje Angulara i Spring Boot. Runtime: jedna JVM 21.
- W pierwszym etapie wyłącznie `production`; zamiast płatnych PR Environments
  testy gotowego kontenera w GitHub Actions. Opis PR Environments poniżej
  pozostaje możliwością na późniejszy etap.
- Docelowy alert kosztów 8 USD i hard limit 10 USD właściciel ustawi po przejściu
  na Hobby; nie są aktywne na trial. Sleep pozostaje wyłączony.
- Późniejsza decyzja użytkownika z tego samego dnia zastępuje pierwotny wymóg
  kopii: panel wskazał backupy jako funkcję Pro, a użytkownik świadomie pozostawił
  snapshoty, eksport H2 i restore **poza MVP**, akceptując utratę danych.
  Poniższy baseline backupów opisuje pierwotną rekomendację badawczą, nie aktualny
  warunek wdrożenia. Trwały wolumen nadal jest wymagany.
- Konfiguracja usługi przez CLI/API i Dockerfile. Nie tworzyć `railway.toml/json`:
  [Config as Code jest wycofywane](https://docs.railway.com/infrastructure-as-code).
- Aktywny kontrakt stacka i README zostają uzgodnione z Railway. Stan wykonania,
  identyfikatory zasobów oraz faktyczne testy zapisuje plan wdrożenia; historyczne
  dzienniki bootstrapowania zachowują ówczesne założenia.

### Hard compatibility filters

Brak WebSocketów nie usuwa wymogu trwałego dysku. Oceniana jest możliwość uruchomienia **całej aplikacji Java + Angular + plikowe H2**, bez przepisywania backendu i wymiany bazy.

| Platforma | Wynik filtra | Uzasadnienie |
|---|---|---|
| Cloudflare Workers / Pages + Containers | Odrzucona | Workers/Pages nie uruchamiają istniejącego JVM. Containers mogą uruchomić obraz z Javą, ale dysk jest nietrwały; zapowiadane snapshoty nie są dostępnym trwałym wolumenem. R2 przez FUSE nie ma zweryfikowanej zgodności z wymaganiami plikowej H2. [Dokumentacja][cloudflare-containers]. |
| Vercel | Odrzucona | Container Images są **beta**, ale działają jako bezstanowe Functions bez trwałych wolumenów. Zewnętrzny Postgres/Blob nie zastępuje H2 bez zmiany kontraktu stacka. [Kontenery][vercel-containers], [stan i wolumeny][vercel-state]. |
| Netlify | Odrzucona | Hosting statycznego Angulara pasuje, lecz standardowe Functions nie stanowią hostingu istniejącej aplikacji Spring/JVM z trwałym plikiem H2. Osobny backend wymagałby drugiej platformy. [Functions][netlify-functions]. |
| Fly.io | Spełniony | Java w kontenerze na Machine, lokalny trwały wolumen, jedna instancja; region Frankfurt. |
| Railway | Spełniony | Java/Maven przez Railpack lub kontener, wolumen montowany do jednej usługi; region Amsterdam. |
| Render | Spełniony | Java przez kontener Docker, płatna usługa z trwałym dyskiem; region Frankfurt. |

### Scoring

`Pass = 2`, `Partial = 1`, `Fail = 0`. Wagi: CLI/API operacyjne **3**, zarządzanie infrastrukturą **3**, dokumentacja **2**, API wdrożeń **3**, MCP/integracja **1**. Maksimum: **24**. CLI-first obejmuje również udokumentowane, nieinteraktywne API — brak osobnego polecenia rollback nie oznacza automatycznie niższej oceny.

Oceny opisują możliwości platformy; filtr zgodności ma pierwszeństwo przed punktami. `Pass` dla managed oznacza obsługę infrastruktury hosta, TLS i uruchamiania aplikacji, nie zarządzanie osadzoną H2 ani jej kopiami.

| Platforma | CLI-first ×3 | Managed ×3 | Dokumentacja ×2 | API wdrożeń ×3 | MCP/integracja ×1 | Suma /24 | Dopuszczona |
|---|---|---|---|---|---|---:|---|
| Cloudflare | Pass | Pass | Pass | Pass | Pass | 24 | Nie |
| Vercel | Pass | Pass | Pass | Pass | Partial | 23 | Nie |
| Netlify | Pass | Pass | Pass | Pass | Pass | 24 | Nie |
| Fly.io | Pass | Pass | Pass | Pass | Partial | 23 | Tak |
| Railway | Pass | Pass | Pass | Pass | Pass | 24 | Tak |
| Render | Pass | Pass | Pass | Pass | Pass | 24 | Tak |

Miękkie preferencje dodają maksymalnie 10 punktów: koszt **0–4**, wygoda dla początkującego **0–4**, wspólna obsługa aplikacji/dysku/kopii **0–2**. To jawna ocena projektowa, nie benchmark. Geografia nie rozstrzyga: wszystkie trzy opcje mają odpowiedni region europejski. Brak premii za znajomość lub globalny edge.

| Platforma | Operacyjność /24 | Koszt /4 | Wygoda /4 | Wspólna obsługa /2 | Razem /34 |
|---|---:|---:|---:|---:|---:|
| Railway | 24 | 3 | 4 | 2 | **33** |
| Fly.io | 23 | 4 | 2 | 2 | **31** |
| Render | 24 | 2 | 3 | 1 | **30** |

**Cloudflare.** Wrangler, skryptowalne API, dokumentacja Markdown i oficjalne MCP zapewniają bardzo dobrą operacyjność. Przykładowe polecenia Workers to `wrangler deploy`, `wrangler rollback` i `wrangler tail`; Pages mają osobną rodzinę poleceń. Dostępne są D1, R2, Queues i Durable Objects, lecz żaden z tych produktów nie zmienia nietrwałego dysku Containers w obsługiwany wolumen H2. Containers wymagają Workers Paid od 5 USD/mies. plus zużycie; nie wyceniamy tego jako działającego wariantu naszego MVP. Aktualne strony Containers nie zawierają jednoznacznego oznaczenia GA/beta — status GA niepotwierdzony, dysk nietrwały potwierdzony 2026-09-22. [Containers][cloudflare-containers], [cennik][cloudflare-pricing], [CLI][cloudflare-cli], [MCP][cloudflare-mcp].

**Vercel.** Zarządzane Functions, CLI (`vercel --prod`, `vercel rollback`, `vercel logs`), API i dokumentacja dostępna dla agentów są mocnymi stronami. Oficjalne MCP i Container Images mają status **beta**, sprawdzony 2026-09-22; stąd ostrożniejsza ocena integracji. Wspierane są również WebSockety w **beta**, z ograniczeniami czasu życia funkcji — nie powielamy starego twierdzenia o całkowitym braku ich obsługi. Hobby kosztuje 0 USD, Pro od 20 USD/mies., ale nawet tani hosting Angulara nie pokrywa wymagań H2. [Cennik][vercel-pricing], [MCP][vercel-mcp], [kontenery][vercel-containers], [rollback][vercel-rollback].

**Netlify.** CLI, OpenAPI, zarządzane wdrożenia, Markdown/`llms.txt` i oficjalny MCP spełniają kryteria. `netlify deploy` tworzy draft, `netlify deploy --prod` publikuje; logi obsługuje `netlify logs`, poprzednie wdrożenie można przywrócić przez interfejs wdrożeń/API. Blobs i oferta bazy danych nie rozwiązują ograniczenia Spring/H2. Free ma 300 kredytów/mies., Personal 9 USD/1000 kredytów, Pro od 20 USD/3000 kredytów; kredyty obejmują m.in. transfer, żądania i wdrożenia, więc sama liczba żądań nie wystarcza do wyceny. Nie ma adekwatnego kosztu całego obecnego stacka. [Functions][netlify-functions], [CLI][netlify-cli], [MCP][netlify-mcp], [cennik][netlify-pricing].

**Fly.io.** Machines, wolumeny, REST API, `fly deploy`, `fly logs` i dokumentacja `llms.txt` pozwalają obsłużyć pełny cykl z terminala. Rollback to ponowne wdrożenie zachowanego obrazu. Host jest zarządzany, ale dobór maszyny, obrazu, montowania i procedur odtwarzania wymaga więcej pracy. Oficjalne `fly mcp server` istnieje; opis tooling MCP nadal nazywa je **experimental** (sprawdzono 2026-09-22), co uzasadnia Partial. Tigris integruje magazyn kopii i rozliczenie z Fly; nie karzemy platformy za sam fakt używania partnera. Wolumen jest lokalny dla jednego hosta i nie replikuje się automatycznie. [Machines API][fly-api], [wolumeny][fly-volumes], [MCP][fly-mcp], [status MCP][fly-mcp-status], [Tigris][fly-tigris].

**Railway.** Railpack rozpoznaje Java/Maven, CLI udostępnia JSON i kody błędów, a GraphQL pozwala m.in. wykonać rollback. Dokumentacja ma Markdown/`llms.txt`; oficjalny MCP jest hostowany, bez znalezionej aktualnej etykiety beta. Wszystkie pięć ocen to Pass. Dysk i bucket można obsługiwać razem z aplikacją, bez dodawania konta u innej platformy. Przewaga wygody wynika z obsługi projektu i środowisk; rozliczenie według zużycia RAM/CPU jest mniej przewidywalne od małej stałej maszyny Fly. H2 pozostaje bazą zarządzaną przez aplikację. [Railpack][railpack-java], [CLI][railway-up], [API][railway-api], [MCP][railway-mcp], [bucket][railway-buckets].

**Render.** Kontener Java, zarządzana usługa, dokumentacja Markdown, oficjalny MCP infrastrukturalny i REST API zapewniają pełną obsługę operacyjną. CLI 2.28.0: `render deploys create SERVICE_ID --wait --confirm --output json`, `render logs --resources SERVICE_ID --tail --output text`; rollback przez udokumentowane `POST /v1/services/{serviceId}/rollback` z `deployId`. Darmowa usługa nie obsługuje trwałego dysku. Brak wariantu 1 GB zwiększa koszt zapasu pamięci dla Springa. Magazyn obiektowy jest **alpha / lista oczekujących**, sprawdzono 2026-09-22; sam eksperymentalny MCP dokumentacyjny nie jest podstawą oceny Pass, którą daje infrastrukturalny MCP. [Runtime][render-faq], [CLI][render-cli], [rollback][render-rollback], [dyski][render-disks], [MCP][render-mcp], [object storage][render-storage].

### Costs at 10k–100k monthly requests

Założenia: jedna aplikacja działająca cały miesiąc, 0,5–1 GB RAM (do pomiaru), 10–100 tys. żądań po średnio 100 KB, czyli około 1–10 GB transferu do użytkowników; około 1 GB danych na dysku, 1 GB przyrostowych snapshotów i przykładowo 3 GB archiwów poza wolumenem oraz 3 GB transferu ich wysyłania. Nie są to wyniki testu obciążeniowego. Pominięto podatki, domenę i dodatkowe środowiska.

| Platforma | Składniki i szacunek |
|---|---|
| Railway | RAM 5–10 USD przy średnio 0,5–1 GB; CPU 0,50–2 USD przy średnio 0,025–0,10 vCPU; dane 0,15 USD; snapshoty 0,15 USD; bucket 0,045 USD; transfer 0,20–0,65 USD. Razem **około 6,05–13,00 USD/mies.** Rachunek Hobby to `max(5 USD, zużycie)`, nie 5 USD dodane ponownie. |
| Fly.io, Frankfurt | shared-cpu-1x 512 MB: 3,69 USD lub 1 GB: 6,57 USD; wolumen 1 GB: 0,15 USD; transfer 4–13 GB: 0,08–0,26 USD. Razem **3,92–4,10 USD przy 512 MB** albo **6,80–6,98 USD przy 1 GB**; przyjęto mieszczące się w limitach darmowych snapshoty i Tigris. Ewentualne koszty budowania osobno. |
| Render, Frankfurt | 512 MB/0,5 CPU: 7 USD + dysk 1 GB: 0,25 USD; transfer powyżej 5 GB Hobby: 0,15 USD/GB. **7,25–8,45 USD + zewnętrzny magazyn kopii**. Następny wariant to 2 GB/1 CPU: **25,25–26,45 USD + magazyn kopii**. Założono zmieszczenie się w limicie minut budowania. |

Źródła cen: [Railway][railway-pricing], [Railway Buckets][railway-buckets], [Fly.io][fly-pricing], [Tigris][tigris-pricing], [Render][render-pricing], [transfer Render][render-bandwidth]. Na Railway Hobby pojemność wolumenu domyślnie wynosi 5 GB, ale opłata dotyczy zajętego miejsca; uwzględnić również metadane systemu plików. [Wolumeny][railway-volume-reference].

Free/trial nie traktujemy jako trwałego finansowania tej konfiguracji. Railway oferuje próbne 5 USD, potem Free z 1 USD miesięcznie; Fly nie ma stałego darmowego poziomu nowych kont, a Render Free nie udostępnia wymaganego dysku. [Railway][railway-pricing], [Fly][fly-cost], [Render][render-free].

### Shortlisted Platforms

#### 1. Railway (Recommended)

Najlepsze dopasowanie do pierwszego wdrożenia solo: natywna obsługa Java/Maven, proste środowiska, CLI/API i magazyn kopii w jednym projekcie. Amsterdam wystarczy dla Polski. Użytkownik zaakceptował koszty i ryzyka po ocenie; brak gwarancji nieprzerwanej dostępności przy pojedynczej instancji.

#### 2. Fly.io

Lepszy wybór, jeżeli po pomiarach niższa cena stanie się ważniejsza od wygody. Frankfurt, mała maszyna, wolumen i zintegrowany Tigris spełniają wymagania. Początkujący musi jednak pilnować konfiguracji jednej maszyny (`fly deploy` ma domyślnie `--ha=true`), lokalności wolumenu i poprawnej strategii wdrażania. [Deploy][fly-deploy], [wolumeny][fly-volumes].

#### 3. Render

Wygodna alternatywa z Frankfurtu, jeżeli 512 MB okaże się wystarczające lub zaakceptowany zostanie koszt 2 GB. Dysk wymaga płatnej usługi, a backup poza wolumenem wymaga obecnie zewnętrznej usługi albo dodatkowo zarządzanego rozwiązania. To słabiej odpowiada preferencji prostoty i jednego miejsca obsługi.

## Anti-Bias Cross-Check: Railway

Ocena obejmuje hipotezy awarii dla tego projektu, nie przewidywanie, że platforma zawiedzie. Wszystkie trzy perspektywy przedstawiono użytkownikowi przed zaakceptowaniem Railway.

### Devil's Advocate — Weaknesses

1. **Rachunek zależy od JVM i dodatkowych środowisk.** Minimum 5 USD nie pokrywa automatycznie każdej aplikacji Spring; mierzyć pamięć po rozgrzaniu i ustawić alerty. Twardy limit wydatków może zatrzymać usługę, więc jego wysokość musi być świadomie ustalona. [Ceny][railway-pricing], [kontrola kosztów][railway-cost].
2. **Wolumen oznacza jedną instancję i przestoje.** Railway nie dopuszcza replik usługi z wolumenem, a kolejne wdrożenie musi przejąć dysk; healthcheck nie eliminuje tej przerwy. Planować zmiany poza czasem wpisywania wyników. [Ograniczenia][railway-volume-reference].
3. **Kopia wolumenu nie dowodzi poprawności odtworzenia H2.** Dokumentacja opisuje snapshoty, ale nie daje gwarancji zgodności aplikacyjnej dla H2 2.4.240. Wyczyszczenie wolumenu usuwa jego kopie. Potrzebny spójny eksport H2 poza wolumen i próba odtworzenia. [Backup Railway][railway-backups], [H2][h2-tutorial].
4. **Rollback kodu nie naprawia schematu danych.** Przywraca obraz i konfigurację wdrożenia, a H2 zostaje w aktualnym stanie. Hobby przechowuje obrazy usuniętych wdrożeń przez 72 godziny; późniejszy powrót wymaga rebuild. Przed zmianą schematu wykonać eksport i ocenić zgodność starego kodu. [Retencja][railway-pricing], [rollback][railway-actions].

### Pre-Mortem — How This Could Fail

Po sześciu miesiącach aplikacja przestaje być wiarygodnym źródłem wyników. Na początku wybraliśmy najmniejszy budżet i uznaliśmy, że kilka osób nie obciąży serwera. Nie zmierzyliśmy jednak pamięci JVM po uruchomieniu pełnego logowania i przeliczania tabeli. Restartujące się procesy skłoniły nas do zwiększania zasobów, a pozostawione środowiska podglądowe podniosły rachunek. Włączyliśmy usypianie, żeby oszczędzić, przez co pierwsze wejście kibica zaczęło kończyć się błędem lub długim oczekiwaniem. Przy kolejnej aktualizacji zmieniliśmy schemat bazy i odkryliśmy, że cofnięcie wersji aplikacji nie cofa danych. Starszy kod nie umiał już odczytać nowych tabel. Spodziewaliśmy się łatwego powrotu do wcześniejszego wdrożenia, ale jego obraz wyszedł poza okres przechowywania. Kopie wolumenu istniały, lecz nigdy nie sprawdziliśmy ich odtwarzania z H2. Dodatkowe archiwa trzymaliśmy na tym samym dysku, więc nie stanowiły niezależnego zabezpieczenia. Pod presją czasu próbowaliśmy naprawiać konfigurację bez sprawdzonej procedury odzyskiwania. Ostatecznie administrator musiał ponownie wpisać część wyników, a użytkownicy zobaczyli niepełną tabelę. Przyczyną porażki było potraktowanie wygodnego hostingu jako gotowej obsługi bazy, kosztów i odzyskiwania danych.

### Unknown Unknowns

- **Migracje przed startem mogą trafić poza dysk.** Wolumen jest niedostępny podczas build i pre-deploy; H2 może w niewłaściwej lokalizacji utworzyć pustą bazę. Używać `DB_PATH=/data/skarb-kibica`, sprawdzić montowanie i wykonywać migracje dopiero w procesie mającym dostęp do wolumenu. [Mount][railway-volumes].
- **Zabezpieczony sekret nie przechodzi do preview.** Sealed variables nie są kopiowane do PR ani duplikowanych środowisk. Oddzielne hasła i dane testowe są konieczne, nawet gdy kod wdroży się poprawnie. [Variables][railway-variables].
- **Automatyczne wykrycie Javy nie buduje całego repo.** Railpack używa Java 21 i Maven Wrappera, lecz integracja Angulara 22.1 z backendem wymaga jawnego etapu Node/npm i kopiowania artefaktów. Angular CLI 22.1.8 wymaga Node `^22.22.3 || ^24.15.0 || >=26.0.0`; użyć zweryfikowanej linii 24. Lokalny proxy Angulara działa tylko podczas developmentu. [Railpack][railpack-java], lokalny `frontend/package-lock.json` i `README.md`.
- **Bucket nie daje niezmiennych kopii ani własnych snapshotów.** Brak object versioning, object locks i lifecycle rules; archiwa muszą mieć unikalne nazwy oraz ustaloną retencję. Railway Buckets i Fly Tigris korzystają z infrastruktury Tigris — wspólny panel nie oznacza niezależności fizycznego dostawcy. [Buckets][railway-buckets], [Fly/Tigris][fly-tigris].

## Operational Story

- **Preview deploys**: standardowe Railway PR Environments, osobny wolumen H2 i dane testowe; Railway generuje adres, gdy usługa bazowa używa Railway domain, i usuwa środowisko po zamknięciu/merge PR. Autor PR musi należeć do projektu/workspace. Przed wystawieniem podglądu zapewnić testowe uwierzytelnianie i osobne sekrety; sam losowy URL nie jest ochroną. Podglądy są dodatkowo płatne. Focused PR Environments (**beta / Priority Boarding**, 2026-09-22) nie są wymagane. [Environments][railway-environments].
- **Secrets**: `DB_PASSWORD` i przyszłe sekrety administratora w Variables usługi/środowiska, poufne wartości jako sealed; są dostępne buildowi/runtime, ale po zapieczętowaniu nie przez UI/API. Zwykłe zmienne mogą odczytać uprawnione konta/tokeny. Token projektu i środowiska trafia do `RAILWAY_TOKEN`, nigdy do repo lub rozmowy; `RAILWAY_API_TOKEN` oznacza szerszy token konta/workspace. Pierwsze linkowanie wykonywać po logowaniu użytkownika. Rotację głównego sekretu wykonuje człowiek; zmiana samego `DB_PASSWORD` nie zmienia automatycznie hasła istniejącego użytkownika H2. [Variables][railway-variables], [API/tokeny][railway-api].
- **Rollback**: Railway → usługa → Deployments → wybrane wcześniejsze poprawne wdrożenie → menu → Rollback; alternatywnie udokumentowana mutacja `deploymentRollback` po sprawdzeniu `canRollback`. Przywrócony obraz i custom variables wymagają sprawdzenia `/api/health`, logowania oraz danych H2. H2 i migracje nie cofają się automatycznie. Planowany czas próby odzyskania 5–15 minut jest celem do zmierzenia, nie gwarancją; obrazy poza retencją wymagają rebuild. [Deployment actions][railway-actions], [API wdrożeń][railway-deployment-api].
- **Approval**: pierwsza publikacja produkcyjna dopiero po zatwierdzeniu `context/deployment/deploy-plan.md`. W ramach zatwierdzonego zakresu agent może przygotować konfigurację, testy, podglądy i odczytywać logi. Docelowy auto-deploy po merge do `main` wymaga przygotowania kontroli CI i świadomego merge; ten dokument go nie konfiguruje. Usuwanie bazy/wolumenu/projektu i rotacja głównego sekretu należą do człowieka zgodnie z `AGENTS.md`. Odczytowy sposób pracy agenta na produkcji jest regułą operacyjną: token projektu Hobby **nie jest** tokenem tylko do odczytu. [Tokeny][railway-api].
- **Logs**: odczyt runtime: `railway logs --service backend --environment production --lines 100 --json`; build: to samo z `--build --latest`; strumień: bez `--lines`. Hobby przechowuje historię logów przez 7 dni. Nie wypisywać zmiennych, haseł ani credentials bucketu do logów. Wdrożenie z GitHub Actions zapisuje SHA, deployment ID i wynik testów HTTPS w podsumowaniu joba. [CLI logs][railway-logs], [limity planów][railway-pricing-page].

### Backup and recovery baseline

**Status po zatwierdzeniu wdrożenia:** poniższa rekomendacja nie jest realizowana
w MVP. Użytkownik 2026-09-22 zaakceptował brak backupów i ryzyko utraty danych;
mitigacja zostaje poza MVP. Nie traktować tego baseline jako aktywnej bramki.

Włączyć dzienne kopie wolumenu (retencja 6 dni); opcjonalne tygodniowe mają 27 dni, miesięczne 89 dni. Dokumentacja opisuje tę funkcję jako nadal rozwijaną, bez aktualnej etykiety beta; ograniczenia sprawdzono 2026-09-22. Manual backup ma limit 50% pojemności wolumenu, a restore działa tylko w tym samym projekcie i środowisku. Przywrócenie tworzy nowy wolumen i pozostawia poprzedni odłączony; nowsze snapshoty pozostają przy starym wolumenie. [Backups][railway-backups].

Niezależnie od snapshotów przygotować operację eksportu SQL `SCRIPT` lub spójnego `BACKUP TO` przez aktywne połączenie H2, a następnie przesłanie archiwum do prywatnego Railway Bucket w Amsterdamie (`ams`). Nie kopiować otwartego `.mv.db` zwykłym poleceniem plikowym; samodzielne narzędzie `org.h2.tools.Backup` wymaga zamkniętej bazy. Działanie `BACKUP TO` potwierdzono w kodzie H2 **2.4.240**. Mechanizm eksportu nie jest jeszcze zaimplementowany; dla MVP uruchamiać go po sesji aktualizacji wyników oraz przed zmianą schematu, bez dokładania stale działającego workera. [H2 tutorial][h2-tutorial], [kod właściwej wersji][h2-backup-source].

Proponowana retencja archiwów: 30 kolejnych kopii z datą/unikalnym identyfikatorem. Przed przyjęciem rzeczywistych danych przeprowadzić próbę odtworzenia do izolowanej bazy i porównać drużyny, mecze oraz wyniki; powtarzać po zmianie schematu/H2. Bucket chroni przed utratą wolumenu, ale wspólny projekt/konto pozostaje wspólną granicą awarii lub usunięcia. Automatyzację i docelowe RPO/RTO należy skonkretyzować w planie wdrożenia; nie są tu deklarowane jako istniejące zabezpieczenia.

## Risk Register

L/M/H oznacza niski/średni/wysoki poziom. Oceny są jakościowe dla małego MVP; ograniczenia techniczne są faktami wskazanymi w źródłach, prawdopodobieństwa stanowią ocenę projektową. Pierwotne mitigacje dotyczące kopii i restore poniżej są odroczone poza MVP decyzją właściciela z 2026-09-22; obecnie brak backupu, a ryzyko trwałej utraty danych jest zaakceptowane.

| Risk | Source | Likelihood | Impact | Mitigation |
|---|---|---|---|---|
| RAM JVM, CPU i podglądy zwiększą rachunek ponad oczekiwania | Devil's advocate | M | M | Zmierzyć zasoby po rozgrzaniu i podczas reprezentatywnego obciążenia; alerty, sprzątanie zamkniętych preview, świadomy limit kosztów. |
| Jedna instancja z H2 powoduje przestoje podczas wdrożenia/awarii | Devil's advocate | H | M | Jedna replika, healthcheck `/api/health`, wdrożenia poza sesjami administratora; zaakceptować krótkie przerwy i zmierzyć restart. |
| Snapshot nie odtwarza poprawnej H2 albo znika z wolumenem | Devil's advocate | M | H | Spójny eksport H2 do oddzielnego bucketu; próba odtworzenia przed danymi produkcyjnymi. |
| Rollback obrazu pozostawia niezgodny schemat H2 | Devil's advocate | M | H | Migracje zgodne wstecz, eksport przed zmianą i osobna procedura odzyskania danych. |
| Upłynie 72-godzinna retencja poprzedniego obrazu Hobby | Devil's advocate | M | M | Zapisać commit i konfigurację wydania, zachować wrapper/lockfile, sprawdzić odbudowę wcześniejszego wydania. |
| Usypianie powoduje wolny start lub pierwszy błąd 502 | Pre-mortem | M | M | Pozostawić Serverless/sleep wyłączone; ewentualną zmianę poprzedzić testem pierwszego żądania. [Serverless][railway-serverless]. |
| Pozorne kopie tylko na tym samym dysku nie uratują danych | Pre-mortem | M | H | Zweryfikować obecność eksportu w bucket, niezależnie od wolumenu; udokumentować i przećwiczyć restore. |
| Migracje/build zapiszą H2 poza właściwym wolumenem | Unknown unknowns | M | H | Bezwzględny `DB_PATH`, sprawdzenie montowania, migracje dopiero w runtime; test utrzymania danych po redeploy. |
| Preview nie otrzyma sealed secrets albo użyje danych produkcji | Unknown unknowns | M | H | Osobne testowe hasła, izolowany H2/bucket, kontrola dostępu i test po utworzeniu preview. |
| Build Javy pominie Angulara lub użyje niewłaściwego Node | Unknown unknowns | M | M | Jawne wspólne pakowanie; Java21, Node24.20.0, `npm ci`; test strony i `/api` pod jedną domeną. |
| Bucket bez wersjonowania/locków pozwoli nadpisać archiwa | Unknown unknowns | M | H | Unikalne nazwy, ograniczone credentials, jawna retencja; kasowanie materialnych kopii przez człowieka zgodnie z regułami repo. |
| Awaria/usunięcie całego konta obejmie aplikację i kopie | Unknown unknowns | L | H | Zanotować ograniczenie jednego dostawcy; okresowo pobierać zweryfikowaną, zaszyfrowaną kopię do miejsca kontrolowanego przez właściciela. |
| Rozwijane backupy mają ograniczenia restore i wielkości | Research finding | M | M | Uwzględnić limit 50%, monitorować miejsce, sprawdzić restore w izolowanym środowisku z pliku eksportu. |
| Token projektu zostanie uznany za produkcyjny read-only | Research finding | M | H | Token tylko dla konkretnego projektu/środowiska, bez konta głównego; kontrolować wykonywane operacje i bramkę zatwierdzenia. |
| Początkowe uprawnienia montowania uniemożliwią zapis H2 | Research finding | M | M | Zweryfikować UID i zapis do `/data` na preview; dobrać uprawnienia w przyszłej konfiguracji obrazu. [Wolumeny][railway-volume-reference]. |
| Łączenie CLI/MCP w beta lub experimental zmieni automatyzację | Research finding | L | M | Podstawą Railway CLI 5.59.0 i API; Vercel beta, Fly MCP experimental i Render object storage alpha nie są zależnościami wybranej ścieżki. |

## Getting Started

Poniższe kroki są historycznym przekazaniem do **planowania wdrożenia**, nie aktualnym zapisem wykonanych czynności. Ich zakres zmienił zatwierdzony [plan wdrożenia](../deployment/deploy-plan.md): trial 5 USD, bez backupów, bucketu, restore i płatnych środowisk PR. Stan utworzonych zasobów oraz CI jest w dzienniku planu. Polecenia zapisano dla CLI **5.59.0**; opcje `link`, `volume`, `up`, `domain` i `logs` zweryfikowano w dokumentacji i kodzie tej wersji. [Kod CLI][railway-cli-source].

1. **Przygotować i zatwierdzić plan.** W trybie planowania odczytać ten dokument oraz `tech-stack.md`, zapisać `context/deployment/deploy-plan.md`. Uwzględnić aktualizację odniesień Fly.io, wspólne pakowanie `frontend/dist/skarb-kibica/browser/` do zasobów Springa, routing SPA z zachowaniem `/api`, migracje i backup. Sprawdzić `npm ci` oraz `npm run build` w `frontend/` i `./mvnw verify` w katalogu głównym. Aktualny Maven sam nie dołącza Angulara; automatyczne wykrycie Java nie zapewnia Node do jego budowania.
2. **Po zatwierdzeniu planu przygotować konto i narzędzia.** Właściciel zakłada konto Hobby i ustawia rozliczenie/alerty. Zainstalować `npm install --global @railway/cli@5.59.0`, sprawdzić `railway --version`, wykonać `railway login`. Po utworzeniu projektu i usługi `backend` w Amsterdamie połączyć katalog: `railway link --project PROJECT_ID --environment production --service backend`. `PROJECT_ID` zastąpić rzeczywistym ID; pierwsze linkowanie korzysta z logowania użytkownika. Wybrać Railpack z jawnym etapem budowania frontendu lub przygotowany w następnym etapie obraz, zgodnie z zatwierdzonym planem.
3. **Przygotować runtime i trwały zapis przed publikacją.** Jedna replika, region `europe-west4-drams3a`, sleep wyłączony. Po sprawdzeniu, że wolumen jeszcze nie istnieje: `railway volume add --mount-path /data` w powiązanym projekcie/usłudze. Ustawić `DB_PATH=/data/skarb-kibica`, `PORT=8080`, `RAILPACK_JDK_VERSION=21` oraz poufne `DB_PASSWORD`; healthcheck `/api/health`. Punkt startowy istniejącego JAR-a: `java -jar target/skarb-kibica-ligi-koszykowki-0.0.1-SNAPSHOT.jar`, z lokalizacją artefaktu zgodną z finalnym buildem. H2 inicjalizować/migrować dopiero po zamontowaniu dysku.
4. **Przygotować odzyskiwanie i podgląd.** Prywatny bucket w `ams`, dzienne snapshoty, eksport H2 poza wolumen; próba restore na danych testowych. Zbudować preview z odrębnymi danymi i sekretami. Zweryfikować pamięć, restart, ponowne wdrożenie, stronę Angulara, trasy SPA oraz `/api/health`. Pierwszy deploy szkieletu może sprawdzić połączenie z bazą; weryfikacja logowania i danych biznesowych wymaga implementacji tych funkcji.
5. **Wykonać zatwierdzone wdrożenie i sprawdzić wynik.** `railway up --service backend --environment production --json`; następnie dla świadomego wystawienia usługi `railway domain --service backend --environment production --port 8080 --json`. `up` nie tworzy sam publicznej domeny. Sprawdzić status wdrożenia, HTTPS strony, `/api/health`, logi i trwałość zapisanych danych po restarcie/redeploy. `--detach` potwierdza tylko zakolejkowanie, więc wymaga dodatkowego sprawdzenia statusu. Zmierzyć czas rollbacku i udokumentować stan wdrożenia w planie. [Up][railway-up], [domain][railway-domain], [volumes][railway-volume-cli].

Lokalny development pozostaje zgodny z repozytorium: `./mvnw spring-boot:run` oraz `npm start` w `frontend/`. Nie potrzeba adaptera edge ani osobnego emulatora platformy. Biblioteki/frameworki nie są aktualizowane w ramach wyboru hostingu. Stare przykłady Nixpacks i starszych Spring Bootów nie określają konfiguracji tego projektu; źródłem wersji są manifesty i lockfile oraz bieżący Railpack. [Railpack Java][railpack-java].

## Out of Scope

- Konfiguracja i budowanie obrazów Docker oraz zapisywanie Dockerfile.
- Konfiguracja pipeline CI/CD.
- Wdrażanie produkcji i nadawanie agentowi dostępu do konta.
- Zmiana Spring Boot/Angular/H2 na inny stack.
- Architektura wieloregionowa, HA i pełne DR dla dużej produkcji.

Następny etap w tym repozytorium, zgodnie z `AGENTS.md`: **Plan Mode deploy**. Prompt: „Wykonajmy pierwsze wdrożenie w oparciu o `context/foundation/infrastructure.md`, zgodnie ze stackiem z `context/foundation/tech-stack.md`. Najpierw przygotuj plan do zatwierdzenia w `context/deployment/deploy-plan.md`”. Nie rozpoczynać automatycznie implementacji ani wdrożenia.

## Evidence

Weryfikacja dokumentacji i cen: **2026-09-22**. Badania platform prowadzono równolegle; ocena ryzyka została wykonana przez głównego agenta. Źródła oficjalne są nadrzędne wobec starszych poradników. Brak etykiety beta w dokumentacji oznacza brak znalezionego zastrzeżenia, nie formalne potwierdzenie GA. Statusy beta/experimental/alpha wskazano przy konkretnych funkcjach; nie są one podstawą wybranego runtime Railway.

[railpack-java]: https://railpack.com/languages/java/
[railway-regions]: https://docs.railway.com/deployments/regions
[railway-pricing]: https://docs.railway.com/pricing/plans
[railway-pricing-page]: https://railway.com/pricing
[railway-cost]: https://docs.railway.com/pricing/cost-control
[railway-volumes]: https://docs.railway.com/volumes
[railway-volume-reference]: https://docs.railway.com/volumes/reference
[railway-volume-cli]: https://docs.railway.com/cli/volume
[railway-backups]: https://docs.railway.com/volumes/backups
[railway-buckets]: https://docs.railway.com/storage-buckets
[railway-up]: https://docs.railway.com/cli/up
[railway-domain]: https://docs.railway.com/cli/domain
[railway-logs]: https://docs.railway.com/cli/logs
[railway-api]: https://docs.railway.com/integrations/api
[railway-deployment-api]: https://docs.railway.com/integrations/api/manage-deployments
[railway-actions]: https://docs.railway.com/deployments/deployment-actions
[railway-mcp]: https://docs.railway.com/ai/mcp-server
[railway-environments]: https://docs.railway.com/environments
[railway-variables]: https://docs.railway.com/variables
[railway-serverless]: https://docs.railway.com/deployments/serverless
[railway-cli-source]: https://github.com/railwayapp/cli/tree/v5.59.0/src/commands
[h2-tutorial]: https://h2database.com/html/tutorial.html
[h2-backup-source]: https://github.com/h2database/h2database/blob/version-2.4.240/h2/src/main/org/h2/command/dml/BackupCommand.java
[cloudflare-containers]: https://developers.cloudflare.com/containers/faq/
[cloudflare-pricing]: https://developers.cloudflare.com/containers/platform/pricing/
[cloudflare-cli]: https://developers.cloudflare.com/workers/wrangler/commands/workers/
[cloudflare-mcp]: https://developers.cloudflare.com/agents/model-context-protocol/cloudflare/servers-for-cloudflare/
[vercel-containers]: https://vercel.com/docs/functions/container-images
[vercel-state]: https://vercel.com/kb/guide/docker-compose-concepts-on-vercel
[vercel-pricing]: https://vercel.com/pricing
[vercel-mcp]: https://vercel.com/docs/agent-resources/vercel-mcp
[vercel-rollback]: https://vercel.com/docs/cli/rollback
[netlify-functions]: https://docs.netlify.com/build/functions/overview/
[netlify-cli]: https://cli.netlify.com/commands/deploy/
[netlify-mcp]: https://github.com/netlify/netlify-mcp
[netlify-pricing]: https://www.netlify.com/pricing/
[fly-api]: https://fly.io/docs/machines/api/
[fly-volumes]: https://fly.io/docs/volumes/overview/
[fly-pricing]: https://fly.io/docs/about/pricing/
[fly-cost]: https://fly.io/docs/about/cost-management/
[fly-deploy]: https://fly.io/docs/flyctl/deploy/
[fly-mcp]: https://fly.io/docs/mcp/flyctl-server/
[fly-mcp-status]: https://fly.io/docs/blueprints/remote-mcp-servers/
[fly-tigris]: https://fly.io/docs/tigris/
[tigris-pricing]: https://www.tigrisdata.com/pricing/
[render-faq]: https://render.com/docs/faq
[render-cli]: https://render.com/docs/cli-reference
[render-rollback]: https://api-docs.render.com/reference/rollback-deploy
[render-disks]: https://render.com/docs/disks
[render-mcp]: https://render.com/docs/mcp-server
[render-storage]: https://feedback.render.com/features/p/cloud-object-storage
[render-pricing]: https://render.com/pricing
[render-bandwidth]: https://render.com/docs/outbound-bandwidth
[render-free]: https://render.com/docs/free
