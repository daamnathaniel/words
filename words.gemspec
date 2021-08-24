# frozen_string_literal: true

require_relative "lib/words/version"

Gem::Specification.new do |spec|
  spec.name          = "words"
  spec.version       = Words::VERSION
  spec.authors       = ["Nathaniel Adam"]
  spec.email         = ["daamnathanielatgeemaildotcom"]

  spec.summary       = "find words"
  spec.description   = "find words using different sources (initially datamuse api)"
  spec.homepage      = "https://github.com/daamnathaniel/words"
  spec.required_ruby_version = ">= 2.4.0"

  spec.metadata["homepage_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_dependency "highline"
  spec.add_dependency "recursive-open-struct"
  spec.add_dependency "http"

end
