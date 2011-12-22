# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "tracelogger/version"

Gem::Specification.new do |s|
  s.name        = "tracelogger"
  s.version     = Tracelogger::VERSION
  s.authors     = ["Pavel Argentov"]
  s.email       = ["argentoff@gmail.com"]
  s.homepage    = "https://github.com/argent-smith/tracelogger"
  s.summary     = %q{Simple traceroute logger}
  s.description = %q{"tracelogger host" sends the results of `traceroute #{host}` to syslog.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "yard"
  s.add_development_dependency "rdoc"
  s.add_development_dependency "redcarpet"
  s.add_development_dependency "rake"
  s.add_runtime_dependency "log4r"
end
