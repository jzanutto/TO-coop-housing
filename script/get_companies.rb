require 'nokogiri'
require 'open-uri'
require 'httparty'
require 'json'
#name, lat , long, location
def grab_html()
	i = 0
	url = "http://www.simplyhired.ca/a/jobs/list/lc-Toronto/ls-ON/mi-31/pn-#{i}"
	url_prefix = "http://www.simplyhired.ca"
	arr = []
	while(!is_invalid(url))
		html = Nokogiri::HTML(open(url))
		company_childs = html.css("ul#jobs").css("div.job").css("div").css("span.company").children
		location_childs = html.css("ul#jobs").css("div.job").css("div").css("span.location").children
		fillArr(arr,company_childs,location_childs)
		url = "http://www.simplyhired.ca/a/jobs/list/lc-Toronto/ls-ON/mi-31/pn-#{i=i+1}"
	end
	call_maps(arr)
end

def fillArr(array, company_childs,location_childs)
	temp_arr = []
	for i in 0..company_childs.length
		temp_arr << company_childs[i]
		temp_arr << location_childs[i]
		array << temp_arr if !array.include?(temp_arr)
	end
	return array
end

def call_maps(arr)
	for iter in 0..arr.length
		comp = arr[iter][0]
		location[iter][1]
		maps_api_prefix = "http://maps.googleapis.com/maps/api/geocode/json?address="
		maps_api_suffix = "&sensor=true"
		comp = company.to_s.gsub("-","")
		comp = comp.gsub("&amp;", "&")
		comp = comp.gsub("\'","")
		comp = comp.strip
		maps_url = ""
		maps_url = maps_api_prefix<<comp.gsub(" ","+")<<"+"<<location.to_s.strip.gsub(" ","+")<<maps_api_suffix
		resp = HTTParty.get(URI.escape(maps_url))
		json = JSON.parse(resp.body)
		json_a = json["results"]
		json_a.each do |x|
			x.each_pair do |key,val|
				if key == "geometry"
					val.each_pair do |k,v|
						if k == "location"
							puts comp.to_s.concat("*").concat(v["lat"].to_s).concat("*").concat(v["lng"].to_s).concat("*").concat(location.to_s)
						end
					end
				end
			end
		end
	end
end

def is_invalid(url)
	invalid_page_tag = "Hmmm. Did you really mean to view more than 1000 results?"
	html = Nokogiri::HTML(open(url))
	html = html.css("div.error").css("h1").to_s
	return html.include?(invalid_page_tag)
end

if __FILE__ == $0
	grab_html()
end