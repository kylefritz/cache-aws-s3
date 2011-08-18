# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cache/aws/s3/version"

Gem::Specification.new do |s|
  s.name        = "cache-aws-s3"
  s.version     = Cache::AWS::S3::VERSION
  s.authors     = ["Kyle Fritz"]
  s.email       = ["kyle.p.fritz@gmail.com"]
  s.homepage    = "https://github.com/kylefritz/cache-aws-s3"
  s.summary     = %q{local cache for s3 data}
  s.description = %q{speed up repeated access to s3 data with a local cache}

  s.rubyforge_project = "cache-aws-s3"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "aws-s3"

  s.add_development_dependency "rspec"
  #s.add_development_dependency "cucumber"
end
