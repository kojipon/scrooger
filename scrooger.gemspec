# frozen_string_literal: true

require_relative 'lib/scrooger/version'

Gem::Specification.new do |spec|
  spec.name          = 'scrooger'
  spec.version       = Scrooger::VERSION
  spec.authors       = ['kojipon']
  spec.email         = ['kojipon@gmail.com']

  spec.summary       = 'Automatic AWS EC2 start/stop tool by Google Calendar.'
  spec.description   = 'This tool starts and stops AWS EC2 instances on Google Calendar schedule.'
  spec.homepage      = 'https://github.com/kojipon/scrooger'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.7.0')
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = spec.homepage

  spec.add_dependency 'aws-sdk-ec2'
  spec.add_dependency 'google-api-client'
  spec.add_dependency 'googleauth'
  spec.add_dependency 'thor'
  spec.add_development_dependency 'rubocop', '>=1.8.0'
  spec.add_development_dependency 'rspec', '>=3.0.0'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'rubocop-rspec'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
