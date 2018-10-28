lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xod_client/version'

Gem::Specification.new do |spec|
  spec.name          = 'xod_client'
  spec.version       = XodClient::VERSION
  spec.authors       = ['Lev Lukomskyi']
  spec.email         = ['help@teamsatchel.com']
  spec.summary       = %q{Fetch Groupcall's Xporter on Demand data with ease}
  spec.description   = %q{Call info/data/writeback XoD endpoints with this library}
  spec.homepage      = 'https://www.teamsatchel.com'
  spec.license       = 'MIT'
  spec.files         = Dir['{bin,lib}/**/*', *%w(LICENSE.txt README.md)]
  spec.executables   = %w(console)
  spec.require_paths = %w(lib)

  spec.add_development_dependency 'bundler', '~> 1'
  spec.add_development_dependency 'rake', '>= 10', '< 13'
  spec.add_development_dependency 'rspec', '~> 3'
  spec.add_development_dependency 'vcr', '~> 4'
  spec.add_development_dependency 'webmock', '~> 3'
  spec.add_development_dependency 'rubocop-rspec', '~> 1'

  spec.add_dependency 'activesupport', '>= 4', '< 6'
  spec.add_dependency 'faraday', '~> 0'
end
