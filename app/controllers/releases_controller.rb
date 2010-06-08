require File.expand_path(File.dirname(__FILE__) + "/../../lib/serializer/auto_complete_serializer")

class ReleasesController < ApplicationController
  # GET /releases
  # GET /releases.xml
  def index
    @releases = Release.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @releases }
    end
  end

  # GET /releases/1
  # GET /releases/1.xml
  def show
    @release = Release.find(params[:id], :include => :ebay_items)
    @ebay_items = @release.ebay_items
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @release }
    end
  end

  # GET /releases/new
  # GET /releases/new.xml
  def new
    @release = Release.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @release }
    end
  end

  # GET /releases/1/edit
  def edit
    @release = Release.find(params[:id])
  end

  # POST /releases
  # POST /releases.xml
  def create
    @release = Release.new(params[:release])

    respond_to do |format|
      if @release.save
        flash[:notice] = 'Release was successfully created.'
        format.html { redirect_to(@release) }
        format.xml { render :xml => @release, :status => :created, :location => @release }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @release.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /releases/1
  # PUT /releases/1.xml
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

  # DELETE /releases/1
  # DELETE /releases/1.xml
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
      format.json { render :json => releases[0].to_json(:only => [:title], :methods => [:link]) }
    end
  end
end
