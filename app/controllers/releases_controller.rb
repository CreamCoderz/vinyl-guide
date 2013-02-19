class ReleasesController < ApplicationController

#  before_filter :redirect_anonymous, :only => [:new]

  # Return 410 - Gone until the releases feature is fully realized.
  before_filter lambda { render :nothing => true, :status => 410 }

  def index
    @page_num = ParamsParser.parse_page_param(params)
    release_results = Release.includes(:label_entity, :format, :ebay_items).order("artist ASC").paginate(:page => @page_num, :per_page => '20')
    @page_results = Paginator::Result.new(:paginated_results => release_results)
    @releases = @page_results.items
    @parsed_params = ParsedParams.new({})
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @releases }
    end
  end

  def show
    @release = Release.includes(:label_entity, :format, :ebay_items).find(params[:id])
    @page_results = Paginator::Result.from_items(@release.ebay_items)
    @controls = true
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @release }
    end
  end

  def new
    @release = Release.new
    @release.build_label_entity
    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @release }
    end
  end

  def edit
    @release = Release.find(params[:id])
    @release.build_label_entity if @release.label_entity.nil?
  end

  def create
    @release = Release.new(params[:release])
    release_created = @release.save
    if ebay_item_id = params[:ebay_item_id]
      if ebay_item = EbayItem.find_by_id(ebay_item_id.to_i)
        ebay_item.update_attributes!(:release_id => @release.id)
      end
    end
    respond_to do |format|
      if release_created
        flash[:notice] = 'Release was successfully created.'
        format.html { redirect_to(@release) }
        format.json { render :json => @release, :status => :created, :location => @release }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @release.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @release = Release.find(params[:id])

    respond_to do |format|
      if @release.update_attributes(params[:release])
        flash[:notice] = 'Release was successfully updated.'
        format.html { redirect_to(@release) }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @release.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @release = Release.find(params[:id])
    @release.destroy

    respond_to do |format|
      format.html { redirect_to(releases_url) }
      format.xml { head :ok }
    end
  end

  def search
    page_num = ParamsParser.parse_page_param(params)
    query = ParamsParser.parse_query_param(params)
    releases = Release.search(:page => page_num, :query => query)
    respond_to do |format|
      format.json {render :json => {:hits => releases.total, :releases => JSON.parse(releases.items.to_json(:include => {:label_entity => {:only => :name}}, :only => [:matrix_number, :title, :matrix, :artist, :id], :methods => [:link]))}}
    end
  end

  private
  def redirect_anonymous
    redirect_to new_user_session_path unless current_user
  end
end
