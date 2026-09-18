---
project: "Skarb kibica ligi koszykówki"
context_type: greenfield
product_type: web-app
target_scale:
  users: small
created: 2026-09-17
updated: 2026-09-17
timeline_budget:
  mvp_weeks: 4
  after_hours_only: true
  hard_deadline: 2026-10-20
checkpoint:
  current_phase: 8
  phases_completed: [1, 2, 3, 4, 5, 6, 7]
  gray_areas_resolved:
    - topic: "Zakres ligi i sezonu"
      decision: "Polska Liga Koszykówki, sezon 2026–2027."
    - topic: "Sytuacje korzystania przez kibica"
      decision: "Przed meczami: pary w danej rundzie; po meczach: wyniki i aktualna tabela; przyszłe rundy: planowane pary."
    - topic: "Problem z obecnymi źródłami"
      decision: "Informacje są nieaktualne i trudno je znaleźć w przyjaznej formie."
    - topic: "Role i dostęp do danych"
      decision: "Publiczne przeglądanie bez konta; administrator zarządza danymi po zalogowaniu (wariant A)."
    - topic: "Logowanie i konto administratora"
      decision: "Logowanie e-mailem i hasłem; jedno konto administratora przygotowane wcześniej; brak publicznej rejestracji (wariant A)."
    - topic: "Wprowadzanie danych sezonu"
      decision: "Administrator na początku sezonu definiuje drużyny oraz ręcznie wprowadza terminarz, rundy i mecze; po każdej rundzie wprowadza wyniki meczów."
    - topic: "Podstawowy scenariusz kibica"
      decision: "Po każdej rundzie kibic sprawdza wyniki meczów, przegląda tabelę i sprawdza kolejne rundy."
    - topic: "Fazy rozgrywek w MVP"
      decision: "Tylko faza zasadnicza."
    - topic: "Planowany czas realizacji"
      decision: "4 tygodnie pracy po godzinach, około 6–10 godzin tygodniowo."
    - topic: "Akceptacja kosztu harmonogramu"
      decision: "Użytkownik podtrzymał 4 tygodnie po przedstawieniu kosztu regularnej pracy; 3 tygodnie to wariant optymistyczny, a 4 tygodnie uwzględniają bufor."
    - topic: "Warunki obowiązkowe MVP"
      decision: "Brak utraty zapisanych wyników; brak możliwości zmiany danych przez kibica; poprawna kolejność drużyn w tabeli, szczególnie przy równej liczbie punktów."
    - topic: "Korekty wyniku i terminu meczu"
      decision: "Administrator może skorygować wpisany wynik i termin zaplanowanego meczu."
    - topic: "Kompletność wymagań MVP"
      decision: "Użytkownik uznał FR-001–FR-007, rozszerzone o korekty wyniku i terminu meczu, za komplet wymagań MVP."
    - topic: "Widoczność wyników i aktualizacja tabeli"
      decision: "Każdy zapisany wynik jest od razu widoczny; tabela jest przeliczana na podstawie dotychczas zapisanych wyników, także dla niekompletnej rundy (wariant A)."
    - topic: "Korekta drużyny w meczu i spójność rundy"
      decision: "Administrator może poprawić drużynę przypisaną do meczu; każda drużyna może być przypisana maksymalnie raz w danej rundzie."
    - topic: "Rozróżnienie rozegranych i nierozgranych meczów"
      decision: "Należy wyróżniać mecze zakończone od tych, które jeszcze się nie odbyły."
    - topic: "Pierwszeństwo wyników bezpośrednich"
      decision: "Przy równej liczbie punktów dwóch lub większej liczby drużyn o kolejności decydują wyniki meczów bezpośrednich pomiędzy tymi drużynami."
    - topic: "Dalsze kryteria rozstrzygania remisów"
      decision: "Przyjęto pełną przedstawioną hierarchię FIBA D.1.3–D.1.4, ponawianie procedury dla pozostałej remisującej podgrupy oraz losowanie przy całkowitym remisie na koniec fazy."
    - topic: "Punktacja i walkowery"
      decision: "2 punkty za zwycięstwo, 1 za porażkę, 0 za przegraną walkowerem; obsługa walkowerów w MVP (1A)."
    - topic: "Klasyfikacja przed kompletem spotkań bezpośrednich"
      decision: "Przy równej liczbie punktów, do kompletu spotkań bezpośrednich pomijamy ich kryteria; decydują ogólna różnica punktów zdobytych i straconych oraz liczba zdobytych punktów (2B)."
    - topic: "Całkowity remis na koniec fazy w MVP"
      decision: "Aplikacja pozostawia oznaczenie nierozstrzygnięte; obsługa oficjalnej kolejności po losowaniu pozostaje poza MVP (3B)."
    - topic: "Wprowadzanie walkoweru"
      decision: "Administrator wskazuje zwycięzcę walkoweru; aplikacja automatycznie przypisuje wynik koszowy 20:0 na jego korzyść i punkty klasyfikacyjne 2:0 (1A)."
    - topic: "Automatyczny status meczu"
      decision: "Zapisany wynik oznacza zakończony; przyszły termin bez wyniku oznacza zaplanowany; po upływie terminu bez wyniku mecz oczekuje na wynik (2A)."
    - topic: "Korekta drużyny po zapisaniu wyniku"
      decision: "Administrator może zmienić drużynę w meczu z wynikiem po potwierdzeniu poprawnego wyniku; tabela jest przeliczana dla poprawionego przypisania, z zachowaniem zasady jednego wystąpienia drużyny w rundzie (3A)."
    - topic: "Prezentacja całkowicie nierozstrzygniętej kolejności"
      decision: "Drużyny nierozdzielone przez przyjęte kryteria zajmują miejsce ex aequo, także w trakcie sezonu i przed pierwszą kolejką. W tabeli powtarza się numer pozycji, a drużyny na wspólnym miejscu są ułożone alfabetycznie; alfabet nie rozstrzyga klasyfikacji sportowej."
    - topic: "Typ aplikacji, urządzenia i przeglądarka"
      decision: "Aplikacja webowa na komputer, obsługiwana przeglądarka Chrome. Wersja mobile jest poza MVP."
    - topic: "Trwałość wyników"
      decision: "Wyniki muszą być zapisywane na stałe."
    - topic: "Początkowa liczba użytkowników"
      decision: "Tylko autor projektu i kilka osób (wariant B); mała skala użytkowników."
    - topic: "Wpływ stukrotnego wzrostu liczby odbiorców"
      decision: "Zasady tabeli i ręczne uzupełnianie danych przez jednego administratora pozostają bez zmian także przy stukrotnie większej liczbie odbiorców (wariant A); zakres MVP nie zostaje rozszerzony."
    - topic: "Termin ukończenia MVP"
      decision: "Użytkownik chce zakończyć pracę do 20 października 2026; budżet 4 tygodni pracy po godzinach po 6–10 godzin tygodniowo pozostaje bez zmian."
    - topic: "Dodatkowe wyłączenia z MVP"
      decision: "Poza MVP pozostają wszystkie przedstawione elementy: automatyczne pobieranie terminarza i wyników z innych stron, wyniki na żywo i wyniki kwart, inne ligi i sezony oraz składy drużyn i statystyki zawodników."
    - topic: "Dodatkowe kryterium sukcesu"
      decision: "Co najmniej 2 z 3 kibiców przy pierwszym użyciu, bez pomocy, znajdzie wynik wskazanego meczu, miejsce wybranej drużyny w tabeli i jej następnego rywala w ciągu łącznie 60 sekund od otwarcia aplikacji (wariant A)."
  frs_drafted: 7
  quality_check_status: accepted
---

# Shape notes

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

## Timeline acknowledgment

Acknowledged on 2026-09-17: 4-week MVP requires sustained dedication; user accepted.

Użytkownik potwierdził plan 4 tygodni pracy po godzinach, około 6–10 godzin tygodniowo (łącznie 24–40 godzin). 3 tygodnie traktuje jako wariant optymistyczny; 4 tygodnie uwzględniają bufor.

Termin ukończenia wskazany przez użytkownika: 20 października 2026 (`2026-10-20`).

## Seed idea

> Chcę stworzyć „Skarb kibica ligi koszykówki”: zarządzanie zespołami, terminarzem i wynikami meczów oraz automatycznie wyliczaną tabelę. Do ustalenia pozostają zakres ligi i sezonów, role użytkowników oraz zasady klasyfikacji.

## Session notes

### Context confirmation

> Tak to jest greenfield

### Phase 1 — initial response

> Aplikacja ma pomagać ludziom zainteresowanym śledzeniem rozgrywek ligii koszykówki. Dzisiaj muszą szukać inforamcji po róznych innych stronach. Kosztuje ich to czas i nerwy jak nie mogą znaleźć odpowiednich inforamcji

### Phase 1 — clarification responses

> 1. Proponuję rozgrywki Polskiej Ligi Koszykówki w niedługo rozpoczynającym się sezonie 2026-2027
> 2. Kibic sięga po inforamcje przed meczami eby zobaczyć kto z kim gra w danej rundzie, po meczu zeby zobaczyć wyniki poszczególnych meczów i aktualną tabelę oraz w przyszłe rundy zeby zobaczyć kto z kim będzie grał w przyszłości
> 3. Obecnie inforamcje są nieaktualne i trudno je znaleźć w przyjaznej formie

### Phase 1 confirmation and access choice

> Tak opis jest w porządku. Wybieram wariant A

Użytkownik zatwierdził podsumowanie celu i głównego odbiorcy. Etap 1 został zakończony. W etapie 2 wybrano publiczne przeglądanie i zarządzanie danymi przez zalogowanego administratora.

### Phase 2 — administrator access choice

> wybieram wariant A

Użytkownik wybrał logowanie e-mailem i hasłem, jedno konto administratora przygotowane wcześniej i brak publicznej rejestracji. Etap 2 został zakończony; kolejny etap dotyczy najmniejszego pełnego scenariusza MVP.

### Phase 3 — initial MVP flow

> Scenariusz wygląda tak, ze adminsitrator:
> 1. na początek sezonu definuije druzyny, wprowadza terminarz rozgrywek definując rundy i mecze
> 2. po kazdej rundzie wprowadza wyniki meczów
> kibic:
> 1. po kazdej rundzie sprawdza wyniki meczów, przegląda tabele oraz sprawdza kolejne rundy

### Phase 3 — scope and time budget

> zróbmy tylko fazę zasadniczą. Planuję zakończyć aplikację w 4 tygodnie pracy po godzinach. Zakładam około 6-10 godzin na tydzień.

### Phase 3 — time commitment and guardrails confirmed

> 1. podtrzymuję czas. 3 tygodnie to wariant optymistyczny. Asekuracyjnie zaplanowałem 4 tygodnie.
> 2. jeszcze nie wiem
> 3. te dwa warunki są w porządku. Dodaj jeszcze poprawne wyznaczanie kolejności drużyn w tabeli - w szczególności przy trudniejszych przypadkach równej liczby punktów.

Etap 3 zakończony. Nieustalone kryterium dodatkowe zapisano w Open Questions. Koszt dłuższego harmonogramu został zaakceptowany.

### Phase 4 — draft functional requirements

Siedem wymagań sformatowano na podstawie dotychczasowych wypowiedzi użytkownika. Wszystkie dotyczą podstawowego scenariusza i mają priorytet must-have.

### Phase 4 — functional requirements confirmed

> tak administrator powinen móc skroygować wynik i termin meczu. Dodaj to do wymagań i razem z tymi, które podałeś mamy komplet dla naszego MVP

FR-003 rozszerzono o korektę terminu meczu, a FR-004 o korektę wyniku. Użytkownik potwierdził kompletność listy siedmiu wymagań MVP. Etap 4 trwa: historyjka głównego scenariusza oraz runda pytań sokratejskich pozostają do domknięcia.

### Phase 4 — acceptance scenario confirmed

> wybieram wariant A

Użytkownik wybrał natychmiastową widoczność zapisanego wyniku oraz przeliczanie tabeli z dotychczas zapisanych wyników, również przy niekompletnej rundzie. Na podstawie tego wyboru i wcześniejszego opisu przepływu zapisano US-01 oraz doprecyzowano FR-004–FR-006.

### Phase 4 — Socrates round completed

> FR-001: C
> FR-002: C
> FR-003: A - musi istnieć także korekta drużyny przypisnej do meczu. Musimy jednak pilnować żeby każda drużyna była przypisana tylko raz w każdej rundzie
> FR-004: C
> FR-005: A - wyrózniajmy mecze zakończone od tych które jeszcze się nie odbyły
> FR-006: A - musimy zdefiniować jednoznaczne zasady rozstrzygania równej liczby punktów. Według regulaminu PLK jest to następująca zasada: W przypadku, gdy dwie (lub więcej)
> drużyny mają taką samą liczbę punktów o kolejności decydują wyniki
> bezpośrednich meczów (bezpośredniego meczu) między tymi drużynami
> FR-007: C

Każdy z siedmiu FR ma dokładnie jedną odpowiedź na kontrargument. FR-003, FR-005 i FR-006 doprecyzowano zgodnie z odpowiedziami użytkownika; FR-001, FR-002, FR-004 i FR-007 pozostają bez zmian. Etap 4 zakończony. Etap 5 dotyczy doprecyzowania reguł biznesowych oraz wymagań niefunkcjonalnych.

### Phase 5 — full tie-break hierarchy accepted

> wybieram wariant A

Użytkownik przyjął przedstawioną hierarchię dalszych kryteriów FIBA D.1.3–D.1.4, ponawianie procedury dla pozostałej remisującej podgrupy oraz losowanie przy całkowitym remisie na koniec fazy. Zakres tej odpowiedzi nie obejmuje jeszcze punktacji D.1.1, zachowania przy niekompletnych spotkaniach bezpośrednich ani sposobu obsługi losowania w aplikacji.

### Phase 5 — points, provisional standings and final unresolved ties

> 1A, 2B, 3B

Przyjęto punktację 2/1/0 i obsługę walkowerów w MVP. Przed kompletem spotkań bezpośrednich remisujące drużyny porównuje się według ogólnej różnicy punktów i liczby zdobytych punktów. Przy całkowitym remisie na koniec fazy MVP pozostawia oznaczenie „nierozstrzygnięte”; obsługa oficjalnej kolejności po losowaniu została wyłączona z zakresu.

### Phase 5 — forfeit input, match status and team correction

> 1A, 2A, 3A

Administrator wskazuje zwycięzcę walkoweru, a aplikacja automatycznie ustala wynik koszowy 20:0 na jego korzyść i punkty klasyfikacyjne 2:0. Status meczu wynika z zapisanego wyniku i terminu: „zakończony”, „zaplanowany” lub „oczekuje na wynik”. Korekta drużyny po zapisaniu wyniku jest dopuszczalna po potwierdzeniu poprawnego wyniku i powoduje przeliczenie tabeli dla poprawionego przypisania. Zasada maksymalnie jednego wystąpienia drużyny w rundzie nadal obowiązuje.

### Phase 5 — ex aequo and quality requirements; product type captured

> 1. tak. Zastosujmy oznaczenie ex aequo. Może być np. poprzez powtórzenie numerku pozycji w tabeli, a drużyny ułożóne w kolejności alfabetycznej
> 2. ma to być aplikacja web na komputerze. Wersję mobile wykluczamy poza MVP. Obsługiwaną przeglądarką niech będzie Chrome. Wyniki muszą być zapisywane na stałe.

Przyjęto miejsca ex aequo z powtórzonym numerem pozycji i alfabetyczną kolejnością drużyn wewnątrz grupy. Ustalono obsługę Chrome na komputerze, trwały zapis wyników i wykluczenie wersji mobile z MVP. Etap 5 zakończony. Typ produktu w etapie 6 został już podany przez użytkownika: aplikacja webowa; nie trzeba ponawiać tego pytania. Kolejne ustalenie dotyczy przewidywanej liczby użytkowników.

### Phase 6 — initial user scale

> B

Wybrano wariant „tylko ja i kilka osób”, zapisany jako `target_scale.users: small`. Etap 6 trwa; kolejne pytanie dotyczy wpływu stukrotnego wzrostu liczby użytkowników na zasady działania produktu. Nie ustalono jeszcze sztywnej daty zakończenia projektu.

### Phase 6 — scale probe

> A

Użytkownik potwierdził, że przy stukrotnie większej liczbie odbiorców zasady tabeli i ręczne uzupełnianie danych przez jednego administratora pozostają bez zmian. To odpowiedź dotycząca sposobu działania produktu, a nie rozszerzenie początkowej skali MVP ani nowa gwarancja wydajności. Kolejne ustalenie dotyczy sztywnej daty zakończenia; budżet 4 tygodni pracy po godzinach po 6–10 godzin tygodniowo pozostaje przyjęty.

### Phase 6 — completion deadline

> chciałbym zakończyć pracę do 20 października 2026

Zapisano `timeline_budget.hard_deadline: 2026-10-20`. Budżet 4 tygodni pracy po godzinach po 6–10 godzin tygodniowo pozostaje bez zmian. Typ produktu, początkowa skala i termin są ustalone; do zamknięcia etapu 6 pozostaje runda dotycząca wyłączeń z zakresu MVP.

### Phase 6 — non-goals confirmed

> tak. Wszytskie wymienione będą poza MVP

Użytkownik wykluczył wszystkie cztery przedstawione grupy funkcji: automatyczne pobieranie danych z innych stron, wyniki na żywo i wyniki kwart, inne ligi i sezony oraz składy drużyn i statystyki zawodników. Rozszerzono Non-Goals; etap 6 został zakończony. Etap 7 dotyczy końcowej kontroli kompletności i zatwierdzenia notatek. Dodatkowe kryterium sukcesu pozostaje nieustalone; nie zastąpiono odpowiedzi użytkownika domyślnym celem.

### Phase 7 — secondary success criterion resolved

Użytkownik wybrał uzupełnienie dodatkowego kryterium sukcesu zamiast zakończenia z otwartą kwestią:

> B

Następnie wybrał wariant mierzący szybkość znalezienia informacji:

> A

Przyjęto kryterium: co najmniej 2 z 3 kibiców przy pierwszym użyciu, bez pomocy, znajdzie wynik wskazanego meczu, miejsce wybranej drużyny w tabeli i jej następnego rywala w ciągu łącznie 60 sekund od otwarcia aplikacji. Kryterium zapisano jako Secondary; nie dodaje ono nowych funkcji do MVP. Usunięto rozstrzygnięte pytanie z Open Questions. Pozostałe ustalenia są zachowane; etap 7 oczekuje na końcowe zatwierdzenie całości przez użytkownika.

### Phase 7 — final acceptance

Użytkownik wybrał „A — zatwierdzam i kończymy” po przedstawieniu końcowej kontroli kompletności:

> A

Zatwierdzono całość notatek bez zmian w zakresie MVP. Zakończono etap 7 i ustawiono `quality_check_status: accepted`. Etap 8 przekazuje zatwierdzone notatki do `/10x-prd`; PRD nie jest generowany automatycznie.

## Quality cross-check

Kontrola zakończona 2026-09-17; wynik zaakceptowany przez użytkownika.

- Access Control: present — publiczny dostęp kibica tylko do odczytu oraz zarządzanie danymi przez jednego zalogowanego administratora.
- Business Logic: present — sekcję otwiera jedno zdanie opisujące regułę wyliczania tabeli; dalszy opis obejmuje punktację, remisy, walkowery i korekty.
- Project artifacts: present — `shape-notes.md` zawiera poprawny frontmatter z `context_type`, pełnym checkpointem, siedmioma FR oraz dziesięcioma sekcjami w kolejności schematu.
- Timeline-cost acknowledged: present — zaakceptowano 4 tygodnie pracy po godzinach, 6–10 godzin tygodniowo, z terminem ukończenia 20 października 2026; zapisano Timeline acknowledgment.
- Non-Goals: present — wyłączenia z MVP zostały zapisane i zatwierdzone.
- Preserved behavior: n/a (greenfield) — brak istniejącej aplikacji, której zachowanie należałoby zachować.

Ta kontrola nie wykazała braków. Wszystkie pytania z przeprowadzonych rund discovery zostały rozstrzygnięte. Reguły klasyfikacji pozostają przyjętymi zasadami MVP; zakres weryfikacji źródeł i odstępstwa opisano w notatkach, bez deklaracji pełnej zgodności z odrębnie zweryfikowanym regulaminem PLK 2026/2027.

## Reference material — classification sources

- [Regulamin rozgrywek PLK, punkt 6.2](https://www.pzkosz.pl//internalfiles/fckfiles/file/pliki/PLK25-26/Regulamin%20ROZGRYWEK%20POLSKIEJ%20%20LIGI%20KOSZYK%C3%93WKI.pdf): potwierdza podany przez użytkownika zapis i odsyła do Przepisów Gry. Dokument jest podlinkowany w sekcji sezonu 2025/2026 na [stronie regulaminów PLK](https://plk.pl/regulaminy); nie oznaczono go jako odrębnie zweryfikowanego regulaminu sezonu 2026/2027.
- [Official Basketball Rules 2026 v1.1](https://assets.fiba.basketball/image/upload/documents-corporate-fiba-official-rules-2026-v1-1.pdf): dokument obowiązuje od 1 października 2026. Użytkownik przyjął punktację 2/1/0 z D.1.1 i hierarchię D.1.3–D.1.4 z opisanymi decyzjami dla MVP. Przyjął również automatyczny wynik koszowy walkoweru 20:0 na korzyść wskazanego zwycięzcy, na podstawie zweryfikowanego punktu 20.2.1.
