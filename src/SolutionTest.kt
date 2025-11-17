import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test

class SolutionTest {
    val solution = Solution()

    @Test
    @DisplayName("WHEN n=0 THEN returns 0")
    fun testFibZero() {
        val expected = 0
        val actual = solution.fib(0)
        assertEquals(expected, actual, "Fib(0) deveria ser 0")
    }

    @Test
    @DisplayName("WHEN n=1 THEN returns 1")
    fun testFibOne() {
        val expected = 1
        val actual = solution.fib(1)
        assertEquals(expected, actual, "Fib(1) deveria ser 1")
    }

    @Test
    @DisplayName("WHEN n=2 THEN returns 1")
    fun testFibTwo() {
        val expected = 1
        val actual = solution.fib(2)
        assertEquals(expected, actual, "Fib(2) deveria ser 1")
    }

    @Test
    @DisplayName("WHEN n=3 THEN returns 2")
    fun testFibThree() {
        val expected = 2
        val actual = solution.fib(3)
        assertEquals(expected, actual, "Fib(3) deveria ser 2")
    }

    @Test
    @DisplayName("WHEN n=4 THEN returns 3")
    fun testFibFour() {
        val expected = 3
        val actual = solution.fib(4)
        assertEquals(expected, actual, "Fib(4) deveria ser 3")
    }

    @Test
    @DisplayName("WHEN n=10 THEN returns 55")
    fun testFibTen() {
        val expected = 55
        val actual = solution.fib(10)
        assertEquals(expected, actual, "Fib(10) deveria ser 55")
    }

    @Test
    @DisplayName("WHEN n=30 THEN returns 832040")
    fun testFibThirty() {
        val expected = 832040
        val actual = solution.fib(30)
        assertEquals(expected, actual, "Fib(30) deveria ser 832040")
    }
}