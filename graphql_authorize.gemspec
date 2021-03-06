
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "graphql_authorize/version"

Gem::Specification.new do |spec|
  spec.name          = "graphql_authorize"
  spec.version       = GraphqlAuthorize::VERSION
  spec.authors       = ["DmitryTsepelev"]
  spec.email         = ["dmitry.a.tsepelev@gmail.com"]

  spec.summary       = %q{Auth support for ruby-graphql}
  spec.description   = %q{Auth support for ruby-graphql}
  spec.homepage      = "https://github.com/anjlab/graphql_authorize"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.3"

  spec.add_dependency "graphql", ">= 1.6"
  spec.add_dependency "i18n", "~> 1.1"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rubocop", "0.58.2"
  spec.add_development_dependency "cancancan", "~> 2.0"
  spec.add_development_dependency "pundit"
  spec.add_development_dependency "activesupport"
  spec.add_development_dependency "i18n-tasks", "~> 0.9.25"
end
