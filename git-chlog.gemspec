# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "git/chlog/version"

Gem::Specification.new do |spec|
  spec.name          = "git-chlog"
  spec.version       = Git::Chlog::VERSION
  spec.authors       = ["Huiming Teo"]
  spec.email         = ["teohuiming@gmail.com"]

  spec.summary       = %q{Print changelog for PR-based git repo.}
  spec.description   = %q{This gem provides a git custom command `git chlog` to print changelog with a list of merged pull-requests grouped by tags in a git repository.}
  spec.homepage      = "https://github.com/teohm/git-chlog"
  spec.license       = "MIT"

  if spec.respond_to?(:metadata=)
    spec.metadata = {
      "allowed_push_host" => "http://rubygems.org",
      "bug_tracker_uri" => "http://github.com/teohm/git-chlog/issues",
      "changelog_uri" => "https://github.com/teohm/git-chlog/blob/master/CHANGELOG.md",
      "homepage_uri" => "https://github.com/teohm/git-chlog",
      "source_code_uri" => "https://github.com/teohm/git-chlog"
    }
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
