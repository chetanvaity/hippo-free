require 'net/http'

class StaticController < ApplicationController
  def initialize(*params)
    super(*params)

    @item_names = ["Anaesthesia_Machine", "Dressing_Scissor_1", "Fine_Scissor_1", "Heart_Lung_Machine", "Dressing_Scissor_2", "Fine_Scissor_2", "Resuscitation_Kit", "Pneumatic_Ventilator", "Dressing_Scissor_3", "Fine_Scissor_3"]
    @home_locs = [1, 1, 1, 2, 2, 2, 3, 3, 3, 3]
  end

  def index
  end

  # Temperature sensors in Vaccine storage room demo
  def demo1
    @feed_entries = []
    
    (4..7).each do |channelnum|
      json_str = Net::HTTP.get(URI.parse("http://" + THINGSPEAK_SERVER + "/channels/#{channelnum}/feed.json?results=5"))
      parsed_hash = ActiveSupport::JSON.decode(json_str)
      parsed_hash["feeds"].each do |e|
        entry = {}
        t = Time.strptime(e["created_at"], "%FT%T%z")
        entry["time"] = t
        entry["created_at"] = t.strftime("%H:%M")
        entry["field1"] = e["field1"].to_i
        entry["field2"] = e["field2"]
        @feed_entries.push(entry)
      end
    end
    @feed_entries.sort! { |a,b| b["time"] <=> a["time"] }
  end

  # AJAX call
  def demo1_curr_temp
    @id = params[:id]
    json_str = Net::HTTP.get(URI.parse("http://#{THINGSPEAK_SERVER}/channels/#{@id}/feed.json?results=1"))
    parsed_hash = ActiveSupport::JSON.decode(json_str)
    e = parsed_hash["feeds"][0]
    @entry = {}
    t = Time.strptime(e["created_at"], "%FT%T%z")
    @entry["time"] = t
    @entry["created_at"] = t.strftime("%H:%M")
    @entry["field1"] = e["field1"].to_i
    @entry["field2"] = e["field2"]
    
    render :template => "static/demo1_curr_temp", :formats => [:json], :handlers => "haml", :layout => false    
  end

  # Operation theater equipment demo - show current locations
  def demo2
    all_items = []
    @loc1_items = []
    @loc2_items = []
    @loc3_items = []

    json_str = Net::HTTP.get(URI.parse("http://#{THINGSPEAK_SERVER}/channels/#{OT_CHANNEL}/feed.json?results=50"))
    parsed_hash = ActiveSupport::JSON.decode(json_str)
    parsed_hash["feeds"].each do |e|
      item = {}
      t = Time.strptime(e["created_at"], "%FT%T%z")
      item["created_at"] = t.strftime("%H:%M")
      item["id"] = e["field1"]
      item["name"] = e["field2"]
      item["home_loc"] = e["field3"]
      item["curr_loc"] = e["field4"]
      item["at_home"] = e["field3"] == e["field4"]
      all_items.push(item)   
    end

    uniq_items = all_items.uniq_by { |item| item["id"] }
    @loc1_items = uniq_items.find_all { |item| item["curr_loc"] == "1" }
    @loc2_items = uniq_items.find_all { |item| item["curr_loc"] == "2" }
    @loc3_items = uniq_items.find_all { |item| item["curr_loc"] == "3" }

    render :template => "static/demo2", :formats => [:html], :handlers => "haml", :layout => "layouts/autorefresh"
  end

  # Operation theater equipment location history
  def demo2_history
    @id = params[:id].to_i
    @item_name = @item_names[@id]
    @home_loc = @home_locs[@id]
  end

  # The AJAX call to get JSON data for chart
  def history_data
    @id = params[:id]
    @item_history = []
    @item_name = @item_names[@id.to_i]
    json_str = Net::HTTP.get(URI.parse("http://#{THINGSPEAK_SERVER}/channels/#{OT_CHANNEL}/feed.json?results=200"))    
    parsed_hash = ActiveSupport::JSON.decode(json_str)
    parsed_hash["feeds"].each do |e|
      if e["field1"] == @id
        item = {}
        t = Time.strptime(e["created_at"], "%FT%T%z")
        item["time"] = t.strftime("%b %d, %Y %H:%M:%S")
        item["curr_loc"] = e["field4"]
        @item_history.push(item)
      end
    end

    render :template => "static/history_data", :formats => [:json], :handlers => "haml", :layout => false
  end

  # Show an OpenStreetMap
  def osm
    # TBD: Get this as a param
    channels = [3, 4]

    # An array of hashes
    @markers = []

    # channels.each do |channel|
    #   json_str = Net::HTTP.get(URI.parse("http://#{THINGSPEAK_SERVER}/channels/#{channel}/feed.json?results=1&location=true"))
    #   parsed_hash = ActiveSupport::JSON.decode(json_str)
    #   entry = parsed_hash["feeds"][0]
    #   @markers.push(entry)
    # end

    # TBD: Determine centerposition and zoom based on all the markers
    @centerposition = {}
    @centerposition["latitude"] = 12.9833
    @centerposition["longitude"] = 77.5833
    @zoom = 10


    # Lets put a randomly moving marker
    entry = {}
    entry["latitude"] = @centerposition["latitude"] + (Random.new.rand * 0.01)
    entry["longitude"] = @centerposition["longitude"] + (Random.new.rand * 0.01)
    logger.debug("lat = " + entry["latitude"].to_s)
    @markers.push(entry)

    # TBD: Pass info attributes to be shown in bubble on each location

    respond_to do |format|
      format.html
      format.json { render :json => {:markers => @markers, :centerposition => @centerposition, :zoom => @zoom}}
    end
  end
  
end
