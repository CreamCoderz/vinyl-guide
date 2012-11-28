class EbayItemsController < ApplicationController
  PAGE_LIMIT = 20
  HOME_PAGE_LIMIT = 4

  before_filter :set_sortable_fields, :only => [:all, :singles, :eps, :lps, :other, :home]
  before_filter :set_page_num, :only => [:all, :singles, :eps, :lps, :other]
  before_filter :set_favorites, :only => [:all, :home, :singles, :eps, :lps, :other, :update]
  before_filter :find_ebay_item, :only => [:edit, :update, :show]
  before_filter :set_release, :only => [:show]
  before_filter :redirect_to_friendly_url, :only => [:show]

  def index
    @release = Release.find(params[:release_id], :include => :ebay_items)
    @ebay_items = @release.ebay_items
  end

  def edit
  end

  def update
    if @ebay_item.update_attributes(params[:ebay_item])
      flash[:notice] = 'The auction was successfully updated.'
      if request.xhr?
        @controls = true
        render :template => "partials/_ebay_item_abbrv.html.haml", :layout => false, :locals => {:ebay_item => @ebay_item}
      else
        redirect_to ebay_item_path(@ebay_item)
      end
    else
      render :action => "edit"
    end
  end

  def home
    @ebay_items = Rails.cache.fetch("recent-items", :expires_in => 5.minutes) { EbayItem.order('endtime DESC').limit(HOME_PAGE_LIMIT) }
    @top_items = Rails.cache.fetch("top-items", :expires_in => 5.minutes) { EbayItem.top_items.limit(HOME_PAGE_LIMIT).all }
  end

  def show
    @ebay_item = EbayItem.find(params[:id], :include => [{:release => [:label_entity, :format, :ebay_items]}, :pictures])
    @related_ebay_items = @ebay_item.related_items
  end

  [:singles, :eps, :lps, :other].each do |m|
    define_method(m) { set_page_results(m) }
  end

  def all
    set_page_results(:all_time)
  end

  private

  def set_sortable_fields
    @parsed_params = ParamsParser.parse_sort_params(params)
    @sort_param, @order_param, @time = @parsed_params.sort, @parsed_params.order, @parsed_params.time
    @order_query = "#{@sort_param} #{@order_param}"
  end

  def set_page_results(scope)
    ebay_items = EbayItem.send(scope).send(@time).order(@order_query).paginate(:page => @page_num, :per_page => '20')
    @page_results = Paginator::Result.new(:paginated_results => ebay_items)
  end

  def set_page_num
    @page_num = ParamsParser.parse_page_param(params)
  end

  def set_favorites
    @favorites = current_user.present? ? current_user.favorites : []
  end

  def find_ebay_item
    @ebay_item = EbayItem.find(params[:id])
  end

  def set_release
    @release = Release.new
    @release.label_entity = Label.new
  end

  def redirect_to_friendly_url
    if request.path != ebay_item_path(@ebay_item)
      redirect_to @ebay_item, status: :moved_permanently
    end
  end
end