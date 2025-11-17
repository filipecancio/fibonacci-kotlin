# Fibonacci Kotlin

<!-- TEST_METRICS_START -->
![Build Status](https://github.com/filipecancio/fibonacci-kotlin/actions/workflows/build.yml/badge.svg)
![Tests](https://img.shields.io/badge/tests-6%2F7%20passed-red)
<!-- TEST_METRICS_END -->

<!-- TEST_RESULTS_START -->
## Resultados dos Testes

**Total:** 7 testes | **Passaram:** ✅ 6 | **Falharam:** ❌ 1

### ✅ Testes que Passaram (6)

- WHEN fib execute n=10 THEN returns 55
- WHEN fib execute n=0 THEN returns 0
- WHEN fib execute n=3 THEN returns 2
- WHEN fib execute n=4 THEN returns 3
- WHEN fib execute n=1 THEN returns 1
- WHEN fib execute n=2 THEN returns 1

### ❌ Testes que Falharam (1)

- WHEN fib execute n=30 THEN returns 832040 (java.lang.StackOverflowError)

---
*Última atualização: 2025-11-17 10:05:21 UTC*
<!-- TEST_RESULTS_END -->


Um projeto Kotlin que implementa cálculo de números de Fibonacci usando o sistema de build do IntelliJ IDEA.

## Estrutura do Projeto

Este projeto usa o sistema de build nativo do IntelliJ IDEA (não Gradle ou Maven) e está configurado com:

- **Código fonte**: `src/Solution.kt`
- **Testes**: `src/SolutionTest.kt`
- **Framework de testes**: JUnit 5
- **Versão do Kotlin**: 2.2
- **JVM target**: 1.8

## GitHub Actions

O projeto inclui um workflow do GitHub Actions (`.github/workflows/build.yml`) que automaticamente:

1. ✅ Configura o ambiente Java 23 e Kotlin
2. ✅ Baixa as dependências do JUnit 5 do Maven Central
3. ✅ Compila o código fonte Kotlin
4. ✅ Executa a aplicação principal
5. ✅ Compila e executa os testes
6. ✅ Faz upload dos resultados dos testes como artefatos
7. ✅ Extrai métricas dos testes e atualiza os badges no README
8. ✅ Gera uma lista detalhada dos testes que passaram e falharam

### Badges de Métricas

Os badges no topo do README são atualizados automaticamente após cada execução do workflow:
- **Build Status**: Indica se o último build passou ou falhou
- **Tests**: Mostra quantos testes passaram do total de testes executados

### Resultados dos Testes

Logo após os badges, é exibida automaticamente uma lista detalhada dos testes:
- **✅ Testes que Passaram**: Lista todos os testes que foram executados com sucesso
- **❌ Testes que Falharam**: Lista os testes que falharam, incluindo o tipo de erro
- A lista é atualizada automaticamente a cada push na branch `main` ou `master`

### Triggers do Workflow

O workflow é executado automaticamente quando:
- Há push para as branches `main` ou `master`
- Há pull request para as branches `main` ou `master`
- É acionado manualmente através do GitHub Actions UI

## Build Local

Para compilar e executar localmente:

```bash
# Compilar código fonte
kotlinc -d out/production -cp . src/Solution.kt

# Executar aplicação
kotlin -cp out/production SolutionKt

# Baixar dependências do JUnit (apenas primeira vez)
mkdir -p lib
wget https://repo1.maven.org/maven2/org/junit/jupiter/junit-jupiter-api/5.14.0/junit-jupiter-api-5.14.0.jar -O lib/junit-jupiter-api-5.14.0.jar
wget https://repo1.maven.org/maven2/org/junit/platform/junit-platform-commons/1.14.0/junit-platform-commons-1.14.0.jar -O lib/junit-platform-commons-1.14.0.jar
wget https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.14.0/junit-platform-console-standalone-1.14.0.jar -O lib/junit-platform-console-standalone-1.14.0.jar
wget https://repo1.maven.org/maven2/org/opentest4j/opentest4j/1.3.0/opentest4j-1.3.0.jar -O lib/opentest4j-1.3.0.jar
wget https://repo1.maven.org/maven2/org/apiguardian/apiguardian-api/1.1.2/apiguardian-api-1.1.2.jar -O lib/apiguardian-api-1.1.2.jar
wget https://repo1.maven.org/maven2/org/jetbrains/kotlin/kotlin-stdlib/2.1.0/kotlin-stdlib-2.1.0.jar -O lib/kotlin-stdlib-2.1.0.jar

# Compilar testes
kotlinc -d out/test -cp "out/production:lib/junit-jupiter-api-5.14.0.jar:lib/junit-platform-commons-1.14.0.jar:lib/opentest4j-1.3.0.jar:lib/apiguardian-api-1.1.2.jar" src/SolutionTest.kt

# Executar testes
java -jar lib/junit-platform-console-standalone-1.14.0.jar execute --class-path "out/production:out/test:lib/kotlin-stdlib-2.1.0.jar" --scan-class-path out/test --reports-dir=test-results
```

## Configuração do IntelliJ IDEA

O projeto está configurado para usar:
- Sistema de build do IntelliJ IDEA
- Configurações armazenadas no diretório `.idea/`
- Arquivo de módulo: `fibonacci-kotlin.iml`

## Diretórios Ignorados

Os seguintes diretórios são ignorados pelo Git:
- `out/` - Saída da compilação
- `lib/` - Dependências baixadas
- `test-results/` - Resultados dos testes
