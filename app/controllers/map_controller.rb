class MapController < ApplicationController
  

  # renders the index view and anything else if needed
  def index
  end

  # find the proximity of items to the company
  def search
    @company = Company.find(params[:company].to_i).to_json
    @company = JSON.parse(@company)
    # render :json => @company.to_json and return unless @company.blank?
    # render :json => {error: "No record  found"}, status: :not_found and return if @company.blank?
    @houses = []
    unless @company.nil?
      lat = @company["lat"]
      long = @company["long"]
      loc1 = [lat, long]
      distance = 0.0;
      average = 0.00;
      Housing.all.each do |house|
        house = house.to_json
        house = JSON.parse(house)
        loc2 = [house["lat"],house["long"]]
        distance = coorDist(lat, long, house["lat"],house["long"])
  #     puts "\n\n\n\n\n\n\n\n\n"+distance.to_s
        @houses << house unless distance.to_f  > params[:distance].to_f
        average += house["price"]
      end
      distance/=@houses.length;
      render :json => {houses: @houses.to_json, avg: average} and return unless @houses.blank?
      render :json => {error: "No houses found :("}, status: :not_found
    else
      render :json => {error: "No companies found :/"}, status: :not_found
    end
  end

  # get all companies
  def all_companies
    @companies = []
    Company.all.each do |comp|
      comp = comp.to_json 
      @companies << JSON.parse(comp)
      puts comp 
    end
    render :json => @companies.to_json and return unless @companies.blank?
    render :json => {error: "Empty database????"}, status: :not_found
  end 
  # add the new company to our DB
  def update
  end

  # google API request to find the lat/long of the company
  def find_company_by_address
  end
  def coorDist(lat1, lon1, lat2, lon2)

      earthRadius = 6371 # Earth's radius in KM

          # convert degrees to radians
          def convDegRad(value)
            unless value.nil? or value == 0
                  value = (value/180) * Math::PI
            end
          return value
          end

      deltaLat = (lat2-lat1)
      deltaLon = (lon2-lon1)
      deltaLat = convDegRad(deltaLat)
      deltaLon = convDegRad(deltaLon)

      # Calculate square of half the chord length between latitude and longitude
      a = Math.sin(deltaLat/2) * Math.sin(deltaLat/2) +
          Math.cos((lat1/180 * Math::PI)) * Math.cos((lat2/180 * Math::PI)) *
          Math.sin(deltaLon/2) * Math.sin(deltaLon/2); 

      # Calculate the angular distance in radians
      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))

      distance = earthRadius * c

    return distance

  end
end
