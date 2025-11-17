
fun main(){
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
            else -> fib(n - 1) + fib(n - 2)
        }
    }
}
