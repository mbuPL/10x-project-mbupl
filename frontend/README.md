# Skarb Kibica — frontend

Szkielet Angular 22 wygenerowany przez Angular CLI 22.1.8: komponenty standalone, routing, SCSS i ścisłe sprawdzanie typów. Klient HTTP jest dostępny przez `provideHttpClient()`.

Wymagany jest Node.js zgodny z Angular CLI: `^22.22.3 || ^24.15.0 || >=26.0.0` oraz npm. Dostępna lokalnie wersja Node.js to 24.20.0.

## Uruchomienie lokalne

Poniższe polecenia wykonuj w katalogu `frontend/`:

```bash
npm ci
npm start
```

Aplikacja działa pod adresem `http://localhost:4200/`. Backend uruchom osobno zgodnie z głównym README projektu. Serwer deweloperski przekazuje żądania `/api/**` do `http://127.0.0.1:8080`, zachowując ścieżkę.

Po uruchomieniu obu procesów sprawdź połączenie z backendem przez proxy:

```bash
curl --fail http://localhost:4200/api/health
```

Konfiguracja proxy znajduje się w `proxy.conf.json`; po jej zmianie uruchom ponownie `npm start`. Proxy obowiązuje podczas pracy lokalnej. W środowisku docelowym serwer udostępniający frontend powinien przekazywać `/api/**` do backendu.

## Budowanie i testy

```bash
npm run build
npm test -- --watch=false
```

Wynik kompilacji produkcyjnej trafia do `dist/skarb-kibica/browser/`. Testy jednostkowe używają Vitest; `npm test` uruchamia je w trybie obserwowania zmian.

Dokumentacja: [Angular CLI](https://angular.dev/tools/cli), [proxy do backendu](https://angular.dev/tools/cli/serve).
