require 'spec'
require File.dirname(__FILE__) + '/../../lib/imageclient'
require File.dirname(__FILE__) + "/../base_spec_case"
include BaseSpecCase

describe ImageClient do
  IMG_URL = 'http://thumbs1.ebaystatic.com/pict/1503997991648080_1.jpg'

  before(:each) do
    @webclient = mock('webclient')
  end

  it "should fetch an image" do
    expected_image_file = File.new(File.dirname(__FILE__) + "/../data/best_dressed.jpg", "r")
    expected_image_file_contents = expected_image_file.gets(nil)
    success_response = mock('success_response')
    success_response.should_receive(:kind_of?).with(Net::HTTPSuccess).and_return(true)
    success_response.should_receive(:[]).with('content-type').and_return('image/jpeg')
    success_response.should_receive(:body).and_return(expected_image_file_contents)
    @webclient.should_receive(:get).with(IMG_URL).and_return(success_response)
    fetched_image_file_contents = ImageClient.new(@webclient).fetch(IMG_URL)
    fetched_image_file_contents.should == expected_image_file_contents
  end

  it "should return nil upon 404 response" do
    not_found_response = mock('not_found_response')
    not_found_response.should_receive(:kind_of?).with(Net::HTTPSuccess).and_return(false)
    @webclient.should_receive(:get).with(IMG_URL).and_return(not_found_response)
    ImageClient.new(@webclient).fetch(IMG_URL).should be_nil
  end

  it "should return nil for non-image type response" do
    non_image_response = mock('non_image_response')
    non_image_response.should_receive(:kind_of?).with(Net::HTTPSuccess).and_return(true)
    non_image_response.should_receive(:[]).with('content-type').and_return('text/html')
    @webclient.should_receive(:get).with(IMG_URL).and_return(non_image_response)
    ImageClient.new(@webclient).fetch(IMG_URL).should be_nil
  end

  #TODO catch and log exceptions when fetch images
  it "should log an exception upon error" do
    @webclient.should_receive(:get).with(IMG_URL).and_raise(Exception.new)
    ImageClient.new(@webclient).fetch(IMG_URL).should be_nil
  end

end