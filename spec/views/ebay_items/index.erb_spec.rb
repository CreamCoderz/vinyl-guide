require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/ebay_items/index.erb" do
  include EbayItemsHelper
  before do
    @release = Factory(:release,
                          :title => "value for title",
                          :artist => "value for artist",
                          :year => 1978,
                          :label_entity => Factory(:label, :name =>"value for label"),
                          :matrix_number => "value for matrix_number"
    )
    assigns[:release] = @release
    @ebay_item = Factory(:ebay_item,
                         :price => 25.50,
                         :title => "OG '78 press",
                         :endtime => Time.now,
                         :hasimage => true,
                         :id => 100)
    assigns[:page_results] = Paginator::Result.new(:paginated_results => WillPaginate::Collection.create(1, 1, 0) do |pager|
      pager.replace([@ebay_item])
    end)
    assigns[:parsed_params] = ParsedParams.new({})
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ title/)
    response.should have_text(/value\ for\ artist/)
    response.should have_text(/1978/)
    response.should have_text(/value\ for\ label/)
    response.should have_text(/value\ for\ matrix_number/)
    response.should have_text(/25\.50/)
    response.should have_text(/\/images\/gallery\/100/)
    response.should_not have_text(/\/images\/gallery\/200/)
    response.should have_text(/OG '78 press/)
  end

end
