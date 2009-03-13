require File.join(File.dirname(__FILE__), %w(.. lib tegu_gears))

include TeguGears

# Show concurrency example (run something faster in a pool than on its own)