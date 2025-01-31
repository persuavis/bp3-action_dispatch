# frozen_string_literal: true

require_relative 'lib/bp3/action_dispatch/version'

Gem::Specification.new do |spec|
  spec.name = 'bp3-action_dispatch'
  spec.version = Bp3::ActionDispatch::VERSION
  spec.authors = ['Wim den Braven']
  spec.email = ['wimdenbraven@persuavis.com']

  spec.summary = 'bp3-action_dispatch adapts ActionDispatch::Request for BP3 (persuavis/black_phoebe_3).'
  # spec.description = "TODO: Write a longer description or delete this line."
  spec.homepage = 'https://www.black-phoebe.com'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.2.0'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/persuavis/bp3-action_dispatch'
  spec.metadata['changelog_uri'] = 'https://github.com/persuavis/bp3-action_dispatch/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'actionpack', '>= 7.1.2'
  spec.add_dependency 'activesupport', '>= 7.1.2'
  spec.add_dependency 'i18n', '>= 1.8.11'

  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'rake', '>= 13.0'
  spec.add_development_dependency 'rspec', '>= 3.0'
  spec.add_development_dependency 'rubocop', '>= 1.21'
  spec.add_development_dependency 'rubocop-rake', '>= 0.6'
  spec.add_development_dependency 'rubocop-rspec', '>= 2.25'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
