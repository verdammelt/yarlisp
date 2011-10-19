# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "yarlisp/version"

Gem::Specification.new do |s|
  s.name        = "yarlisp"
  s.version     = Yarlisp::VERSION
  s.authors     = ["Mark Simpson"]
  s.email       = ["verdammelt@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{A toy implementation of McCarthy's LISP in Ruby.}
  s.description = %q{I must assume that someone has already implmented Lisp in Ruby and thus I name this 'Yet Another Ruby Lisp"}

  s.rubyforge_project = "yarlisp"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
