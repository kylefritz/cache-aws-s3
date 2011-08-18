require 'fileutils'
require 'ostruct'

class S3FileCache
  class << self
    attr_accessor :enabled, :cache_dir
    def enabled?
      self.enabled
    end
  end
  @enabled=true
  @cache_dir = "./s3filecache"
end

module AWS
  module S3

    class S3Object
      class << self

        #save old value method
        #alias value s3_value

        #TODO: ignoring the &block for the moment
        def value(key, bucket = nil, options = {}, &block)
          if not S3FileCache.enabled
            return s3_value(key,bucket,options,&block);
          end

          if cached_local? key, bucket
            #return cached object
            read_cache(key,bucket,options)
          else
            #1. open normal S3 file
            value = s3_value(key,bucket,options) #omitting the block for now

            #2. save local to file_path! (make parent directories)
            cache_local(value,key,bucket,options)

            #3. return the value object
            value
          end
        end

        def read_cache(key,bucket,options={})
            data = File.open(file_path!(key,bucket, options)) {|f| f.read}
            Value.new OpenStruct.new(:body=>data)
        end

        def cache_local(value,key,bucket,options={})
            fp=file_path!(key,bucket,options)
            FileUtils.mkdir_p File.dirname fp
            File.open(fp,'w') {|io| io.write value.response}
        end

        def file_path!(key,bucket, options = {}) #:nodoc:
          # We're using the second argument for options
          if bucket.is_a?(Hash)
            options.replace(bucket)
            bucket = nil
          end
          S3FileCache.cache_dir.clone << File.join(bucket_name(bucket), key)
        end

        def perge_local!(key,bucket)
          #return delete file at file_path!(bucket,name)
          file_path= file_path!(key,bucket)
          File.unlink file_path if File.exists? file_path
        end

        def cached_local?(key,bucket)
          #return file exists? at file_path!(bucket,name)
          File.exists? file_path!(key,bucket)
        end

      end
    end
  end
end
