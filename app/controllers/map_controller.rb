class MapController < ApplicationController
  

  # renders the index view and anything else if needed
  def index
  end

  # find the proximity of items to the company
  def search
    params[:company] ||= 0
    @company = Company.find(params[:company])
    @company = JSON.parse(@company)[0]
    # render :json => @company.to_json and return unless @company.blank?
    # render :json => {error: "No record  found"}, status: :not_found and return if @company.blank?
    @houses = []
    unless @company.blank?
      lat = @company["lat"]
      long = @company["long"]
      loc1 = [lat, long]
      distance = 0;
      average = 0.00;
      Housing.all.each do |house|
        house = house.to_json
        house = JSON.parse(house)
        loc2 = [house["lat"],house["long"]]
        distance = distance(loc1, loc2)
  #     puts "\n\n\n\n\n\n\n\n\n"+distance.to_s
        @houses << house unless distance.to_f  > params[:distance].to_f
        average += @houses.last["price"]
      end
      distance/=@houses.length;
      render :json => {houses: @houses.to_json.to_a, avg: average} and return unless @houses.blank?
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

private

    def to_rad num
      num * Math::PI / 180
    end
  # loc1 and loc2 are arrays of [latitude, longitude] 
  def distance loc1, loc2
    lat1, lon1 = loc1
    lat2, lon2 = loc2
    dLat = to_rad(lat2-lat1);
    dLon = to_rad(lon2-lon1);
    a = Math.sin(dLat/2) * Math.sin(dLat/2) +
      Math.cos(to_rad(lat1)) * Math.cos(to_rad(lat2)) *
      Math.sin(dLon/2) * Math.sin(dLon/2);
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    # puts lat1.to_s << " "<<lon1.to_s << " " <<lat2.to_s<<" "<<lon2.to_s << "\n\n\n"
    d = 6371 * c; # Multiply by 6371 to get Kilometers
  end

end
