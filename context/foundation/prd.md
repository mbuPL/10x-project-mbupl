---
project: Skarb kibica ligi koszykówki
version: 1
status: draft
created: 2026-09-17
context_type: greenfield
product_type: web-app
target_scale:
  users: small
timeline_budget:
  mvp_weeks: 4
  after_hours_only: true
  hard_deadline: 2026-10-20
---

# Skarb kibica ligi koszykówki

## Vision & Problem Statement

Kibic Polskiej Ligi Koszykówki szuka par meczowych przed kolejką, wyników i aktualnej tabeli po meczach oraz par zaplanowanych na przyszłe kolejki. Informacje rozproszone po różnych stronach są nieaktualne i trudno je znaleźć w przyjaznej formie, co kosztuje kibica czas i powoduje frustrację.

„Skarb kibica ligi koszykówki” ma w sezonie 2026–2027 udostępniać te informacje w jednym, czytelnym miejscu, oszczędzając czas na ich szukaniu. Zakres MVP obejmuje wyłącznie fazę zasadniczą Polskiej Ligi Koszykówki w tym sezonie. Użytkownik zakłada, że stukrotny wzrost liczby odbiorców nie wymaga zmiany zasad tabeli ani ręcznego uzupełniania danych przez jednego administratora.

## User & Persona

Główny odbiorca: kibic śledzący Polską Ligę Koszykówki w sezonie 2026–2027. Korzysta z aplikacji przed meczami, aby sprawdzić, kto z kim gra w danej kolejce; po meczach, aby poznać wyniki i aktualną tabelę; oraz przy sprawdzaniu par przyszłych kolejek.

Przewidywana początkowa liczba użytkowników: autor projektu i kilka osób. To założenie dotyczące skali, a nie zmiana ustalonego publicznego dostępu bez logowania.

## Success Criteria

### Primary

- Administrator może przygotować drużyny i terminarz fazy zasadniczej sezonu 2026–2027, definiując rundy i mecze, a po rundzie zapisać wyniki meczów.
- Kibic bez logowania może sprawdzić zapisane wyniki rundy, automatycznie wyliczoną tabelę oraz pary kolejnych rund.

### Secondary

- Co najmniej 2 z 3 kibiców przy pierwszym użyciu, bez pomocy, znajdzie wynik wskazanego meczu, miejsce wybranej drużyny w tabeli i jej następnego rywala w ciągu łącznie 60 sekund od otwarcia aplikacji.

### Guardrails

- Wyniki są zapisywane trwale i nie giną po zakończeniu korzystania z aplikacji.
- Kibic nie może zmieniać danych.
- Kolejność drużyn w tabeli jest wyznaczana poprawnie według punktacji i reguł opisanych w Business Logic, także przy równej liczbie punktów. Całkowicie nierozstrzygnięta kolejność jest prezentowana jako ex aequo; alfabetyczna kolejność drużyn na wspólnym miejscu nie stanowi kryterium klasyfikacji sportowej.

## User Stories

### US-01: Kibic sprawdza wyniki, tabelę i kolejne rundy

- **Given** administrator przygotował drużyny i terminarz fazy zasadniczej sezonu 2026–2027, a kibic korzysta z aplikacji bez logowania.
- **When** administrator zapisuje wynik meczu, a kibic przegląda wyniki rundy, tabelę i kolejne rundy.
- **Then** kibic widzi zapisany wynik, tabelę automatycznie przeliczoną na podstawie dotychczas zapisanych wyników oraz pary kolejnych rund.

#### Acceptance Criteria

- Zapisany wynik jest od razu dostępny dla kibica.
- Tabela uwzględnia dotychczas zapisane wyniki, także gdy nie wprowadzono jeszcze wszystkich wyników danej rundy.
- Widoczność zapisanego wyniku i aktualizacja tabeli nie wymagają kompletu wyników rundy.
- Przeglądanie wyników, tabeli i par kolejnych rund nie wymaga konta ani logowania.
- Kolejność drużyn ma być poprawna również przy równej liczbie punktów, z uwzględnieniem meczów bezpośrednich, dalszych kryteriów i ponawiania procedury dla pozostałych remisujących drużyn zgodnie z Business Logic.
- Przy równej liczbie punktów przed kompletem spotkań bezpośrednich o kolejności decydują ogólna różnica punktów zdobytych i straconych oraz liczba zdobytych punktów.
- Zwycięstwo daje 2 punkty klasyfikacyjne, porażka 1, przegrana walkowerem 0; walkowery są uwzględniane w MVP.
- Jeżeli przyjęte kryteria nie rozdzielają drużyn, zajmują one miejsce ex aequo z powtórzonym numerem pozycji i alfabetyczną kolejnością wewnątrz grupy; dotyczy to również okresu przed pierwszą kolejką i w trakcie sezonu.
- Całkowity remis na koniec fazy pozostaje nierozstrzygnięty i jest prezentowany jako ex aequo; MVP nie obsługuje wpisania kolejności po losowaniu.
- Status meczu wynika automatycznie z wyniku i terminu: zapisany wynik oznacza „zakończony”, przyszły termin bez wyniku oznacza „zaplanowany”, a upływ terminu bez wyniku oznacza „oczekuje na wynik”.
- Wskazanie zwycięzcy walkoweru daje automatycznie wynik koszowy 20:0 na jego korzyść i punkty klasyfikacyjne 2:0.

### US-02: Administrator koryguje drużynę przypisaną do meczu

- **Given** administrator jest zalogowany i przygotowuje lub poprawia terminarz rundy.
- **When** koryguje drużynę przypisaną do meczu.
- **Then** może zapisać poprawne przypisanie z zachowaniem zasady, że każda drużyna występuje w rundzie maksymalnie raz.

#### Acceptance Criteria

- Administrator może skorygować drużynę przypisaną do meczu.
- Nie można zapisać przypisania naruszającego zasadę maksymalnie jednego wystąpienia drużyny w rundzie.
- Reguła obowiązuje zarówno przy przygotowaniu, jak i korekcie terminarza.
- Korekta drużyny jest możliwa także po zapisaniu wyniku meczu, pod warunkiem potwierdzenia poprawnego wyniku przez administratora.
- Po korekcie tabela uwzględnia wynik dla poprawionego przypisania drużyn, bez pozostawienia wpływu błędnego przypisania.

## Functional Requirements

### Dostęp administratora

- FR-001: Administrator może zalogować się e-mailem i hasłem na wcześniej przygotowane konto. Priority: must-have
  > Socrates: Rozważono ryzyko zatrzymania aktualizacji po utracie hasła przez jedynego administratora. Odpowiedź użytkownika: C — kontrargument nie uzasadnia zmiany; wymaganie pozostaje bez zmian.

### Przygotowanie sezonu i wyniki

- FR-002: Administrator może zdefiniować drużyny uczestniczące w fazie zasadniczej sezonu 2026–2027. Priority: must-have
  > Socrates: Rozważono zastąpienie definiowania drużyn listą przygotowaną z góry dla jednego sezonu. Odpowiedź użytkownika: C — kontrargument nie uzasadnia zmiany; wymaganie pozostaje bez zmian.
- FR-003: Administrator może ręcznie wprowadzić terminarz fazy zasadniczej, definiując rundy i mecze, oraz skorygować termin i drużynę przypisaną do meczu, także po zapisaniu wyniku po potwierdzeniu jego poprawności i z przeliczeniem tabeli, z zachowaniem maksymalnie jednego przypisania każdej drużyny w danej rundzie. Priority: must-have
  > Socrates: Korekta daty nie naprawia błędnego przypisania drużyn do meczu. Odpowiedź użytkownika: A — dodano korektę przypisanej drużyny oraz zasadę maksymalnie jednego przypisania każdej drużyny w danej rundzie.
- FR-004: Administrator może wprowadzać i korygować wyniki pojedynczych meczów, w tym wskazać zwycięzcę walkoweru, dla którego aplikacja automatycznie ustala wynik koszowy 20:0 i punkty klasyfikacyjne 2:0. Priority: must-have
  > Socrates: Rozważono ryzyko natychmiastowego wpływu błędnego wyniku na publiczną tabelę oraz brak szczegółowych zasad walidacji. Odpowiedź użytkownika: C — kontrargument nie uzasadnia zmiany; wymaganie pozostaje bez zmian.

### Przeglądanie informacji przez kibica

- FR-005: Kibic może bez logowania przeglądać wyniki meczów danej rundy od razu po ich zapisaniu, także gdy runda ma niekompletne wyniki, oraz rozróżniać automatyczne statusy „zakończony”, „zaplanowany” i „oczekuje na wynik” zgodnie z Business Logic. Priority: must-have
  > Socrates: Lista samych wyników może sugerować, że niekompletna runda jest już zakończona. Odpowiedź użytkownika: A — należy wyróżniać mecze zakończone od tych, które jeszcze się nie odbyły; na etapie rundy pytań mechanizm ustalania statusu nie był jeszcze wybrany, a doprecyzowano go w etapie 5.
- FR-006: Kibic może bez logowania przeglądać tabelę automatycznie przeliczaną po zapisaniu wyniku z dotychczas zapisanych wyników według reguł z Business Logic, także przy równej liczbie punktów, z pozycjami ex aequo i alfabetyczną kolejnością drużyn na wspólnym miejscu, gdy kryteria nie rozstrzygają kolejności. Priority: must-have
  > Socrates: Bez jednoznacznych zasad rozstrzygania równej liczby punktów nie można ocenić poprawności tabeli. Odpowiedź użytkownika: A — ustalamy jednoznaczne reguły; użytkownik wskazał pierwszeństwo wyników bezpośrednich meczów dwóch lub większej liczby drużyn. Dalsze kryteria doprecyzowano w etapie 5.
- FR-007: Kibic może bez logowania sprawdzać pary meczowe bieżącej i przyszłych rund. Priority: must-have
  > Socrates: Rozważono ryzyko dezaktualizacji ręcznego terminarza przy braku informacji o ostatnim sprawdzeniu terminów. Odpowiedź użytkownika: C — kontrargument nie uzasadnia zmiany; wymaganie pozostaje bez zmian.

## Non-Functional Requirements

- Funkcje MVP są dostępne w aplikacji webowej w przeglądarce Chrome na komputerze.
- Zapisane wyniki są trwałe: pozostają dostępne po odświeżeniu strony, zamknięciu przeglądarki i ponownym otwarciu aplikacji.
- Kibic nie może zmieniać danych; zarządzanie danymi jest dostępne wyłącznie dla zalogowanego administratora.

## Business Logic

Tabela jest automatycznie wyliczana z zapisanych wyników meczów i porządkuje drużyny według punktów klasyfikacyjnych oraz przyjętej hierarchii rozstrzygania remisów, zależnej od kompletności spotkań bezpośrednich.

Wejściem są zapisane wyniki meczów fazy zasadniczej sezonu 2026–2027, w tym rozstrzygnięcia walkowerem. Zwycięstwo daje 2 punkty klasyfikacyjne, porażka 1, przegrana walkowerem 0. Przy walkowerze administrator wskazuje zwycięzcę, a aplikacja automatycznie ustala wynik koszowy 20:0 na jego korzyść i punkty klasyfikacyjne 2:0. Każdy zapisany wynik jest od razu widoczny; tabela uwzględnia zapisane wyniki także przy niekompletnej rundzie. Przy równej liczbie punktów, zanim dostępny jest komplet wyników spotkań bezpośrednich zainteresowanych drużyn, pomija się kryteria tych spotkań: decydują ogólna różnica punktów zdobytych i straconych, a następnie liczba zdobytych punktów. To wybrana przez użytkownika zasada zachowania aplikacji w trakcie sezonu.

Gdy dostępny jest komplet wyników spotkań bezpośrednich, remis rozstrzyga kolejno: bilans zwycięstw i porażek między zainteresowanymi drużynami, różnica punktów w tych spotkaniach, punkty zdobyte w tych spotkaniach, ogólna różnica punktów i ogólna liczba zdobytych punktów. Po ustaleniu pozycji części drużyn procedurę rozpoczyna się ponownie dla pozostałej remisującej podgrupy. Użytkownik przyjął tę hierarchię na podstawie FIBA D.1.3–D.1.4. Jeżeli zastosowane kryteria nie rozstrzygają kolejności, drużyny zajmują miejsce ex aequo z powtórzonym numerem pozycji i są ułożone alfabetycznie wewnątrz grupy; alfabet porządkuje wyłącznie prezentację, a nie klasyfikację sportową. Ta zasada obowiązuje również przed pierwszą kolejką, w trakcie sezonu i na koniec fazy. Przy całkowitym remisie na koniec fazy regulaminowa zasada przewiduje losowanie, lecz obsługa oficjalnej kolejności po losowaniu jest poza zakresem MVP.

Przy tworzeniu i korekcie terminarza każda drużyna może być przypisana maksymalnie raz w danej rundzie. Administrator może korygować termin meczu, przypisaną drużynę i wynik. Zmiana drużyny w meczu z już zapisanym wynikiem wymaga potwierdzenia poprawnego wyniku; tabela jest ponownie wyliczana dla poprawionego przypisania, bez pozostawienia wpływu błędnego przypisania. Status meczu jest automatyczny: zapisany wynik oznacza „zakończony”, przyszły termin bez wyniku oznacza „zaplanowany”, a upływ terminu bez wyniku oznacza „oczekuje na wynik”. Brak wyniku po terminie nie przesądza, czy mecz faktycznie się odbył.

## Access Control

- Kibic: przegląda informacje publicznie, bez konta i bez logowania.
- Administrator: zarządza zespołami, terminarzem i wynikami meczów po zalogowaniu.
- Zarządzanie danymi wymaga zalogowania jako administrator.
- Administrator loguje się e-mailem i hasłem.
- Jedno konto administratora jest przygotowane wcześniej; brak publicznej rejestracji.

## Non-Goals

- Fazy rozgrywek poza fazą zasadniczą, w tym play-off — użytkownik ograniczył pierwszą wersję do fazy zasadniczej.
- Obsługa oficjalnej kolejności po losowaniu przy całkowitym remisie na koniec fazy — MVP pozostawia miejsca ex aequo.
- Wersja mobile — użytkownik ograniczył MVP do aplikacji webowej na komputer.
- Automatyczne pobieranie terminarza i wyników z innych stron — dane wprowadza ręcznie administrator.
- Wyniki na żywo i wyniki poszczególnych kwart — MVP pokazuje wyłącznie wyniki końcowe.
- Inne ligi i sezony — MVP obsługuje tylko PLK w sezonie 2026–2027.
- Składy drużyn i statystyki zawodników — MVP skupia się na zespołach, meczach i tabeli.

## Open Questions

Brak nierozstrzygniętych pytań z dotychczasowych rund discovery. Dodatkowe kryterium sukcesu doprecyzowano podczas końcowej kontroli kompletności.
