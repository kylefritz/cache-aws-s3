#cache-aws-s3

This gem adds local file caching for the AWS::S3 library. The best use case is if you use S3 to store the readonly/library copy of some object that you need occasionally transform (resize, retouch, etc).

Usage is simple, just add the gem to your bundle

    require 'cache-aws-s3'

From there on, all (supported) calls to AWS::S3::S3Object will be first checked against the cache

    S3FileCache.enable true
    S3FileCache.cache_dir /var/s3filecache

    AWS::S3::S3Object.store 'key', 'some data', 'bucket'
    AWS::S3::S3Object.exists? 'key', 'bucket'
    AWS::S3::S3Object.value 'key', 'bucket'
    AWS::S3::S3Object.url_for 'key', 'bucket'
    AWS::S3::S3Object.delete 'key', 'bucket'

    AWS::S3::S3Object.cached_local? 'key', 'bucket'
    AWS::S3::S3Object.perge_local! 'key', 'bucket'


##Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add spec for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

##Copyright

Copyright (c) 2011 Kyle Fritz

This gem was heavily inspired by (mock-aws-s3)[https://github.com/jkrall/mock-aws-s3]
