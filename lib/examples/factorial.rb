class Factorial
  include TeguGears
  def process(n)
    n <= 1 ? 1 : n * Factorial.call(n-1)
  end
end