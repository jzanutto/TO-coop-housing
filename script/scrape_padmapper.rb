require 'httparty'
require 'json'
require 'nokogiri'
require 'open-uri'
require 'rubygems'

PRICE_REGEX = /([0-9]|[,])+<{1}/
#id="infoImageDiv"

def padmapper_html(a_id, lat, long)
	mapper_url = "https://www.padmapper.com/loadApartDescription.php?apartmentID=%aid&workLat=%lat&workLong=%long"
	mapper_url = mapper_url.gsub("%aid",a_id.to_s)
	mapper_url = mapper_url.gsub("%lat",lat.to_s)
	mapper_url = mapper_url.gsub("%long",long.to_s)
	mapper_url = URI.escape(mapper_url)
	html = Nokogiri::HTML(open(mapper_url))
	price = html.to_s.match(PRICE_REGEX).to_s.gsub("<","")
	address = html.css("div#listingSummaryDiv")
	i = 0
	address.children.each do |child|
		if(child.to_s.gsub("\\","").to_s.include?("<div id=\"infoImageDiv\""))
			i = i-2
			break
		end
		i = i+1
	end
	address = address.children[i].to_s
	puts price.to_s.concat(" ** ").concat(lat.to_s).concat(" ** ").concat(long.to_s).concat(" ** ").concat(address.to_s)
end

def padmapper_json()
	json_url = "https://www.padmapper.com/reloadMarkersJSON.php?eastLong=-79.03564453125&northLat=43.89063976675623&westLong=-79.73087310791016&southLat=43.41593945495278&cities=false&showPOI=false&limit=875&minRent=0&maxRent=6000&searchTerms=Words+Required+In+Listing&maxPricePerBedroom=6000&minBR=0&maxBR=10&minBA=1&maxAge=7&imagesOnly=false&phoneReq=false&cats=false&dogs=false&noFee=false&showSubs=true&showNonSubs=true&showRooms=true&userId=-1&cl=true&pl=true&apts=true&rhp=true&rnt=true&airbnb=true&ood=true&af=true&rltr=true&rntscl=true&zoom=12&favsOnly=false&onlyHQ=true&showHidden=false&workplaceLat=0&workplaceLong=0&maxTime=0"
	resp = HTTParty.get(json_url)
	json = JSON.parse(resp.body)
	json.each do |x|
		padmapper_html(x['id'],x['lat'],x['lng'])
	end
end

def kijiji_html()
	i = -1;
	url = "http://toronto.kijiji.ca/f-real-estate-room-rental-roommates-W0QQCatIdZ36QQPageZ0"
	page_i = 1
	while(Nokogiri::HTML(open(increase_page(url))).css("div.currentPage").children[0].to_s.gsub(" ","").to_i == page_i)	
		page_i=page_i+1
		url = increase_page(url)
		html = Nokogiri::HTML(open(url))
		i=-1
		while(html.css("tr#resultFeatRow#{i+1}").children != nil || html.css("tr#resultFeatRow#{i+1}").children.length !=0)
			html_parse = html.css("tr#resultFeatRow#{i=i+1}").children
			html_parse = html_parse.css("a")
			break if html_parse.to_s.empty?
			hash = html_parse.css('a[href]').each_with_object(Hash.new { |h,k| h[k] = [ ]}) { |n, h| h[n.text.strip] << n['href'] }
			hash.each_pair do |k,v|
				visit_page_kijiji(v[0])
				break
			end
		end
	end
end

def increase_page(url)
	index = url.index("Page")+4
	new_iter = url[index+1..url.length].to_i + 1
	return url[0..index].concat(new_iter.to_s)
	#return url[0..(url.index("Page")+5)].concat(url[(url.index("Page")+5)..url.length].to_i+1)
end

def visit_page_kijiji(url)
	html = Nokogiri::HTML(open(URI.escape(url)))
	html = html.css("table#attributeTable").css("tr")
	price,address=""
	html.each do |child|
		if(child.css("td").children[0].to_s.include?"Price")
			price = (child.css("td").children[1].to_s).gsub("\\n","")
		end
		if(child.css("td").children[0].to_s.include?"Address")
			address = child.css("td").children[1].to_s
		end
	end
	print price.gsub("\\r\\n|\\[bnrt]|(\%0D\%0A)","").concat(" ** ").concat(address.gsub("\\r\\n|\\[bnrt]|(\%0D\%0A)","")).concat("\n")
end

if __FILE__ == $0
	#padmapper_json()
	kijiji_html()
end


