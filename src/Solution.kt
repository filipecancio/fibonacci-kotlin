fun main() {
    println(Solution().fib(10))
}

class Solution {
    fun fib(n: Int): Int {
        return simpleFib(n)
    }

    fun simpleFib(n: Int): Int {
        return when {
            n == 0 -> 0
            n == 1 -> 1
            n == 2 -> 1
            else -> matrixFib(n)
            //else -> fib(n - 1) + fib(n - 2)
        }
    }

    fun matrixFib(n: Int): Int {
        val baseMatrix: Matrix = arrayOf(
            intArrayOf(1, 1),
            intArrayOf(1, 0),
        )
        val baseFib = intArrayOf(1, 0)

        val matrix: Matrix = baseMatrix.power(n - 1)
        return matrix.toFib(baseFib)[0]
    }

}

typealias Matrix = Array<IntArray>

fun Matrix.multiply(b: Matrix): Matrix = arrayOf(
    intArrayOf(
        this[0][0] * b[0][0] + this[0][1] * b[1][0],
        this[0][0] * b[0][1] + this[0][1] * b[1][1]
    ),
    intArrayOf(
        this[1][0] * b[0][0] + this[1][1] * b[1][0],
        this[1][0] * b[0][1] + this[1][1] * b[1][1]
    ),
)

fun Matrix.power(n: Int): Matrix {
    if (n == 0) return arrayOf(
        intArrayOf(1, 0),
        intArrayOf(0, 1),
    )

    val half = this.power(n / 2)

    val square = half.multiply(half)

    return if (n % 2 == 1) this.multiply(square) else square
}

fun Matrix.toFib(b: IntArray): IntArray = intArrayOf(
    this[0][0] * b[0] + this[0][1] * b[1],
    this[1][0] * b[0] + this[1][1] * b[1]
)