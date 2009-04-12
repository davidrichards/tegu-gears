Dir.glob("#{File.dirname(__FILE__)}/tegu_gears/*.rb").each { |file| require file }
module TeguGears
  def self.included(base)
    base.send(:include, Memoize)
  end
end


# Require the examples too, they are meant to be generally interesting or useful.
Dir.glob("#{File.dirname(__FILE__)}/examples/*.rb").each { |file| require file }


