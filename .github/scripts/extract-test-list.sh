#!/bin/bash

# Script para extrair a lista de testes que passaram e falharam do XML de resultados

TEST_XML="test-results/TEST-junit-jupiter.xml"
OUTPUT_FILE="test-results/test-list.md"

if [ ! -f "$TEST_XML" ]; then
    echo "Arquivo de resultados de teste não encontrado: $TEST_XML"
    exit 1
fi

# Criar diretório de saída se não existir
mkdir -p test-results

# Inicializar arquivo de saída
echo "## Resultados dos Testes" > "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Extrair informações gerais
TESTS=$(grep -oP 'tests="\K[0-9]+' "$TEST_XML" | head -1)
FAILURES=$(grep -oP 'failures="\K[0-9]+' "$TEST_XML" | head -1)
ERRORS=$(grep -oP 'errors="\K[0-9]+' "$TEST_XML" | head -1)
SKIPPED=$(grep -oP 'skipped="\K[0-9]+' "$TEST_XML" | head -1)

PASSED=$((TESTS - FAILURES - ERRORS - SKIPPED))

echo "**Total:** $TESTS testes | **Passaram:** ✅ $PASSED | **Falharam:** ❌ $((FAILURES + ERRORS))" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Extrair lista de testes que passaram
echo "### ✅ Testes que Passaram ($PASSED)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Usar awk para processar os testes que passaram
awk '
    /<testcase/ {
        in_testcase = 1
        has_error = 0
        display_name = ""
        next
    }
    in_testcase {
        if ($0 ~ /display-name:/) {
            match($0, /display-name: (.+)/, arr)
            display_name = arr[1]
        }
        if ($0 ~ /<error/ || $0 ~ /<failure/) {
            has_error = 1
        }
        if ($0 ~ /<\/testcase>/) {
            if (!has_error && display_name != "") {
                print "- " display_name
            }
            in_testcase = 0
            has_error = 0
            display_name = ""
        }
    }
' "$TEST_XML" >> "$OUTPUT_FILE"

echo "" >> "$OUTPUT_FILE"

# Extrair lista de testes que falharam
FAILED_COUNT=$((FAILURES + ERRORS))
if [ $FAILED_COUNT -gt 0 ]; then
    echo "### ❌ Testes que Falharam ($FAILED_COUNT)" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    
    # Usar awk para extrair testes falhados
    awk '
        /<testcase/ {
            in_testcase = 1
            has_error = 0
            display_name = ""
            error_type = ""
            next
        }
        in_testcase {
            if ($0 ~ /display-name:/) {
                match($0, /display-name: (.+)/, arr)
                display_name = arr[1]
            }
            if ($0 ~ /<error/ || $0 ~ /<failure/) {
                has_error = 1
                match($0, /type="([^"]+)"/, arr)
                error_type = arr[1]
            }
            if ($0 ~ /<\/testcase>/) {
                if (has_error && display_name != "") {
                    print "- " display_name
                    if (error_type != "") {
                        print "> error caused by " error_type
                    }
                }
                in_testcase = 0
                has_error = 0
                display_name = ""
                error_type = ""
            }
        }
    ' "$TEST_XML" | while IFS= read -r line; do
        if [[ $line == "> error caused by "* ]]; then
            error_type="${line#> error caused by }"
            description=""
            case "$error_type" in
                *"StackOverflowError"*)
                    description="pilha de execução esgotada devido a recursão excessiva"
                    ;;
                *"OutOfMemoryError"*)
                    description="memória insuficiente para executar a operação"
                    ;;
                *"AssertionError"*|*"AssertionFailedError"*)
                    description="valor esperado não corresponde ao valor obtido"
                    ;;
                *"NullPointerException"*)
                    description="tentativa de acessar um objeto nulo"
                    ;;
                *"ArrayIndexOutOfBoundsException"*)
                    description="índice fora dos limites do array"
                    ;;
                *"ArithmeticException"*)
                    description="erro aritmético na operação"
                    ;;
                *"IllegalArgumentException"*)
                    description="argumento inválido fornecido ao método"
                    ;;
                *"TimeoutException"*)
                    description="operação excedeu o tempo limite de execução"
                    ;;
                *)
                    description="erro durante a execução do teste"
                    ;;
            esac
            echo "> error caused by $error_type ($description)"
        else
            echo "$line"
        fi
    done >> "$OUTPUT_FILE"
fi

echo "" >> "$OUTPUT_FILE"
echo "---" >> "$OUTPUT_FILE"
echo "*Última atualização: $(date '+%Y-%m-%d %H:%M:%S UTC')*" >> "$OUTPUT_FILE"

echo "Lista de testes gerada com sucesso em: $OUTPUT_FILE"
