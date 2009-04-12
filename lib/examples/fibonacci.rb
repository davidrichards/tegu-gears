# The Fibonacci numbers: 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, etc.
class Fibonacci
  include TeguGears
  def process(n)
    n <= 2 ? 1 : Fibonacci.call(n-1) + Fibonacci.call(n-2)
  end
end
