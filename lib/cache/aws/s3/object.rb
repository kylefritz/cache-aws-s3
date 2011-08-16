require 'fileutils'
require 'ostruct'

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

module AWS
  module S3

    class S3Object
      class << self

        #TODO: save old value method
        def value(key, bucket = nil, options = {}, &block)
          if cached_local? key, bucket
            data = File.open(path!(bucket, key, options)) {|f| f.read}
            Value.new OpenStruct.new(:body=>data)
          else
            #TODO:
            #1. open normal S3 file
            #2. save local to file_path! (make parent directories)
            #3. return stream
          end
        end

        def file_path!(bucket, name, options = {}) #:nodoc:
          # We're using the second argument for options
          if bucket.is_a?(Hash)
            options.replace(bucket)
            bucket = nil
          end
          S3FileCache.cache_dir.clone << File.join(bucket_name(bucket), name)
        end

        def perge_local!(key,bucket)
          #return delete file at file_path!(bucket,name)
        end

        def cached_local?(key,bucket)
          #return file exists? at file_path!(bucket,name)
        end

      end
    end
  end
end
