# frozen_string_literal: true

require_relative 'lib/rom/mongo/version'

Gem::Specification.new do |spec|
  spec.name = 'rom-mongodb'
  spec.version = ROM::Mongo::VERSION
  spec.authors = ['Vladislav Trotsenko']
  spec.email = ['admin@bestweb.com.ua']

  spec.summary = %(rom-mongodb)
  spec.description = 'MongoDB adapter for Ruby Object Mapper'

  spec.homepage = 'https://github.com/bestwebua/rom-mongo'
  spec.license = 'MIT'

  spec.metadata = {
    'homepage_uri' => 'https://rom-rb.org',
    'changelog_uri' => 'https://github.com/bestwebua/rom-mongo/blob/master/CHANGELOG.md',
    'source_code_uri' => 'https://github.com/bestwebua/rom-mongo',
    'documentation_uri' => 'https://github.com/bestwebua/rom-mongo/blob/master/README.md',
    'bug_tracker_uri' => 'https://github.com/bestwebua/rom-mongo/issues'
  }

  spec.required_ruby_version = '>= 2.5.0'
  spec.files = `git ls-files -z`.split("\x0").select { |f| f.match(%r{^(bin|lib)/|.ruby-version|rom-mongodb.gemspec|LICENSE}) }
  spec.require_paths = %w[lib]

  rom_version = ::Gem::Version.new(::RUBY_VERSION) >= ::Gem::Version.new('2.7.0') ? '~> 5.3' : '~> 5.2'

  spec.add_runtime_dependency 'mongo', '~> 2.18', '>= 2.18.2'
  spec.add_runtime_dependency 'rom-core', rom_version

  spec.add_development_dependency 'ffaker', '~> 2.21'
  spec.add_development_dependency 'rake', '~> 13.0', '>= 13.0.6'
  spec.add_development_dependency 'rom-repository', rom_version
  spec.add_development_dependency 'rspec', '~> 3.12'
end
