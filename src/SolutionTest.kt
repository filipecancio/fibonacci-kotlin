import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test

class SolutionTest {
    val solution = Solution()

    data class ComplexityInfo(
        val timeComplexity: String,
        val spaceComplexity: String
    )

    private fun getComplexityForInput(n: Int): ComplexityInfo {
        return ComplexityInfo(
            timeComplexity = "O(2^n)",
            spaceComplexity = "O(n)"
        )
    }

    @Test
    @DisplayName("WHEN fib execute n=0 THEN returns 0")
    fun testFibZero() {
        executeTest(0, 0)
    }

    @Test
    @DisplayName("WHEN fib execute n=1 THEN returns 1")
    fun testFibOne() {
        executeTest(1, 1)
    }

    @Test
    @DisplayName("WHEN fib execute n=2 THEN returns 1")
    fun testFibTwo() {
        executeTest(2, 1)
    }

    @Test
    @DisplayName("WHEN fib execute n=3 THEN returns 2")
    fun testFibThree() {
        executeTest(3, 2)
    }

    @Test
    @DisplayName("WHEN fib execute n=4 THEN returns 3")
    fun testFibFour() {
        executeTest(4, 3)
    }

    @Test
    @DisplayName("WHEN fib execute n=10 THEN returns 55")
    fun testFibTen() {
        executeTest(10, 55)
    }

    @Test
    @DisplayName("WHEN fib execute n=30 THEN returns 832040")
    fun testFibThirty() {
        executeTest(30, 832040)
    }

    // Alterei para n=45, que é um dos maiores Fibs que cabem num Int positivo.
    // n=46 já estoura o Int em algumas implementações dependendo do sinal.
    @Test
    @DisplayName("WHEN fib execute n=45 THEN returns 1134903170")
    fun testFibFortyFive() {
        val currentValue = 45
        val expectedValue = 1134903170 // Limite seguro do Int

        executeTest(currentValue, expectedValue)
    }


    fun executeTest(currentInput: Int, expectedValue: Int) {
        //execute
        var result: Int = 0
        val timeoutMs = 1000L
        val executor = java.util.concurrent.Executors.newSingleThreadExecutor()
        val executionTime = kotlin.system.measureNanoTime {
            val future = executor.submit<Int> { solution.fib(currentInput) }
            try {
                result = future.get(timeoutMs, java.util.concurrent.TimeUnit.MILLISECONDS)
            } catch (te: java.util.concurrent.TimeoutException) {
                future.cancel(true)
                executor.shutdownNow()
                org.junit.jupiter.api.Assertions.fail("Execution timed out after ${timeoutMs}ms for input $currentInput")
            } finally {
                executor.shutdown()
            }
        }

        val executionTimeMs = executionTime / 1_000_000.0
        val complexity = getComplexityForInput(currentInput)

        //assertion
        assertEquals(
            expectedValue,
            result,
            """
            |Expected: $expectedValue, but got: $result
            |Execution time: ${String.format("%.2f", executionTimeMs)}ms
            |Time complexity: ${complexity.timeComplexity}
            |Space complexity: ${complexity.spaceComplexity}
            """.trimMargin()
        )

        // Print metrics on success
        println(
            "execution: ${
                String.format(
                    "%.2f",
                    executionTimeMs
                )
            }ms | time complexity: ${complexity.timeComplexity} | space complexity: ${complexity.spaceComplexity}"
        )
    }
}
