# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["Scott Albertson", "Jeff Roush", "Mark Eschbach", "Bob Yeo"]
  gem.email         = %q{jroush@ezpublishing.com}
  gem.summary       = %q{Ruby wrapper for the StreamSend API.}
  gem.description   = %q{Ruby wrapper for the StreamSend API.}
  gem.homepage      = %q{https://github.com/Jeff-R/streamsend-ruby}
  gem.date          = %q{2013-07-09}

  gem.add_dependency "httparty"
  gem.add_dependency "activesupport", "~>3.2"
  gem.add_dependency "builder"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "git-commit-story"
  gem.add_development_dependency "webmock", "~> 1.6"
  gem.add_development_dependency "vcr"
  gem.add_development_dependency "watchr"
  gem.add_development_dependency "ruby-fsevent"
  gem.add_development_dependency "pair-salad"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "streamsend"
  gem.require_paths = ["lib"]
  gem.version       = "0.2.2"
end
