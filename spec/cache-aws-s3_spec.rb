require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Cache::AWS::S3" do

  describe 'when using S3Object' do
    before (:each){
      S3FileCache.enabled=true
      @bucket="mittens"
      @key="these/are/our/vista.txt"
      @fp=AWS::S3::S3Object.file_path! @key,@bucket
      FileUtils.mkdir_p File.dirname @fp
      File.open(@fp, 'w') {|f| f.write 'test data'}
    }
    after (:each){
      File.unlink @fp
    }

    it 'resolves files locally' do
      @fp.should == "#{S3FileCache.cache_dir}/#{@bucket}/#{@key}"
    end
    it 'should hit local cache first' do
        AWS::S3::S3Object.should_not_receive(:get)
        AWS::S3::S3Object.should_receive(:read_cache)
        AWS::S3::S3Object.value @key, @bucket
    end
    it 'passes through to regular aws when disabled' do
        S3FileCache.enabled=false
        lambda { AWS::S3::S3Object.value( @key, @bucket)}.should raise_error(AWS::S3::NoConnectionEstablished)
    end
    it 'reads data out of local cache' do
      val=AWS::S3::S3Object.read_cache @key, @bucket
      val.should == 'test data'
    end

  end
end
