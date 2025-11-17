import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test
import kotlin.system.measureNanoTime

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
        val currentValue = 0
        val expectedValue = 0

        executeTest(currentValue, expectedValue)
    }

    @Test
    @DisplayName("WHEN fib execute n=1 THEN returns 1")
    fun testFibOne() {
        val currentValue = 1
        val expectedValue = 1

        executeTest(currentValue, expectedValue)
    }

    @Test
    @DisplayName("WHEN fib execute n=2 THEN returns 1")
    fun testFibTwo() {
        val currentValue = 2
        val expectedValue = 1

        executeTest(currentValue, expectedValue)
    }

    @Test
    @DisplayName("WHEN fib execute n=3 THEN returns 2")
    fun testFibThree() {
        val currentValue = 3
        val expectedValue = 2

        executeTest(currentValue, expectedValue)
    }

    @Test
    @DisplayName("WHEN fib execute n=4 THEN returns 3")
    fun testFibFour() {
        val currentValue = 4
        val expectedValue = 3

        executeTest(currentValue, expectedValue)
    }

    @Test
    @DisplayName("WHEN fib execute n=10 THEN returns 55")
    fun testFibTen() {
        val currentValue = 10
        val expectedValue = 55

        executeTest(currentValue, expectedValue)
    }

    @Test
    @DisplayName("WHEN fib execute n=30 THEN returns 832040")
    fun testFibThirty() {
        val currentValue = 832040
        val expectedValue = 30

        executeTest(currentValue, expectedValue)
    }

    fun executeTest(currentInput: Int, expectedValue: Int) {
        //execute
        var result: Int = 0
        val executionTime = measureNanoTime {
            result = solution.fib(currentInput)
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
        println("execution: ${String.format("%.2f", executionTimeMs)}ms | time complexity: ${complexity.timeComplexity} | space complexity: ${complexity.spaceComplexity}")
    }
}