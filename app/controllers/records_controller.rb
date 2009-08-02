class RecordsController < ApplicationController
  # GET /records
  # GET /records.xml
  def index
    @records = Record.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @records }
    end
  end

  # GET /records/1
  # GET /records/1.xml

  def show
    @record = Record.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @record }
    end
  end

  # GET /records/new
  # GET /records/new.xml

  def new
    @record = Record.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @record }
    end
  end

  # GET /records/1/edit

  def edit
    @record = Record.find(params[:id])
  end

  # POST /records

  def create
    @record = Record.new(params[:record])

    respond_to do |format|
      if @record.save
        flash[:notice] = 'Record was successfully created.'
        format.html { redirect_to(@record) }
        format.xml  { render :xml => @record, :status => :created, :location => @record }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /records/1

  def update
    @record = Record.find(params[:id])

    respond_to do |format|
      if @record.update_attributes(params[:record])
        flash[:notice] = 'Record was successfully updated.'
        format.html { redirect_to(@record) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /records/1

  def destroy
    @record = Record.find(params[:id])
    @record.destroy

    respond_to do |format|
      format.html { redirect_to(records_url) }
    end
  end

end
