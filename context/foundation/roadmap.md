---
project: Skarb kibica ligi koszykówki
version: 1
status: draft
created: 2026-09-23
updated: 2026-09-23
prd_version: 1
main_goal: speed
top_blocker: time
milestone_id: usable-regular-season
milestone_seq: 1
milestone_status: open
---

# Roadmap: Skarb kibica ligi koszykówki

> Źródło: PRD v1 oraz stan kodu zbadany automatycznie i potwierdzony przez użytkownika.
> Dokument jest rozwijany w miejscu; pełne zastąpienie wymaga zachowania poprzedniej wersji zgodnie z konwencją dokumentów foundation.
> Elementy są uporządkowane według zależności. Tabela „At a glance” jest indeksem.

## Milestone

**M-1: Użyteczna obsługa fazy zasadniczej** — Status: open

- **Intent:** Administrator przygotowuje sezon, publikuje wyniki i poprawia błędy; kibic bez logowania znajduje terminarz, wyniki i poprawną tabelę fazy zasadniczej PLK 2026–2027.
- **Source materials:** `context/foundation/prd.md` (v1); pomocniczo `context/foundation/shape-notes.md`, `context/foundation/tech-stack.md`, `context/foundation/infrastructure.md` i `context/deployment/deploy-plan.md`. PRD określa funkcje i reguły; zaakceptowane aktualizacje wdrożenia określają obecny zakres operacyjny.
- **Done when:** każde S-01–S-06 ma status `done`; spełnione są warunki trwałości, wyłączności zapisu administratora i poprawności tabeli z PRD. Dodatkowo co najmniej 2 z 3 kibiców przy pierwszym użyciu, bez pomocy, znajduje wynik wskazanego meczu, miejsce wybranej drużyny i jej następnego rywala w ciągu łącznie 60 sekund od otwarcia aplikacji.
- **Scope anchors:** FR-001, FR-002, FR-003, FR-004, FR-005, FR-006, FR-007, US-01, US-02; PRD §Success Criteria, §Non-Functional Requirements, §Business Logic i §Access Control.

Użytkownik wybrał sprawne ukończenie MVP (`main_goal: speed`) i ograniczony czas pracy jako główne utrudnienie (`top_blocker: time`). Kolejność wynika z zależności i zamkniętego zakresu PRD; roadmapa nie ustala harmonogramu. Głębsza weryfikacja dotyczy backendu: reguł klasyfikacji oraz uprawnień do zapisu (PRD §Success Criteria, warunki poprawności). Frontend, dane i infrastruktura pozostają proste; wymagania trwałości i użyteczności nadal obowiązują.

## Vision recap

Kibic Polskiej Ligi Koszykówki szuka par meczowych przed kolejką, wyników i aktualnej tabeli po meczach oraz par zaplanowanych na przyszłe kolejki. Informacje rozproszone po różnych stronach są nieaktualne i trudno je znaleźć w przyjaznej formie, co kosztuje kibica czas i powoduje frustrację. „Skarb kibica ligi koszykówki” ma w sezonie 2026–2027 udostępniać te informacje w jednym, czytelnym miejscu, oszczędzając czas na ich szukaniu.

## North star

Gwiazda przewodnia oznacza tutaj najmniejszy przepływ od początku do końca, który potwierdza główną wartość produktu; realizujemy go tak wcześnie, jak pozwalają zależności.

**S-05: Kibic widzi poprawną tabelę po zapisaniu wyniku.** Wraz z wcześniejszymi S-01–S-04 domyka główny scenariusz US-01: administrator wprowadza dane, a kibic znajduje wynik, klasyfikację i kolejne pary. To wybrany przez użytkownika pierwszy dowód działania produktu, zgodny z PRD §Success Criteria. S-05 sam dodaje klasyfikację, korzystając z już dostarczonych funkcji; S-06 pozostaje konieczną częścią pełnego MVP.

## At a glance

| ID | Change ID | Outcome (user can …) | Prerequisites | PRD refs | Status |
| --- | --- | --- | --- | --- | --- |
| S-01 | administrator-access | Administrator może zalogować się e-mailem i hasłem na przygotowane konto i uzyskać dostęp do zarządzania; kibic zachowuje publiczny odczyt. | — | FR-001, PRD §Access Control | ready |
| S-02 | season-teams | Administrator może zdefiniować drużyny fazy zasadniczej sezonu 2026–2027 i ponownie odczytać zapisaną listę. | S-01 | FR-002, US-01, PRD §Non-Functional Requirements | proposed |
| S-03 | public-round-schedule | Kibic może bez logowania sprawdzić pary bieżącej i przyszłych rund przygotowane przez administratora, wraz z aktualnym terminem i statusem meczu bez wyniku. | S-02 | FR-003, FR-005, FR-007, US-01 | proposed |
| S-04 | publish-match-results | Administrator może zapisać lub skorygować wynik meczu, także walkower, a kibic od razu zobaczyć aktualny wynik i status „zakończony”. | S-03 | FR-004, FR-005, US-01, PRD §Non-Functional Requirements | proposed |
| S-05 | automatic-league-standings | Kibic może bez logowania zobaczyć tabelę poprawnie przeliczoną po każdym zapisie lub korekcie wyniku, także przy niekompletnej rundzie i remisach punktowych. | S-04 | FR-006, US-01, PRD §Business Logic, PRD §Success Criteria | proposed |
| S-06 | correct-match-teams | Administrator może poprawić drużynę przypisaną do meczu przed lub po zapisaniu wyniku, a kibic zobaczyć poprawione pary i tabelę bez wpływu starego przypisania. | S-05 | FR-003, FR-006, US-02 | proposed |

FR-003 jest pokrywane łącznie przez S-03 i S-06, a FR-005 przez S-03 i S-04. US-01 rozwija się przez przygotowanie danych i ich publikację, a pełny scenariusz domyka S-05. US-02 domyka S-06. Wymagania niefunkcjonalne nie mają własnych ID w PRD, dlatego odwołania wskazują istniejące sekcje.

## Baseline

Stan na 2026-09-23, zbadany w repozytorium i potwierdzony przez użytkownika. Wybory technologii przyjęto zgodnie z `tech-stack.md`; statusy poniżej opisują wykonany zakres, nie sam wybór narzędzia.

- **Frontend:** partial — szkielet Angulara z klientem HTTP i routerem istnieje; brak widoków produktu, tablica tras jest pusta (`frontend/src/app/app.config.ts:6`, `frontend/src/app/app.routes.ts:3`).
- **Backend / API:** partial — szkielet Spring Boot, serwowanie interfejsu i kontrola stanu istnieją; brak operacji domenowych (`src/main/java/pl/skarbkibica/web/SpaWebConfiguration.java:24`, `src/main/resources/application.properties:13`).
- **Data:** partial — plikowa H2 jest skonfigurowana, istnieje test trwałości; brak modelu ligi i migracji (`src/main/resources/application.properties:6`, `src/test/java/pl/skarbkibica/H2PersistenceTests.java:17`).
- **Auth:** absent — brak logowania, przygotowanego konta i ochrony zapisu. `has_auth: true` w dokumencie stosu oznacza wymagany zakres, nie wykonanie (`pom.xml:32`; przegląd `src/main` i `frontend/src`).
- **Deploy / infra:** present — wspólny kontener, kontrole i automatyczne wdrażanie są przygotowane (`Dockerfile:19`, `.github/workflows/ci.yml:32`). Dziennik wdrożenia potwierdza wcześniejszą publikację, restart i ponowne wdrożenie; przy tworzeniu roadmapy nie sprawdzano ponownie usługi zewnętrznej.
- **Observability:** partial — podstawowa kontrola stanu i logi wdrożeń istnieją; brak dodatkowego śledzenia błędów i eksportu metryk (`src/main/resources/application.properties:13`, `scripts/deploy-railway.sh:128`). PRD nie wymaga osobnego rozbudowanego systemu diagnostyki.

Wcześniejsza weryfikacja infrastruktury nie dowodzi zachowania konkretnego wyniku meczu na produkcji. Sprawdzenie trwałości danych produktu należy do S-02 i S-04; kryteria funkcji są sprawdzane w Chrome na komputerze. Kopie i odtwarzanie są poza MVP zgodnie z zaakceptowaną decyzją właściciela; trwały wolumen nie jest kopią. Przejście z okresu próbnego na płatne utrzymanie i konfiguracja limitów pozostają zadaniem właściciela zapisanym w planie wdrożenia, bez blokowania lokalnego planowania funkcji.

Nie ma `context/foundation/lessons.md` ani `docs/reference/contract-surfaces.md`. Notatki przygotowawcze nie zawierają sekcji `Forward: technical-roadmap`.

## Foundations

Brak osobnych elementów F-NN. Szkielet i wdrażanie są już przygotowane. Logowanie stanowi widoczną funkcję S-01; minimalne migracje i weryfikacja zapisu danych pojawiają się w S-02, a dalszy model oraz reguły wraz z pierwszymi funkcjami, które ich używają. Żadna znana niewiadoma nie wymaga oddzielnego etapu technicznego przed zaplanowaniem tych funkcji.

## Slices

Każdy przekrój obejmuje potrzebne elementy interfejsu, logiki i danych oraz sprawdzenie całej ścieżki użytkownika. Każda nowa operacja zapisu pozostaje dostępna wyłącznie dla administratora; odczyt kibica jest publiczny. `proposed` oznacza oczekiwanie na poprzedni przekrój, a nie nierozstrzygniętą decyzję.

Graf tworzy jeden łańcuch zależności. Nie wyodrębniamy strumieni ani równoległych wdrożeń funkcji: każdy kolejny rezultat konsumuje możliwość poprzedniego.

### S-01: Dostęp przygotowanego administratora

- **Outcome:** Administrator może zalogować się e-mailem i hasłem na przygotowane konto i uzyskać dostęp do zarządzania; kibic zachowuje publiczny odczyt.
- **Change ID:** administrator-access
- **PRD refs:** FR-001, PRD §Access Control
- **Prerequisites:** —
- **Parallel with:** —
- **Blockers:** —
- **Unknowns:** —
- **Risk:** Ochrona musi działać także przy bezpośrednim żądaniu zapisu; dlatego dostęp administratora poprzedza pierwsze dane sezonu.
- **Status:** ready

Pełna ścieżka od formularza logowania do rozpoznania administratora i ochrony operacji zapisu po stronie aplikacji. Brak publicznej rejestracji. Kolejne przekroje obejmują ochroną każdą dodawaną operację zmiany danych.

### S-02: Zdefiniowanie drużyn sezonu

- **Outcome:** Administrator może zdefiniować drużyny fazy zasadniczej sezonu 2026–2027 i ponownie odczytać zapisaną listę.
- **Change ID:** season-teams
- **PRD refs:** FR-002, US-01, PRD §Non-Functional Requirements
- **Prerequisites:** S-01
- **Parallel with:** —
- **Blockers:** —
- **Unknowns:** —
- **Risk:** Pierwszy zapis danych sezonu musi przetrwać aktualizację aplikacji; istniejący test technicznej trwałości nie zastępuje sprawdzenia zapisanej drużyny.
- **Status:** proposed

Zapis i odczyt rzeczywistych danych przez interfejs administratora. Ten przekrój wprowadza minimalne wersjonowanie zmian danych potrzebne drużynom i weryfikuje zachowanie wpisów po ponownym uruchomieniu oraz aktualizacji aplikacji; dalszy model powstaje wraz z kolejnymi funkcjami.

### S-03: Publiczny terminarz rund

- **Outcome:** Kibic może bez logowania sprawdzić pary bieżącej i przyszłych rund przygotowane przez administratora, wraz z aktualnym terminem i statusem meczu bez wyniku.
- **Change ID:** public-round-schedule
- **PRD refs:** FR-003, FR-005, FR-007, US-01
- **Prerequisites:** S-02
- **Parallel with:** —
- **Blockers:** —
- **Unknowns:** —
- **Risk:** Błędne przypisanie jednej drużyny do kilku meczów rundy podważa późniejsze wyniki, dlatego reguła spójności obowiązuje już przy tworzeniu terminarza.
- **Status:** proposed

Administrator ręcznie tworzy rundy i mecze oraz koryguje termin. Przy zapisie każda drużyna występuje maksymalnie raz w rundzie. Brak wyniku daje status „zaplanowany” dla przyszłego terminu albo „oczekuje na wynik” po jego upływie. Korekta przypisanej drużyny jest domykana w S-06, a status „zakończony” w S-04.

### S-04: Publikowanie i korygowanie wyników

- **Outcome:** Administrator może zapisać lub skorygować wynik meczu, także walkower, a kibic od razu zobaczyć aktualny wynik i status „zakończony”.
- **Change ID:** publish-match-results
- **PRD refs:** FR-004, FR-005, US-01, PRD §Non-Functional Requirements
- **Prerequisites:** S-03
- **Parallel with:** —
- **Blockers:** —
- **Unknowns:** —
- **Risk:** Korekta musi zastępować poprzedni wynik, a walkower zachować swoje znaczenie; samo wpisanie zwykłego wyniku 20:0 nie wystarczy do poprawnej klasyfikacji.
- **Status:** proposed

Zapisany wynik nadaje status „zakończony” niezależnie od terminu meczu. Pojedynczy wynik jest dostępny bez logowania także przy niekompletnej rundzie i pozostaje zapisany po odświeżeniu, zamknięciu przeglądarki oraz ponownym uruchomieniu aplikacji. Dla walkoweru administrator wskazuje zwycięzcę; zapis zachowuje to rozstrzygnięcie, automatyczny wynik 20:0 i punktację klasyfikacyjną 2:0. Publiczną tabelę wykorzystującą tę punktację dostarcza S-05.

### S-05: Tabela reagująca na zapis wyniku

- **Outcome:** Kibic może bez logowania zobaczyć tabelę poprawnie przeliczoną po każdym zapisie lub korekcie wyniku, także przy niekompletnej rundzie i remisach punktowych.
- **Change ID:** automatic-league-standings
- **PRD refs:** FR-006, US-01, PRD §Business Logic, PRD §Success Criteria
- **Prerequisites:** S-04
- **Parallel with:** —
- **Blockers:** —
- **Unknowns:** —
- **Risk:** Reguły remisów mogą dawać wiarygodnie wyglądającą, błędną kolejność; sprawdzenie przypadków z PRD następuje przy pierwszej publicznej tabeli.
- **Status:** proposed

Obejmuje punktację 2/1/0, walkowery, regułę przed kompletem spotkań bezpośrednich, pełną hierarchię po ich skompletowaniu i ponowienie procedury dla remisującej podgrupy. Brak rozstrzygnięcia daje ex aequo z powtórzonym numerem pozycji i alfabetem wyłącznie do prezentacji, również przed pierwszą rundą i na koniec fazy. Wraz z dostarczonymi wynikami i terminarzem przekrój udostępnia pełną ścieżkę znalezienia wyniku, miejsca drużyny i jej następnego rywala oraz weryfikuje dodatkowe kryterium sukcesu PRD.

### S-06: Korekta drużyny bez błędnej klasyfikacji

- **Outcome:** Administrator może poprawić drużynę przypisaną do meczu przed lub po zapisaniu wyniku, a kibic zobaczyć poprawione pary i tabelę bez wpływu starego przypisania.
- **Change ID:** correct-match-teams
- **PRD refs:** FR-003, FR-006, US-02
- **Prerequisites:** S-05
- **Parallel with:** —
- **Blockers:** —
- **Unknowns:** —
- **Risk:** Zmiana uczestnika rozegranego meczu może pozostawić naliczenia starej drużyny; ten przekrój korzysta z działającego zapisu wyników i pełnej tabeli.
- **Status:** proposed

Korekta zachowuje maksymalnie jedno wystąpienie drużyny w rundzie. Przy istniejącym wyniku wymaga potwierdzenia jego poprawności i ponownie wylicza klasyfikację dla poprawionych drużyn, również dla zapisanego walkoweru. Domyka część FR-003 odłożoną z S-03.

## Backlog Handoff

| Roadmap ID | Change ID | Suggested issue title | Ready for `/10x-plan` | Notes |
| --- | --- | --- | --- | --- |
| S-01 | administrator-access | Dostęp przygotowanego administratora | yes | `/10x-plan administrator-access` |
| S-02 | season-teams | Zdefiniowanie drużyn sezonu | no | Po ukończeniu S-01. |
| S-03 | public-round-schedule | Publiczny terminarz rund | no | Po ukończeniu S-02. |
| S-04 | publish-match-results | Publikowanie i korygowanie wyników | no | Po ukończeniu S-03. |
| S-05 | automatic-league-standings | Tabela reagująca na zapis wyniku | no | Po ukończeniu S-04. |
| S-06 | correct-match-teams | Korekta drużyny bez błędnej klasyfikacji | no | Po ukończeniu S-05. |

Pierwszy rekomendowany ruch: zaplanować S-01 (`administrator-access`). Ma spełnione warunki wejścia i odblokowuje cały łańcuch do S-05. Foldery zmian powstają dopiero w dalszym procesie; ta roadmapa ich nie tworzy.

## Open Roadmap Questions

Brak nierozstrzygniętych pytań z dotychczasowych rund discovery. Dodatkowe kryterium sukcesu doprecyzowano podczas końcowej kontroli kompletności.

Wywiad i analiza stanu kodu nie ujawniły nowych decyzji blokujących kolejność prac. Ustalone w PRD reguły klasyfikacji są kontraktem MVP; roadmapa nie deklaruje ponownej weryfikacji zewnętrznych regulaminów.

## Parked

- **Play-off i pozostałe fazy rozgrywek** — Why parked: PRD §Non-Goals ogranicza MVP do fazy zasadniczej.
- **Oficjalna kolejność po losowaniu** — Why parked: PRD §Non-Goals pozostawia nierozstrzygnięte miejsca ex aequo.
- **Wersja mobilna** — Why parked: PRD §Non-Goals wskazuje aplikację na komputer; obsługiwane środowisko to Chrome.
- **Automatyczny import terminarza i wyników** — Why parked: PRD §Non-Goals przewiduje ręczne wprowadzanie przez administratora.
- **Wyniki na żywo i wyniki kwart** — Why parked: PRD §Non-Goals ogranicza dane do wyników końcowych.
- **Inne ligi i sezony** — Why parked: PRD §Non-Goals ogranicza MVP do PLK 2026–2027.
- **Składy i statystyki zawodników** — Why parked: PRD §Non-Goals skupia zakres na drużynach, meczach i tabeli.
- **Kopie zapasowe, eksport bazy i odtwarzanie** — Why parked: Zaakceptowana aktualizacja planu wdrożenia pozostawia je poza MVP wraz z ryzykiem utraty danych; nie blokują planowania funkcji.
- **Płatne środowiska podglądowe dla zmian** — Why parked: Zatwierdzony plan wdrożenia wykorzystuje istniejące kontrole kontenera; osobne środowiska pozostają odroczone.

## Milestone History

## Done

