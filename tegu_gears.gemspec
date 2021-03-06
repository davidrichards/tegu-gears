# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{tegu_gears}
  s.version = "0.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Richards"]
  s.date = %q{2009-04-28}
  s.description = %q{TODO}
  s.email = %q{davidlamontrichards@gmail.com}
  s.files = ["VERSION.yml", "lib/examples", "lib/examples/factorial.rb", "lib/examples/fibonacci.rb", "lib/examples/regression.rb", "lib/tegu_gears", "lib/tegu_gears/compose.rb", "lib/tegu_gears/dynamics", "lib/tegu_gears/dynamics/node.rb", "lib/tegu_gears/dynamics/noodle.rb", "lib/tegu_gears/dynamics/operator.rb", "lib/tegu_gears/dynamics.rb", "lib/tegu_gears/memo_repository.rb", "lib/tegu_gears/memoize.rb", "lib/tegu_gears.rb", "spec/lib", "spec/lib/examples", "spec/lib/examples/factorial_spec.rb", "spec/lib/examples/fibonacci_spec.rb", "spec/lib/tegu_gears", "spec/lib/tegu_gears/compose_spec.rb", "spec/lib/tegu_gears/memo_repository_spec.rb", "spec/lib/tegu_gears/memoize_spec.rb", "spec/spec_helper.rb", "spec/tegu_gears_spec.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/davidrichards/tegu_gears}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{TODO}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
