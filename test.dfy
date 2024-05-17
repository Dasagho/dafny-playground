function method Factorial(n: nat): nat
    ensures Factorial(n) == (if n == 0 then 1 else n * Factorial(n - 1))
{
    if n == 0 then 1 else n * Factorial(n - 1)
}