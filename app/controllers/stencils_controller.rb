class StencilsController < ApplicationController
  # GET /stencils
  # GET /stencils.json
  def index
    @stencils = Stencil.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @stencils }
    end
  end

  # GET /stencils/1
  # GET /stencils/1.json
  def show
    @stencil = Stencil.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @stencil }
    end
  end

  # GET /stencils/new
  # GET /stencils/new.json
  def new
    @stencil = Stencil.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @stencil }
    end
  end

  # GET /stencils/1/edit
  def edit
    @stencil = Stencil.find(params[:id])
  end

  # POST /stencils
  # POST /stencils.json
  def create
    @stencil = Stencil.new(params[:stencil])

    respond_to do |format|
      if @stencil.save
        format.html { redirect_to @stencil, notice: 'Stencil was successfully created.' }
        format.json { render json: @stencil, status: :created, location: @stencil }
      else
        format.html { render action: "new" }
        format.json { render json: @stencil.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /stencils/1
  # PUT /stencils/1.json
  def update
    @stencil = Stencil.find(params[:id])

    respond_to do |format|
      if @stencil.update_attributes(params[:stencil])
        format.html { redirect_to @stencil, notice: 'Stencil was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @stencil.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stencils/1
  # DELETE /stencils/1.json
  def destroy
    @stencil = Stencil.find(params[:id])
    @stencil.destroy

    respond_to do |format|
      format.html { redirect_to stencils_url }
      format.json { head :no_content }
    end
  end

  def display
    @stencil = Stencil.find(params[:id])
    wid_list = @stencil.widgets.split(",").map {|s| s.to_i}
    @widgets = Widget.find(wid_list)
    @widgets.each do |w|
      if w.breed == 1
        # Nothing here (yet)
      end
    end

    stencil_breed_template = "stencils/breed#{@stencil.breed}"
    render :template => stencil_breed_template, :formats => [:html], :handlers => "haml"
  end



  ### AJAX calls made by widgets

  # AJAX function called by location_map Widget
  def location_map_ajax
    channels_str = params[:channels]
    channel_list = channels_str.split(",").map {|s| s.to_i}

    markers = []    
    channel_list.each do |channel|
      json_str = Net::HTTP.get(URI.parse("http://#{THINGSPEAK_SERVER}/channels/#{channel}/feed.json?results=1&location=true"))
      parsed_hash = ActiveSupport::JSON.decode(json_str)
      entry = parsed_hash["feeds"][0]
      markers.push(entry)
    end
    
    # TBD: Determine centerposition and zoom based on all the markers
    centerposition = {}
    centerposition["latitude"] = 12.9833
    centerposition["longitude"] = 77.5833
    zoom = 10

    render :json => {:markers => markers, :centerposition => centerposition, :zoom => zoom}
  end

  # AJAX function called by table Widget
  def table_ajax
    channels_str = params[:channels]
    channel_list = channels_str.split(",").map {|s| s.to_i}

    markers = []    
    channel_list.each do |channel|
      json_str = Net::HTTP.get(URI.parse("http://#{THINGSPEAK_SERVER}/channels/#{channel}/feed.json?results=1&location=true"))
      parsed_hash = ActiveSupport::JSON.decode(json_str)
      entry = parsed_hash["feeds"][0]
      markers.push(entry)
    end

    render :json => {:markers => markers}
  end

end
