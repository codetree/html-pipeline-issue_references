# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'html/pipeline/issue_references/version'

Gem::Specification.new do |spec|
  spec.name          = 'html-pipeline-issue_references'
  spec.version       = HTML::Pipeline::IssueReferences::VERSION
  spec.authors       = ['Codetree', 'Derrick Reimer']
  spec.email         = ['support@codetree.com', 'derrickreimer@gmail.com']
  spec.summary       = 'An HTML::Pipeline filter for auto-linking GitHub issue references'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/codetree/html-pipeline-issue_references'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }

  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'html-pipeline', '~> 2.12'

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'guard', '~> 2.16'
  spec.add_development_dependency 'guard-minitest', '~> 2.4'
  spec.add_development_dependency 'guard-rubocop', '~> 1.3'
  spec.add_development_dependency 'minitest', '~> 5.14'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rubocop', '~> 0.80.1'
end
