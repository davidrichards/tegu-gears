Given /^the desire to know (.+)$/ do |algorithm|
  case algorithm
  when 'the 10th fibonacci number'
    @function = Fibonacci.new
    @params = 10
    @answer = 55
  when 'the factorial of 10'
    @function = Factorial.new
    @params = 10
    @answer = 3628800
  else
    raise ArgumentError, "Don't know how to setup #{algorithm} yet"
  end
end

When /^I ask for the number$/ do
  @return = @function.call(@params)
end

Then /^I should get the correct number$/ do
  @return.should eql(@answer)
end

Then /^it should be faster than a non\-memoized version of the same function$/ do
  @unmemoized_function = @function.dup
  @unmemoized_function.memoize = false

  require 'benchmark'
  class Benchmark::Tms
    def to_f
      to_s.split(/\(|\)/)[-2].to_f
    end
  end

  m1 = Benchmark.measure {@unmemoized_return = @unmemoized_function.call(@params)}
  m2 = Benchmark.measure {@return = @function.call(@params)}
  (m1.to_f > m2.to_f).should eql(true)

end

# Get a few things ready
class Square
  include TeguGears
  def process(n)
    n * n
  end
end

class SquareRoot
  include TeguGears
  def process(n)
    Math.sqrt(n)
  end
end

Given /^a function to (.+)$/ do |purpose|
  @purposes ||= {}
  @final_params = 2.0
  @final_answer = 2.0
  case purpose
  when 'square a number'
    @purposes[:first] =  Square
  when 'take the square root of a number'
    @purposes[:second] =  SquareRoot
  when 'quadruple a value'
    @purposes[:quadruple] = lambda{|x| x * 4.0}
  when 'divide a number by four'
    @purposes[:divide_by_4] = lambda{|x| x / 4.0}
  else
    raise ArgumentError, "Unknown purpose: #{purpose}"
  end
end

When /^I compose these two functions$/ do
  @result = 
    (@purposes[:first] | @purposes[:second]).call(@final_params)
end

Then /^I should get the correct result$/ do
  @result.should be_close(@final_answer, 0.00001)
end

# The only trick, with the way I setup these steps, is they have to evaluate to two.
When /^I compose these functions$/ do
  @result = compose(*@purposes.values.push(2.0))
end