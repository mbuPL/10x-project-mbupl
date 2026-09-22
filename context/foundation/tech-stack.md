---
starter_id: spring
package_manager: maven
project_name: skarb-kibica-ligi-koszykowki
hints:
  language_family: java
  team_size: solo
  deployment_target: railway
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

Wybrano Spring Boot (Java, Maven, Spring Initializr) jako główny starter oraz frontend Angular (TypeScript, npm, Angular CLI) i bazę H2 w trwałym trybie plikowym. Autor pracuje solo, ma niewielkie doświadczenie w obu frameworkach i lepiej zna Spring Boot; mała skala oraz cztery tygodnie pracy po godzinach przemawiają za wykorzystaniem tych znanych technologii. Oba startery spełniają cztery kryteria przyjazności agentom. Ocena verified pochodzi z karty Spring Boot i nie oznacza zweryfikowania całej integracji Spring Boot–Angular–H2. Frontmatter opisuje główny starter; Angular i H2 są wymaganymi uzupełnieniami, które trzeba uwzględnić przy generowaniu projektu. Zgodnie z zaakceptowanym infrastructure.md wdrożenie na Railway Hobby w Amsterdamie zastępuje wcześniejsze założenie Fly.io: jedna instancja backendu serwuje Angulara z JAR-a, a H2 korzysta z trwałego wolumenu. Obraz Docker buduje frontend na Node 24.20.0 i backend na Java 21; runtime zawiera JRE 21. GitHub Actions uruchamia kontrole i automatyczne wdrożenie po połączeniu zmian z main, po skonfigurowaniu produkcji i włączeniu bramki wdrożeń. Pierwsza publikacja obejmuje szkielet i dzienne snapshoty; spójne kopie H2 poza wolumenem i sprawdzone odtwarzanie są obowiązkowe przed danymi biznesowymi. MVP wymaga logowania wcześniej przygotowanego administratora oraz publicznego odczytu; płatności, AI, komunikacja push i zadania w tle nie są wymagane. Samoocena potwierdza typowanie, oficjalne generatory, konwencje i dokumentację; autor potrzebuje wsparcia w ocenie zgodności propozycji agenta z praktyką stosu.

Szczegóły wykonania, bramki konfiguracji konta i rzeczywisty status produkcji:
[plan wdrożenia](../deployment/deploy-plan.md).
