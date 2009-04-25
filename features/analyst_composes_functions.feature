Feature: Analyst composes functions
  In order to combine functions into one function
  An analyst joins two functions 
  and gets a smoothly-running function

  Many functions are building blocks for more useful functions.
  Certainly a lot of the statistical and machine learning algorithms
  will re-use large parts of their algorithms.  TeguGears makes this
  fairly simple with a pipe (|).  I was very impressed with the Tap gem
  that Simon Chiang put together.  It has forks, merges, joins, and
  does all sorts of other tools.  Simon uses Tap to do some very
  sophisticated analysis.  I may decide to use that instead in the
  future, but this works for now.
  
  One reason composition is so important is that this code will be run
  concurrently and distributed across a network.  The computational
  chunks need to be clean so that we don't create a mess for ourselves.
  
  Also, there is another concept of tap in Ruby 1.9.  This takes the
  chains functions together with the unadulturated parameters.  This is
  useful in a lot of machine learning algorithms where there are sums of
  a vector manipulated added or divided to sums of the same vector,
  manipulated a little differently.  That kind of composition is just
  short hand to be able to re-use the same vectors and arrays.
  

  Scenario: Two functions are joined
    Given a function to square a number
    And a function to take the square root of a number
    When I compose these two functions
    Then I should get the correct result
    
  Scenario: Many functions are joined
    Given a function to square a number
    And a function to take the square root of a number
    And a function to quadruple a value
    And a function to divide a number by four
    When I compose these functions
    Then I should get the correct result
