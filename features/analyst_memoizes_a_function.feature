Feature: Analyst memoizes a function
  In order to speed up computation time
  An analyst is willing to store results to function calls
  caching results and ultimately trading memory for computation time.

  Even a simple memoization scheme can really save a lot of
  computation time.  If you include TeguGears in your class, the default
  behavior is to memoize the result.  That means that a result is cached
  according to its parameters.  If you ask for the same function with
  the same parameters, a cached version will be returned instead of
  calculated.  The tradeoff is memory is used instead of computational
  time.  This can easily be turned off by telling the class or instance
  to not memoize:
  
  class A
    include TeguGears
    def process(n)
      # Whatever process
    end
  end
  A.memoize = false
  
  Scenario Outline: A series of memoized demonstrations
    Given the desire to know <algorithm>
    When I ask for the number
    Then I should get the correct number
    And it should be faster than a non-memoized version of the same function

  Scenarios: Recursive algorithms
    |algorithm|
    |the 10th fibonacci number|
    |the factorial of 10|
    