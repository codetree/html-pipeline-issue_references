# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'html/pipeline/issue_references/version'

Gem::Specification.new do |spec|
  spec.name          = "html-pipeline-issue_references"
  spec.version       = HTML::Pipeline::IssueReferences::VERSION
  spec.authors       = ["Derrick Reimer"]
  spec.email         = ["derrickreimer@gmail.com"]

  spec.summary       = %q{An HTML::Pipeline filter for auto-linking GitHub issue references}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/codetree/html-pipeline-issue_references"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "html-pipeline", "~> 2.0"

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
end
