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