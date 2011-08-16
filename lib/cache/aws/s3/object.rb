require 'fileutils'
require 'ostruct'

module AWS
  module S3

    class S3Object
      class << self

        def value(key, bucket = nil, options = {}, &block)
          data = File.open(path!(bucket, key, options)) {|f| f.read}
          Value.new OpenStruct.new(:body=>data)
        end

        def url_for(key, bucket = nil, options={})
         "file://#{File.expand_path(path!(bucket, key))}"
        end

        def find(key, bucket = nil)
          raise NoSuchKey.new("No such key `#{key}'", bucket) unless exists?(key, bucket)
          bucket = Bucket.new(:name => bucket)
          object = bucket.new_object
          object.key = key
          object
        end

        def exists?(key, bucket = nil)
          File.exists?(path!(bucket, key))
        end


        TEMP_PATH = begin
          if defined?(::Rails)
            Rails.root.to_s
          else
            '.'
          end
        end

        def path!(bucket, name, options = {}) #:nodoc:
          # We're using the second argument for options
          if bucket.is_a?(Hash)
            options.replace(bucket)
            bucket = nil
          end
          TEMP_PATH.clone << File.join('/tmp', 'mock-aws-s3', bucket_name(bucket), name)
        end

        def perge_local!

        end

        def cached_local?

        end

      end
    end
  end
end
