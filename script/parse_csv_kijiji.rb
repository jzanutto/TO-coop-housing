require 'json'
require 'httparty'

def getLAT_LONG(data)
	data.each do |place|
		maps_api_prefix = "http://maps.googleapis.com/maps/api/geocode/json?address="
		maps_api_suffix = "&sensor=true"
		maps_url = ""
		maps_url = maps_api_prefix.concat(place[1].strip.gsub(" ","+")).concat(maps_api_suffix)
		resp = HTTParty.get(maps_url)
		json = JSON.parse(resp.body)
		json_a = json["results"]
		json_a.each do |x|
			x.each_pair do |key,val|
				if key == "geometry"
					val.each_pair do |k,v|
						if k == "location"
							puts place[0].gsub("$","").concat("**").concat(v["lat"].to_s).concat("**").concat(v["lng"].to_s).concat("**").concat(place[1])
						end
					end
				end
			end
		end
	end
end

if __FILE__ == $0
	filename = ARGV[0]
	file = File.open(filename,'r')
	values = []
	while(!file.eof())
		temp = file.gets
		temp = temp.gsub("\\n","")
		values << temp if (!temp.empty? && temp.gsub(" ","") != "**")
	end
	cleaned = []
	values.each do |val|
		if val.strip != "**"
			if !val.include?("Please contact") && !val.include?("Swap / Trade")
				cleaned << val.split("**  ")
			end
		end
	end
	fully_clean = []
	cleaned.each do |x|
		if x[1] != "Toronto, ON, Canada" && x[1] != "Mississauga, ON, Canada" && x[1] != "North York, ON, Canada" && x[1] != "l5j3k7"
			fully_clean << x
		end
	end
	getLAT_LONG(fully_clean)
end