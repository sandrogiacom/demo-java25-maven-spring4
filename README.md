# demo-java25-maven-spring4

Projeto de demonstração utilizando Spring Boot 4 (snapshot), Kotlin e Maven, com foco em explorar recursos modernos do ecossistema Java (Java 24+/25 EA), programação reativa com WebFlux e integração com banco de dados PostgreSQL e Testcontainers para testes.

## Sobre o projeto
- Linguagem principal: Kotlin
- Build: Maven (mvnw wrapper incluso)
- Frameworks/Bibliotecas:
  - Spring Boot 4.0.0-SNAPSHOT (Actuator, WebFlux, Validation, Data JPA)
  - Spring Cloud (OpenFeign)
  - Jackson Kotlin Module, Coroutines Reactor
  - PostgreSQL (runtime)
  - Testcontainers (JUnit, PostgreSQL)
- Módulo único (monorepo simples)

## Requisitos
- JDK 24+ (ou 25 EA) instalado e no PATH
- Docker (opcional, para executar Testcontainers mais rapidamente/localmente)

## Como executar a aplicação
1. Compilar o projeto:
   - Linux/macOS: `./mvnw clean package`
   - Windows: `mvnw.cmd clean package`
2. Executar em modo desenvolvimento:
   - Linux/macOS: `./mvnw spring-boot:run`
   - Windows: `mvnw.cmd spring-boot:run`

A aplicação sobe na porta padrão 8080 (a menos que alterado em `src/main/resources/application.properties`).

## Testes
- Rodar toda a suíte de testes:
  - Linux/macOS: `./mvnw test`
  - Windows: `mvnw.cmd test`

Os testes utilizam JUnit 5 e Testcontainers. Caso tenha Docker em execução, os containers necessários serão iniciados automaticamente durante os testes.

## Estrutura do projeto
- `src/main/kotlin` — código-fonte da aplicação
- `src/test/kotlin` — testes automatizados (incluindo configuração do Testcontainers)
- `src/main/resources` — configurações (application.properties)
- `pom.xml` — configurações do Maven e dependências

## Configuração de banco de dados
Por padrão, o PostgreSQL é utilizado em tempo de execução (dependência `runtime`). Para desenvolvimento local, você pode:
- Usar um PostgreSQL local e configurar credenciais em `application.properties`;
- Ou focar em testes com Testcontainers sem necessidade de instalação manual, apenas com Docker ativo.

## Observações
- Este projeto está alinhado com stack recente: Spring Boot 4 snapshot e Kotlin 2.2.x. Versões podem mudar rapidamente; verifique `pom.xml` para versões exatas.

## Licença
Este repositório é apenas demonstrativo. Adapte conforme sua necessidade e inclua uma licença se for publicar/redistribuir.