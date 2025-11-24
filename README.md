[Link do desafio leetcode](https://leetcode.com/problems/fibonacci-number/description/)
[Link da solução leetcode](https://leetcode.com/problems/fibonacci-number/solutions/7369391/some-ways-to-solve-and-trying-to-underst-2cra)

A lógica do fibonacci é bem simples. O número atual é resultado da soma do número anterior mais o seu anterior `(n-1)+(n-2)`. Considerando apenas o conjunto dos números naturais, adicionamos uma regra para os números `0` e `1`, cujo os seus correspondentes são eles mesmos `f(0) = 0` e `f(1)=1` e assim temos a sequência `0 1 1 2 3 5 ...`

podemos começar com então com a que representa a função matemática de Fibonacci `f(n) = f(n-1) = f(n-2)`, a **solução recursiva**.

# Solução recursiva
Na solução recursiva vamos colocar:
- Nosso caso base `n = 0` e `n = 1`
- E a expressão matemática `f(n) = f(n-1) = f(n-2)`

<details>
<summary>☕ Ver solução em Java</summary>
```python []
class Solution:
    def fib(self, n: int) -> int:
        match n:
            case 0 | 1:
                return n
            case _:
                return self.fib(n - 1) + self.fib(n - 2)
```
</details>
```java []
class Solution {
    public int fib(int n) {
        return switch (n) {
            case 0, 1 -> n;
            default -> fib(n - 1) + fib(n - 2);
        };
    }
}
```
```kotlin []
class Solution {
    fun fib(n: Int): Int = when(n) {
            0, 1 -> n
            else -> fib(n - 1) + fib(n - 2)
        }
}
```
```swift []
class Solution {
    func fib(_ n: Int) -> Int {
        return switch n {
            case 0,1: n
            default: fib(n-1) + fib(n-2)
        }
    }
}
```
```dart []
class Solution {
  int fib(int n) => switch (n) {
    0 || 1 => n,
    _ => fib(n - 1) + fib(n - 2),
  };
}
```

É uma solução simples e compreensiva, porém acredite não é a das melhores. 

## Complexity

Vamos pensar em `fib(6)`, e realizar um teste de mesa (não vou trocar `fib(1) e fib(0)` por 1 e 0 no nosso teste de mesa porque não precisamos nos apegar ao valor mas ao número de instruções):

| Valor | Recursão | Total| Intruções |
| -- | -- | -- | -- |
| `fib(6)` | `fib(5)` + `fib(4)` | `fib(1) + fib(0) + fib(1) + fib(1) + fib(0) + fib(1) + fib(0) + fib(1)` + `fib(1) + fib(0) + fib(1) + fib(1) + fib(0)`| 13 |
|`fib(5)` | `fib(4)` + `fib(3)` | `fib(1) + fib(0) + fib(1) + fib(1) + fib(0)` + `fib(1) + fib(0) + fib(1)`| 8 |
|`fib(4)` | `fib(3)` + `fib(2)` | `fib(1) + fib(0) + fib(1)` + `fib(1) + fib(0)`| 5 |
|`fib(3)` | `fib(2)` + `fib(1)` | `fib(1) + fib(0)` + `fib(1)`| 3 |
|`fib(2)` | `fib(1)` + `fib(0)`| | 2|


Observando o resultado do nosso teste vemos algo assustador. Para exercutarmos essa função, nos a rodamos o **número corresponte ao seu valor em finonacci**! Ou seja pensando na perspectiva de `f(x) = y`da matemática, em um número `n` de entradas levamos exatamente `y` para retornar o próprio `y`!
Aproveitando a matemática, a `f(x) = y`que corresponde à complexidade de Fibonacci é $\phi$ é o Número de Ouro ($\approx 1.618$). Ou seja a complexidade de tempo dessa função é $O(1.618^n)$ mas a gente arredonda para a complexidade assinstótica de $O(2^n)$.
E quanto armazenamento? podemos ver no teste de mesa que nos igualamos as funções (`f(3)` = `f(2)+f(1)`), no fim o código recursivo acaba passando por todas as definições de `f(n)` e igualando ao seu valor, ou seja, para cada `n` valor temos salvo `n` definições ocupando um espaço `n` de memória.

Em resumo:
- Time complexity: $O(2^n)$
- Space complexity: $O(n)$

Existe um forma mais rápida de solucionar esse caso e é também simples. Muito parecida com o que nos usamos logo quando quando aprendermos fibonacci na escola.

# Solução iterativa

No ensino fundamental, quando a professora pedia para calcularmos o valor de de fibonacci de 20, somávamos a sequencia de valores 20 vezes até chegar o valor correspondente, correto? Nessa solução faremos o mesmo! Vamos iterar de 2 a n somando consecutivamente até chegarmos no nosso valor.
Nesa solução iterativa vamos colocar:
- Nosso caso base `n = 0` e `n = 1`,
- Uma variável `i` que começa com `2` e incrementa até `n`,
- Duas variáveis, uma para salvar `i-1` e outra `i-2` no valor correspondente de `i`

Podemos falar que essas duas variáveis são dois ponteiros, são dois savepoints, onde eu vou deixar resgistrados valores que me importam. No fim da iteração eu apenas retorno o valor do primeiro ponteiro `i-1`. 

Porque?

Bem durante a iteração, você vai:
- Colocar o valor de `i-1` em um ponteiro temporário, pode ser um `c` (`i-1` seria `a` e `i-2` seria `b`),
- Somar esse dois ponteiros `i-1` e `i-2` e salvar em `i-1`
- Colocar o valor de `c` em `i-2`

`c` morre no fim de cada ciclo da iteração, ele so serve pra fazer a troca de valores depois da soma. No fim da iteração o valor em `i-1` sempre irá corresponder ao `f(n)` do próximo valor de `i` e assim que acaba temos de fato `f(n)`.

```python []
class Solution:
    def fib(self, n: int) -> int:
        if n < 2: return n
        a, b = 0, 1
        
        for _ in range(n):
            a, b = b, a + b
            
        return a
```
```java []
class Solution {
    public int fib(int n) {
        if (n < 2) return n;
        int a = 1;
        int b = 0;
        
        for( int i = 2; i<n; i++){
            int c = a + b;
            b = a;
            a = c;

            /*
            Risco de estouro de inteiros
            b = a+b;
            b = b-a;
             */

            /*
            Atribui durante a soma
            a = (b += a) - a;
            */
        }
        return a;
    }
}
```
```kotlin []
class Solution {
    fun fib(n: Int): Int {
        if (n < 2) return n
        var (a, b) = 0 to 1

        repeat(n) {
            a = b.also { b += a }
        }
        return a
    }
}
```
```swift []
class Solution {
    func fib(_ n: Int) -> Int {
        if n < 2 {return n}

        var (a, b) = (0, 1)
        for _ in 0..<n {
            (a, b) = (a + b, a)
        }
        return a
    }
}
```
```dart []
class Solution {
  int fib(int n) {
    if(n < 2) return n;

    var (a, b) = (0, 1);

    for (var i= 0; i< n; i++) {
      (a, b) = (b, a + b);
    }
    return a;
  }
}
```

Você pode ter olhado o código correspondente da sua linguagem e passado reto nas outras, mas se parar e olhar com calma, cada linguagem tem uma forma interessante de iterar os valores e de passar entre os ponteiros `a`, `b` e `c`. Na real, alguns nem tem o ponteiro `c`, legal né?

Uma característica que essas linguagens tem em comum é o swap, a capacidade de troca de valores entre variáveis. Vou deixar aqui uma listinha de possibilidade de swap entre linguagens.

| Linguagem| Atribuição de valores | Troca de valores |
| - | - | - | 
| Java	| `int a = 1; int b = 0;`| `a = (b += a) - a;`	|
| Kotlin| `var (a, b) = 0 to 1` |	`var (a, b) = 1 to 0`|
| Swift	| `var (a, b) = (0, 1)` | `(a, b) = (b, a + b)`| 
| Dart| `var (a, b) = (0, 1)` |	`(a, b) = (b, a + b)`|

Essas sobreposições de valores causam um efeito significativo nessa versão do algoritmo de fibonacci, a solução em termos de espaço passa a ser $O(1)$, já a de tempo, $O(n)$. Porque? Bem, temos os seguintes pontos:

- Nossos ponteiros sempre serão 3 (ou 2...). Na duvida, complexidade assintótica de $O(1)$,
- Temos um fluxo de iteração de 2 para n, ou seja executamos as instruções de soma n vezes.

assim em resumo:
- Time complexity: $O(n)$
- Space complexity: $O(1)$

Bem, tudo que é bom, pode melhorar e por mais que um algoritmo $O(n)$ não seja péssimo, existe algumas soluções mais "velozes" em perpectiva de complexidade assintótica. No proximo algorítmo veremos como usar uma propriedade da algebra para resolver o problema de fibonacci, desta vez usaremos matrizes!

# Solução com exponenciação de matrizes

Ok, você deve está se perguntando agora, o que exponenciação de matrizes tem a ver com fibonaccci e como ela pode tornar melhor a complexidade assintótica?

De forma resumida existe uma expressão matemática de que o valor de fibonacci pode ser estabelecido pela expessão $$\begin{pmatrix} F_{n} \\ F_{n-1} \end{pmatrix} = \begin{pmatrix} 1 & 1 \\ 1 & 0 \end{pmatrix}^{n-1} \times \begin{pmatrix} F_1 \\ F_0 \end{pmatrix}$$.

Parece assustador, mas pensando de uma forma simples, há uma matrix base que se você multiplica por ela mesma n-1 vezes, você consegue chegar em uma matrix que multiplicada pelo array `[0,1]` ( ou `[fib(0) fib(1)]`), voce retorna o array `[fib(n) fib(n-1)]`. Uma vez que você tem esse array, basta você retornar o primeiro valor dele.

```python []
class Solution:
    def fib(self, n: int) -> int:
        if n < 2: return n
        
        matrix = Matrix.BASE_MATRIX.power(n - 1)
        result_vector = matrix.multiply([1, 0])
        
        return result_vector[0]

```
```java []
class Solution {
    public int fib(int n) {
        if (n < 2) return n;
        
        var matrix = Matrix.BASE_MATRIX.power(n-1);
        var resultVector = matrix.multiply(new int[]{1,0});

        return resultVector[0];
    }
}

```
```kotlin []
class Solution {

    fun fib(n: Int): Int {
        if (n == 0) return 0

        val matrix: Matrix = Matrix.BASE_MATRIX.power(n - 1)
        return matrix.multiply(intArrayOf(1, 0))[0]
    }
}
```
```swift []
class Solution {
    func fib(_ n: Int) -> Int {
        if n < 2 { return n }

        let matrix = Matrix.BASE_MATRIX.power(n-1)
        return matrix.multiply([1,0])[0]

    }
}

```
```dart []
class Solution {
  int fib(int n) {
    if (n < 2) return n;

    var matrix = Matrix.BASE_MATRIX.power(n - 1);
    return matrix.multipliyTwo([1, 0])[0];
  }
}
```

Olhando esse código fica fácil pensar que temos dois desafios:
- criar um código que multiplique matrizes 2x2
- criar um código que eleve uma matriz a uma potência n

de forma implicita há um terceiro desafio:
- criar um código que multiplique matriz 2x2 por 2x1.

Eu sei que você ainda está se perguntando *"como que isso é melhor que iterativa? multiplicar matrizes é loucura!"*. A gente vai usar a ajuda da multplicação de matrizes para tranformar a complexidade de um código recursivo que ao invés de ser $O(2^n)$ será $O(\log n)$! Como?! pensa:

Em um calculo de potência `power(n)`, dada a potência `n`, temos:
- Se for `0`, retorne a matriz identidade;
- Se for `1`, retorne a própria matriz;
- Se for par, usaremos a expressão matemática $m^{n/2} * m^{n/2}$ onde n é igual a 6, teriamos  $m^6 = m^3 * m^3$
- Se for ímpar, usaremos a expressão matemática $m * m^{n/2} * m^{n/2}$ onde n é igual a 7, teriamos  $m^6 = m * m^3 * m^3$

Ta confuso? Não se preocupe, vamos pra o teste de mesa, la você se situa.

| n | matrix ($m$) | chamadas recursivas | total |
| - | - | - | - |
| 0 | identidade | `f(0)` | 1 |
| 1 | $m$ | `f(1)` | 1 |
| 2 | $m * m $ | `f(1)` * `f(1)`| 2 |
| 3 | $m * m^2$ | `f(1)` * `f(2)` = `f(1)` * `f(1) * f(1)` | 3 |
| 4 | $m^2  * m^2$ | `f(2) * f(2)` =  `f(1) *f(1)` * `f(1) *f(1)` | 4 |
| 5 | $m * m^2  * m^2$ | `f(1)` * `f(2)` * `f(2)` =  `f(1)` * `f(1) * f(1)` * `f(1) * f(1)` | 5 |
| 6 | $m^3  * m^3$ | `f(3)` * `f(3)` =  `f(1) * f(1) * f(1)` * `f(1) * f(1) * f(1)` | 6 |
| 7 | $m * m^3  * m^3$ | `f(1)` * `f(3)` * `f(3)` = `f(1)` *  `f(1) * f(1) * f(1)` * `f(1) * f(1) * f(1)` | 7 |

olhando a tabela entendemos da pra visualizar melhor a lógica de pontência com recursão ne? Mas parece que a progessão de uma potência irá ocorrer em complexidade $O(n)$, mas... e se pensarmos que durante a recursão, chamamos as metades apenas **uma vez?!**, duvida? Olha (desta vez analizando de cima para baixo):

> Desta vez nao vamos considerar $m3 = m * m^2$  e sim $m3 = m * m * m$ para respeitar nossa regra do ímpar $m * m^{n/2} * m^{n/2}$

| n | matrix ($m$) | chamadas recursivas | total |
| - | - | - | - |
| 7 | $m * m^3  * m^3$ | - | - |
| 3 | $m * m  * m$ | - | - |
| 1 | $m$ | `f(1)` | 1|
| 3 | $m * m  * m$ | `f(1)` * `f(1)` * `f(1)`  | 2 |
| 7 | $m * m^3  * m^3$ | `f(3)` * `f(3)` | 4 |


Diferente, não é mesmo? percebe que para encontrar $mˆ7$ a recursão não segue um caminho linear, na verdade ela pula as etapas de 6,5,4. O motivo disso é porque só necessária a recursão dos valores da **metade da pontência**. pense que em um número pequeno como `7` a diferença foi irrelevante (6 instruções) mas pensa um número como `32` (suas metades, `16`, `8`, `4`, `2`, `1`) o intervalo de instruções puladas fica cada vez menor comparado com a progressão linear que seria em $0(n)$ = 32, nessa seria exatamente o numero de suas medates, `5`.

Lindo mas... como vamos colocar isso no código? Para essa solução vamos precisar multiplicar a matriz $\begin{pmatrix} 1 & 1 \\ 1 & 0 \end{pmatrix}$ `n-1` vezes e muplitplicar pela matriz $\begin{pmatrix} 1 \\0 \end{pmatrix}$. Nos já deixamos essa parte feita, mas agora precisamos criar nosso modelo de matriz para realizar os cálculos necessários!

Para isso vamos usar o paradigma de orientação a objetos. fica mais facil solucionar um problema complexo quando definimos algo abstrato como um objeto, damos propriedade e comportamentos a esse objeto.
O nosso objeto da vez é a matriz e ela uma propriedade apenas:
- ela carrega um array de numeros $M_{2 \times 2}$

ela tem 3 rpopriedade:

- pode multiplicar uma matrix $M_{2 \times 2}$ por outra $M_{2 \times 2}$
- pode elevar uma matriz $M_{2 \times 2}$ a uma potencia `n`
- pode multiplicar uma matrix $M_{2 \times 2}$ por outra $M_{2 \times 1}$

Ela também terá duas versões constantes delas que é a nossa matriz indentidade e a nossa matriz base. Em orientação a objetos chamamos de valores estáticos (ou constantes mesmo).


```python []
class Matrix:
    def __init__(self, data):
        self.data = data

    def multiply(self, other):
        if isinstance(other, Matrix):
        elif isinstance(other, list):
        raise ValueError("Tipo não suportado para multiplicação")

    def power(self, n: int):

Matrix.IDENTITY_MATRIX = Matrix([[1, 0], [0, 1]])
Matrix.BASE_MATRIX = Matrix([[1, 1], [1, 0]])
```
```java []
record Matrix(
    int[][] data
) {

    public static final Matrix IDENTITY_MATRIX = new Matrix(new int[][] { { 1, 0 }, { 0, 1 } });
    public static final Matrix BASE_MATRIX = new Matrix(new int[][] { { 1, 1 }, { 1, 0 } });

    Matrix multiply(Matrix b) {}
    int[] multiply(int[] b) {}
    Matrix power(int n) {}
}
```

```kotlin []
data class Matrix(
    val data: Array<IntArray>
){
    companion object {
        val IDENTITY_MATRIX = Matrix(arrayOf(intArrayOf(1, 0), intArrayOf(0, 1)))
        val BASE_MATRIX = Matrix(arrayOf(intArrayOf(1, 1),intArrayOf(1, 0)))
    }

    fun multiply(b: Matrix): Matrix {}
    fun multiply(b: IntArray): IntArray {}
    fun power(n: Int): Matrix {}
}
```
```swift []
struct Matrix {
    let data: [[Int]]

    static let IDENTITY_MATRIX = Matrix(data: [[1,0],[0,1]])
    static let BASE_MATRIX = Matrix(data: [[1,1],[1,0]])

    func multiply(_ b: Matrix) -> Matrix {}
    func multiply(_ b: [Int]) -> [Int] {}
    func power(_ n: Int) -> Matrix {}
}
```
```dart []
extension type const Matrix(
    List<List<int>> data
) {

  static const IDENTITY_MATRIX = Matrix(const [[1, 0],[0, 1]]);
  static const BASE_MATRIX = Matrix(const [[1, 1],[1, 0]]);

  Matrix multiply (Matrix b) { }
  List<int> multipliyTwo( List<int> b) {}
  Matrix power(int n){}
```
É importante observar a peculiaridade do conceito de classes/objeto entre linguagens.
- Para `python`vamos usar a mesma propriedade para os dois tipos matrizes, e colocamos um if/else para tratar quando for cada caso.
- Para `dart`colocamo o nome `multipliyTwo` para a multiplicação de matrix 2x1
Isso foi necessário pois ambas as linguagens nao aceitam o conceito de sobrecarga de metodo, onde usamos uma mesma função para tratar de forma igual, assinaturas diferentes.

Para realizar o cálculo de multiplicação de matrizes vamos usar os conceitos básicos aprendidos em sala de aula:

```python []
def multiply(self, other):
        
        if isinstance(other, Matrix):
            b = other.data
            return Matrix([
                [
                    self.data[0][0] * b[0][0] + self.data[0][1] * b[1][0],
                    self.data[0][0] * b[0][1] + self.data[0][1] * b[1][1]
                ],
                [
                    self.data[1][0] * b[0][0] + self.data[1][1] * b[1][0],
                    self.data[1][0] * b[0][1] + self.data[1][1] * b[1][1]
                ]
            ])
        
        elif isinstance(other, list):
            b = other
            return [
                self.data[0][0] * b[0] + self.data[0][1] * b[1],
                self.data[1][0] * b[0] + self.data[1][1] * b[1]
            ]
        
        raise ValueError("Tipo não suportado para multiplicação")

```
```java []
Matrix multiply(Matrix b) {
    return new Matrix(new int[][]{
            {
                    this.data[0][0] * b.data[0][0] + this.data[0][1] * b.data[1][0],
                    this.data[0][0] * b.data[0][1] + this.data[0][1] * b.data[1][1]
            },
            {
                    this.data[1][0] * b.data[0][0] + this.data[1][1] * b.data[1][0],
                    this.data[1][0] * b.data[0][1] + this.data[1][1] * b.data[1][1]
            }
    });
}

int[] multiply(int[] b) {
    return new int[]{
            this.data[0][0] * b[0] + this.data[0][1] * b[1],
            this.data[1][0] * b[0] + this.data[1][1] * b[1]
    };
}
```
```kotlin []
fun multiply(b: Matrix): Matrix = Matrix(
    arrayOf(
        intArrayOf(
            this.data[0][0] * b.data[0][0] + this.data[0][1] * b.data[1][0],
            this.data[0][0] * b.data[0][1] + this.data[0][1] * b.data[1][1]
        ),
        intArrayOf(
            this.data[1][0] * b.data[0][0] + this.data[1][1] * b.data[1][0],
            this.data[1][0] * b.data[0][1] + this.data[1][1] * b.data[1][1]
        ),
    )
)

fun multiply(b: IntArray): IntArray = intArrayOf(
    this.data[0][0] * b[0] + this.data[0][1] * b[1],
    this.data[1][0] * b[0] + this.data[1][1] * b[1]
)
```
```swift []
func multiply(_ b: Matrix) -> Matrix {
    return Matrix(data: [
        [
            self.data[0][0] * b.data[0][0] + self.data[0][1] * b.data[1][0],
            self.data[0][0] * b.data[0][1] + self.data[0][1] * b.data[1][1]
        ],
        [
            self.data[1][0] * b.data[0][0] + self.data[1][1] * b.data[1][0],
            self.data[1][0] * b.data[0][1] + self.data[1][1] * b.data[1][1]
        ]
    ])
}

func multiply(_ b: [Int]) -> [Int] {
    return [
        self.data[0][0] * b[0] + self.data[0][1] * b[1],
        self.data[1][0] * b[0] + self.data[1][1] * b[1]
    ]
}
```
```dart []
Matrix multiply (Matrix b) {
    return Matrix([
      [
        this.data[0][0] * b.data[0][0] + this.data[0][1] * b.data[1][0],
        this.data[0][0] * b.data[0][1] + this.data[0][1] * b.data[1][1]
      ],[
        this.data[1][0] * b.data[0][0] + this.data[1][1] * b.data[1][0],
        this.data[1][0] * b.data[0][1] + this.data[1][1] * b.data[1][1]
      ]
    ]);
  }

  List<int> multipliyTwo( List<int> b) {
    return [
      this.data[0][0] * b[0] + this.data[0][1] * b[1],
      this.data[1][0] * b[0] + this.data[1][1] * b[1]
    ];
  }
```
Leve o tempo que precisar para processar esse código. Ele é uma emaranhado de coordenadas. Se fazer isso no carderno já é um desafio, aqui não seria diferente. Mas funções feitas, falta a nossa funcão de pontência, `power`. 

Para usarmos nossa estratégia de ouro (complexidade $O(\log n)$) vamo usar o conceito de **Top-Down da recursão**, ou **dividir para conquistar**. No nosso primeiro algoritmo usamos recursão no final do código, desta vez vamos usar no começo! Assim como visto no teste de mesa, vamos fatorar as metades das potencias ja coletando o valor delas e chamando a própria função (claro que vamos colocar o caso base primeiro, se não a função vai se chamar infinitamente).
Tá mais quais seriam os casos bases? acho que vale recaptular as regras de potência que ja citamos antes mas sem muito *"matemátiquês"*.
- se for 0, matriz identidade
- se for 1, a propria matriz

e depois? depois pegamos a metade `half` que vai ser `power(n/2)`. Vamos pegar ja sua potencia tbm `square` que seria `half * half`  ou o próprio `power(n)`. Seria já essa a resposta? Não! 

Para um valor de `n = 7` temos que para $mˆ7$ `half` seria $mˆ3$ e `square` seria $mˆ6$. Isso nos leva as duas ultimas regras da potência:
- Se for par, usaremos `square`
- Se for ímpar, usaremos `square` * `half`

Assim temos a função power completa!

```python []
def power(self, n: int):
    if n == 0: return Matrix.IDENTITY_MATRIX
    if n == 1: return self

    half = self.power(n // 2)
    square = half.multiply(half)

    return square if n % 2 == 0 else self.multiply(square)
```
```java []
Matrix power(int n) {
        if (n == 0) return IDENTITY_MATRIX;
        if (n == 1) return this;

        Matrix half = this.power(n/2);
        Matrix square = half.multiply(half);

        return (n % 2 == 0) ? square : this.multiply(square);
    }

```
```kotlin []
fun power(n: Int): Matrix {
        if (n == 0) return Matrix.IDENTITY_MATRIX
        if (n == 1) return this

        val half = this.power(n / 2)
        val square = half.multiply(half)
        
        return if (n % 2 == 1) this.multiply(square) else square
    }
```
```swift []
func power(_ n: Int) -> Matrix {
        if (n == 0) { return Matrix.IDENTITY_MATRIX }
        if (n == 1) { return self }

        let half = self.power(n/2)
        let square = half.multiply(half)

        return n % 2 == 0 ? square : self.multiply(square)
    }
```
```dart []
Matrix power(int n){
    if (n == 0) return Matrix.IDENTITY_MATRIX;
    if (n == 1) return this;

    Matrix half = this.power(n ~/ 2);

    Matrix square = half.multiply(half);

    return n % 2 == 1 ? this.multiply(square) : square;

  }
```

Em resumo:

Time complexity: $O(\log n)$
Space complexity: $O(\log n)$ (sim isso mesmo!)

Aqui embaixo, você vê o código completo. Eu seguimentei para que a pudessemos passa por todo o código com calma para facilitar o entendimento.

```python []
class Solution:
    def fib(self, n: int) -> int:
        if n < 2: return n
        
        matrix = Matrix.BASE_MATRIX.power(n - 1)
        
        result_vector = matrix.multiply([1, 0])
        
        return result_vector[0]

class Matrix:
    def __init__(self, data):
        self.data = data

    def multiply(self, other):
        
        if isinstance(other, Matrix):
            b = other.data
            return Matrix([
                [
                    self.data[0][0] * b[0][0] + self.data[0][1] * b[1][0],
                    self.data[0][0] * b[0][1] + self.data[0][1] * b[1][1]
                ],
                [
                    self.data[1][0] * b[0][0] + self.data[1][1] * b[1][0],
                    self.data[1][0] * b[0][1] + self.data[1][1] * b[1][1]
                ]
            ])
        
        elif isinstance(other, list):
            b = other
            return [
                self.data[0][0] * b[0] + self.data[0][1] * b[1],
                self.data[1][0] * b[0] + self.data[1][1] * b[1]
            ]
        
        raise ValueError("Tipo não suportado para multiplicação")

    def power(self, n: int):
        if n == 0: return Matrix.IDENTITY_MATRIX
        if n == 1: return self
        
        half = self.power(n // 2)
        square = half.multiply(half)
        
        return square if n % 2 == 0 else self.multiply(square)

Matrix.IDENTITY_MATRIX = Matrix([[1, 0], [0, 1]])
Matrix.BASE_MATRIX = Matrix([[1, 1], [1, 0]])
```
```java []
class Solution {
    public int fib(int n) {
        if (n < 2) return n;
        
        var matrix = Matrix.BASE_MATRIX.power(n-1);
        var resultVector = matrix.multiply(new int[]{1,0});

        return resultVector[0];
    }
}

record Matrix(int[][] data) {
    public static final Matrix IDENTITY_MATRIX = new Matrix(new int[][] { { 1, 0 }, { 0, 1 } });

    public static final Matrix BASE_MATRIX = new Matrix(new int[][] { { 1, 1 }, { 1, 0 } });

    Matrix multiply(Matrix b) {
        return new Matrix(new int[][] {
                {
                        this.data[0][0] * b.data[0][0] + this.data[0][1] * b.data[1][0],
                        this.data[0][0] * b.data[0][1] + this.data[0][1] * b.data[1][1]
                },
                {
                        this.data[1][0] * b.data[0][0] + this.data[1][1] * b.data[1][0],
                        this.data[1][0] * b.data[0][1] + this.data[1][1] * b.data[1][1]
                }
        });
    }

    int[] multiply(int[] b) {
        return new int[] {
                this.data[0][0] * b[0] + this.data[0][1] * b[1],
                this.data[1][0] * b[0] + this.data[1][1] * b[1]
        };
    }

    Matrix power(int n) {
        if (n == 0) return IDENTITY_MATRIX;
        if (n == 1) return this;

        Matrix half = this.power(n/2);
        Matrix square = half.multiply(half);

        return (n % 2 == 0) ? square : this.multiply(square);
    }
}

```
```kotlin []
class Solution {

    fun fib(n: Int): Int {
        if (n == 0) return 0

        val matrix: Matrix = Matrix.BASE_MATRIX.power(n - 1)
        return matrix.multiply(intArrayOf(1, 0))[0]
    }
}

data class Matrix(val data: Array<IntArray>){
    companion object {
        val IDENTITY_MATRIX = Matrix(arrayOf(
            intArrayOf(1, 0),
            intArrayOf(0, 1)
        ))
        
        val BASE_MATRIX = Matrix(arrayOf(
            intArrayOf(1, 1),
            intArrayOf(1, 0)
        ))
    }

    fun multiply(b: Matrix): Matrix = Matrix(arrayOf(
        intArrayOf(
            this.data[0][0] * b.data[0][0] + this.data[0][1] * b.data[1][0],
            this.data[0][0] * b.data[0][1] + this.data[0][1] * b.data[1][1]
        ),
        intArrayOf(
            this.data[1][0] * b.data[0][0] + this.data[1][1] * b.data[1][0],
            this.data[1][0] * b.data[0][1] + this.data[1][1] * b.data[1][1]
        ),
    ))

    fun multiply(b: IntArray): IntArray = intArrayOf(
        this.data[0][0] * b[0] + this.data[0][1] * b[1],
        this.data[1][0] * b[0] + this.data[1][1] * b[1]
        )

    fun power(n: Int): Matrix {
        if (n == 0) return Matrix.IDENTITY_MATRIX
        if (n == 1) return this

        val half = this.power(n / 2)
        val square = half.multiply(half)
        
        return if (n % 2 == 1) this.multiply(square) else square
    }
}
```
```swift []
class Solution {
    func fib(_ n: Int) -> Int {
        if n < 2 { return n }

        let matrix = Matrix.BASE_MATRIX.power(n-1)
        return matrix.multiply([1,0])[0]

    }
}

struct Matrix {
    let data: [[Int]]

    static let IDENTITY_MATRIX = Matrix(data: [[1,0],[0,1]])
    static let BASE_MATRIX = Matrix(data: [[1,1],[1,0]])

    func multiply(_ b: Matrix) -> Matrix {
        return Matrix(data: [
            [
                self.data[0][0] * b.data[0][0] + self.data[0][1] * b.data[1][0],
                self.data[0][0] * b.data[0][1] + self.data[0][1] * b.data[1][1]
            ],
            [
                self.data[1][0] * b.data[0][0] + self.data[1][1] * b.data[1][0],
                self.data[1][0] * b.data[0][1] + self.data[1][1] * b.data[1][1]
            ]
        ])
    }

    func multiply(_ b: [Int]) -> [Int] {
        return [
            self.data[0][0] * b[0] + self.data[0][1] * b[1],
            self.data[1][0] * b[0] + self.data[1][1] * b[1]
        ]
    }

    func power(_ n: Int) -> Matrix {
        if (n == 0) { return Matrix.IDENTITY_MATRIX }
        if (n == 1) { return self }

        let half = self.power(n/2)
        let square = half.multiply(half)

        return n % 2 == 0 ? square : self.multiply(square)
    }
}
```
```dart []
class Solution {
  int fib(int n) {
    if (n < 2) return n;

    var matrix = Matrix.BASE_MATRIX.power(n - 1);
    return matrix.multipliyTwo([1, 0])[0];
  }
}

extension type const Matrix(List<List<int>> data) {
  static const IDENTITY_MATRIX = Matrix(const [[1, 0],[0, 1]]);
  static const BASE_MATRIX = Matrix(const [[1, 1],[1, 0]]);

  Matrix multiply (Matrix b) {
    return Matrix([
      [
        this.data[0][0] * b.data[0][0] + this.data[0][1] * b.data[1][0],
        this.data[0][0] * b.data[0][1] + this.data[0][1] * b.data[1][1]
      ],[
        this.data[1][0] * b.data[0][0] + this.data[1][1] * b.data[1][0],
        this.data[1][0] * b.data[0][1] + this.data[1][1] * b.data[1][1]
      ]
    ]);
  }

  List<int> multipliyTwo( List<int> b) {
    return [
      this.data[0][0] * b[0] + this.data[0][1] * b[1],
      this.data[1][0] * b[0] + this.data[1][1] * b[1]
    ];
  }

  Matrix power(int n){
    if (n == 0) return Matrix.IDENTITY_MATRIX;
    if (n == 1) return this;

    Matrix half = this.power(n ~/ 2);

    Matrix square = half.multiply(half);

    return n % 2 == 1 ? this.multiply(square) : square;

  }
}
```

Já acabou Jéssica? não! e se na verdade, eu queria fazer você ~torrar a sua mente~ conhecer o conceito de potencia de matrizes para apresentar um modelo mais simples e sucinto de top down?

# Solução com Fast Doubling

Podemos começar falando que pra te explicar a logica da multiplicações de matrizes nenuma matriz foi calculada correto? (usamos apenas as propriedades de função de matrizes ~e criamos duas funções de criar matrizes 2x2 e 1x2~ ). Beleza, vamos explorar mais alguns conceitos matemáticos e usar essa lógica do top down sem perdermos tempo ruminando matrizes!

Vamos voltar ao nosso conceito de fibonacci com multiplicação de matrizes:

$$\begin{pmatrix} F_{n} \\ F_{n-1} \end{pmatrix} = \begin{pmatrix} 1 & 1 \\ 1 & 0 \end{pmatrix}^{n-1} \times \begin{pmatrix} F_1 \\ F_0 \end{pmatrix}$$

lembra da matrix $$M = \begin{pmatrix} 1 & 1 \\ 1 & 0 \end{pmatrix}$$ ?

elevando ela a `n` podemos trocar por:

$$M^n = \begin{pmatrix} F(n+1) & F(n) \\ F(n) & F(n-1) \end{pmatrix}$$

algo como $$\begin{pmatrix} F_{n} \\ F_{n-1} \end{pmatrix} = \begin{pmatrix} F(n+1) & F(n) \\ F(n) & F(n-1) \end{pmatrix} \times \begin{pmatrix} F_1 \\ F_0 \end{pmatrix}$$


ok eu te assustei mas fica tranquilo, vamos apagar tudo isso e deixar somente a matriz resultante, tudo bem?

$$\begin{pmatrix} F(n+1) & F(n) \\ F(n) & F(n-1) \end{pmatrix}$$

se multiplicarmos essa matrix temos a notação $M^{2n} = M^n \times M^n$ e acredite o resultado da multplicação é uma matriz ainda mais sucinta:
$$\begin{pmatrix} b & a \\ a & (b-a) \end{pmatrix}$$

onde:
- $a = F(n)$
- $b = F(n+1)$

Eu te dei os conceitos, você nao precisa entender 100%, basta saber que para `n = 7`por exemplo, nossa matriz $$\begin{pmatrix} b & a \\ a & (b-a) \end{pmatrix}$$, cujo 

- $a = F(n)$ = f(7)
- $b = F(n+1)$= f(8)


a
a
a
a
a
aa
a
a










a
aa
a
a
a
