require 'spec'
require 'activesupport'
require 'activerecord'

require File.dirname(__FILE__) + "/../../../app/util/image_injector"
require File.dirname(__FILE__) + "/../../base_spec_case"

describe ImageInjector do

  THE_COLONIAL_DAYS = DateTime.parse('1776-08-20T10:20:00+00:00')
  ITEM_ID = 12345

  before(:each) do
    @data_builder = EbayItemDataBuilder.new
    @image_client = ImageClient.new(WebClient.new(SettableHttpClient.new(nil, nil)))
    FileUtils.mkdir(File.dirname(__FILE__) + "/../../../spec/data/tmp/gallery")
    FileUtils.mkdir(File.dirname(__FILE__) + "/../../../spec/data/tmp/pictures")
  end

  after(:each) do
    FileUtils.rm_rf(File.dirname(__FILE__) + "/../../../spec/data/tmp/gallery")
    FileUtils.rm_rf(File.dirname(__FILE__) + "/../../../spec/data/tmp/pictures")
  end

  #TODO: should write images to filesystem

end

