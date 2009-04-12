Feature: Analyst runs functions concurrently
  In order to speed up computation time
  An analyst can run the same function on the same machine in multiple fibers

  I've decided to use NeverBlock for this feature.  It's pretty clean
  and useful.  It runs code in thin threads, called fibers, a new
  feature in Ruby 1.9.  It has a poor-man's fiber for Ruby 1.8 users
  which is a slower but functional Fiber.
  
