require 'aws/s3'

class S3FileCache
  class << self
    attr_accessor :enabled, :cache_dir
    def enabled?
      self.enabled
    end
  end
  @enabled=false
  @cache_dir = "./s3filecache/"
end

require 'cache/aws/s3/object'
