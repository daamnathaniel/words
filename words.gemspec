# frozen_string_literal: true

require_relative "lib/words/version"

Gem::Specification.new do |s|
  s.name          = "words"
  s.version       = Words::VERSION
  s.authors       = ["Nathaniel Adam"]
  s.email         = ["daamnathanielatgeemaildotcom"]

  s.summary       = "find words"
  s.description   = "find words using different sources (initially datamuse api)"
  s.homepage      = "https://github.com/daamnathaniel/words"
  s.required_ruby_version = ">= 2.4.0"

  s.metadata["homepage_uri"] = s.homepage

  s.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  s.bindir        = "bin"
  s.executables   = s.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "bundler"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "pry"
  s.add_dependency "recursive-open-struct"
  s.add_dependency "tty-prompt"
  s.add_dependency "blanket"

end
