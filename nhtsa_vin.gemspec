require File.expand_path('../lib/nhtsa_vin/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'nhtsa_vin'
  gem.version       = NhtsaVin::VERSION
  gem.platform      = Gem::Platform::RUBY

  gem.summary       = 'A ruby library for accessing vin records from the NHTSA'
  gem.description   = IO.read(File.join(File.dirname(__FILE__), 'README.md'))
  gem.homepage      = 'https://github.com/deliv/nhtsa_vin'
  gem.licenses      = ['MIT']
  gem.authors       = ['Barclay Loftus']
  gem.email         = ['barclay@deliv.co']

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.required_ruby_version = '>= 2.3.0'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'rspec'
end
