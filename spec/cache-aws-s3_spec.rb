require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Cache::AWS::S3" do

  describe 'when using S3Object' do
    before (:each){ S3FileCache.enabled=true }

    it 'resolves files locally' do
      bucket="mittens"
      key="these/are/our/vista.txt"
      fp=AWS::S3::S3Object.file_path! key,bucket
      fp.should == "#{S3FileCache.cache_dir}/#{bucket}/#{key}"
    end
    it 'should hit local cache first' do
        AWS::S3::S3Object.should_not_receive(:get)
        AWS::S3::S3Object.value 'to_key', 'bucket'
    end
    it 'passes through to regular aws when disabled' do
        S3FileCache.enabled=false
        AWS::S3::S3Object.should_receive(:get)
        AWS::S3::S3Object.value 'to_key', 'bucket'
    end
    it 'reads data out of local cache' do
      #setup
      bucket="mittens"
      key="these/are/our/vista.txt"
      fp=AWS::S3::S3Object.file_path! key, bucket
      File.open(fp, 'w') {|f| f.write 'test data'}

      val=AWS::S3::S3Object.read_cache key, bucket
      val.response.should == 'test data'
    end

  end

#  describe 'when using S3Object' do
#    def create_test_file(key, bucket='bucket')
#      File.open("./tmp/mock-aws-s3/#{bucket}/#{key}", 'w') {|f| f.write 'test data'}
#    end
#    def remove_test_file(key, bucket='bucket')
#      File.unlink("./tmp/mock-aws-s3/#{bucket}/#{key}")
#    end
#
#    describe '#copy' do
#      before(:each) { create_test_file 'from_key' }
#      after(:each) do
#        remove_test_file 'from_key'
#        remove_test_file 'to_key'
#      end
#      it 'should not do an actual request' do
#        AWS::S3::S3Object.should_not_receive(:put)
#        AWS::S3::S3Object.copy 'from_key', 'to_key', 'bucket'
#      end
#      it 'should copy the file' do
#        AWS::S3::S3Object.copy 'from_key', 'to_key', 'bucket'
#        File.exists?('./tmp/mock-aws-s3/bucket/from_key').should be_true
#        File.exists?('./tmp/mock-aws-s3/bucket/to_key').should be_true
#      end
#    end
#    describe '#exists?' do
#      it 'should not do an actual request' do
#        AWS::S3::S3Object.should_not_receive(:head)
#        AWS::S3::S3Object.exists? 'key', 'bucket'
#      end
#      it 'should return true if the file exists' do
#        create_test_file 'key'
#        AWS::S3::S3Object.exists?('key', 'bucket').should be_true
#        remove_test_file 'key'
#      end
#      it 'should return false if the file does not exist' do
#        remove_test_file 'key' rescue nil
#        AWS::S3::S3Object.exists?('key', 'bucket').should be_false
#      end
#    end
#    describe '#delete' do
#      before(:each) { create_test_file 'key' }
#      it 'should not do an actual request' do
#        AWS::S3::Base.should_not_receive(:delete)
#        AWS::S3::S3Object.delete('key', 'bucket')
#      end
#      it 'should delete the file' do
#        AWS::S3::S3Object.delete('key', 'bucket')
#        File.exists?('./tmp/mock-aws-s3/bucket/key').should be_false
#      end
#    end
#    describe '#store' do
#      it 'should not do an actual request' do
#        AWS::S3::S3Object.should_not_receive(:put)
#        AWS::S3::S3Object.store 'key', 'some data', 'bucket'
#      end
#      it 'should store the data in the file' do
#        AWS::S3::S3Object.store 'key', 'some data', 'bucket'
#        File.open('./tmp/mock-aws-s3/bucket/key') do |f|
#          f.read.should == 'some data'
#        end
#        remove_test_file 'key'
#      end
#    end
#    describe '#value' do
#      before(:each) { create_test_file 'key' }
#      after(:each) { remove_test_file 'key' }
#      it 'should not do an actual request' do
#        AWS::S3::Base.should_not_receive(:get)
#        AWS::S3::S3Object.value('key', 'bucket')
#      end
#    end
#    describe '#find' do
#      before(:each) { create_test_file 'key' }
#      after(:each) { remove_test_file 'key' }
#      it 'should not do an actual request' do
#        AWS::S3::Base.should_not_receive(:get)
#        AWS::S3::S3Object.find('key', 'bucket')
#      end
#    end
#    describe '#url_for' do
#      before(:each) { create_test_file 'key' }
#      after(:each) { remove_test_file 'key' }
#      it 'should not do an actual request' do
#        AWS::S3::Base.should_not_receive(:get)
#        AWS::S3::S3Object.url_for('key', 'bucket')
#      end
#      it 'should return a local file uri' do
#        url = AWS::S3::S3Object.url_for('key', 'bucket')
#        url.should == 'file://' + File.expand_path(File.dirname(__FILE__) + '/../tmp/mock-aws-s3/bucket/key')
#      end
#    end
#  end

end
