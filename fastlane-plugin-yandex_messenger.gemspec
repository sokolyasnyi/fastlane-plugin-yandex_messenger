# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/yandex_messenger/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-yandex_messenger'
  spec.version       = Fastlane::YandexMessenger::VERSION
  spec.author        = 'Stanislav Sokolov'
  spec.email         = 'stasik_sokolov1899@mail.ru'

  spec.summary       = 'Allows post messages to Yandex Messenger channel'
  spec.homepage      = 'https://github.com/sokolyasnyi/fastlane-plugin-yandex_messenger'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*'] + %w[README.md LICENSE]
  spec.require_paths = ['lib']
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.required_ruby_version = '>= 2.7'

  # Don't add a dependency to fastlane or fastlane_re
  # since this would cause a circular dependency

  # spec.add_dependency 'your-dependency', '~> 1.0.0'
end
