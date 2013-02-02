#!/usr/bin/ruby

#
# Author: almartin <alex.m.martineau@gmail.com>
# Version: 1.0
# Date: 03/14/2011
# Language: Ruby
# Descrption: Example script implementing Haversine formula to identify distance in KM between 2 coordinates
# Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
#
module Haversine

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
