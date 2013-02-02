(function(){

    google.load('jquery', '1.4.2');
    google.load('maps', '3', { other_params: "sensor=true&libraries=visualization" });
    google.setOnLoadCallback(function () {
        window.toronto       = new google.maps.LatLng(43.6481, -79.4042);
        window.currentCenter = toronto;
        window.markers       = [];
        window.map           = new google.maps.Map(document.getElementById('map'), {
            center:             toronto,
            zoom:               13,
            mapTypeId:          google.maps.MapTypeId.ROADMAP,
            disableDefaultUI:   true
        });

        $(document).ready(function () {
            getCompanies();
            $('#company').change(updateCompany);
            $('#distance').change(updateDistance);
        });
    });

    clearMarkers = function () {
        for (var i = markers.length - 1; i >= 0; i--) {
            markers[i].setMap(null);
        };
    };

    isCompanySet = function() {
        return parseInt($('#company').val()) != -1;
    };

    isDistanceSet = function() {
        return parseInt($('#distance').val()) != -1;
    };

    getCompanies = function() {
        $.ajax({
            url: '/map/search/all',
            success: function (company) {
                var container = $('#company');
                for (var i = company.length - 1; i >= 0; i--) {
                    var newOption = $('<option>');
                    newOption.attr({
                        "value":        company[i].id,
                        "data-lat":     company[i].lat,
                        "data-lng":     company[i].long
                    });
                    newOption.text(company[i].name)

                    container.append(newOption);
                };
            }
        });
    };

    updateCompany = function() {
        if (parseInt($('#company').val()) != -1)
        {
            // set center
            var selected = $('#company').find('option:selected');
            var lat      = parseFloat(selected.attr('data-lat'));
            var lng      = parseFloat(selected.attr('data-lng'));

            currentCenter = new google.maps.LatLng(lat, lng);   
        }
        else 
        {
            currentCenter = toronto;
        }
        
        updateDistance();
    };

    updateDistance = function() {
        var newZoom  = 13;
        var distance = parseInt($('#distance').val());

        if (distance <= 1)
        {
            newZoom = 15;
        }
        else if (distance > 1 && distance <= 3)
        {
            newZoom = 14;
        }
        else if (distance > 3 && distance <= 5)
        {
            newZoom = 13
        }
        else if (distance > 5 && distance <= 10)
        {
            newZoom = 12;
        }
        else 
        {
            newZoom = 11;
        }

        map.setCenter(currentCenter);
        map.setZoom(newZoom);
        updateOutput();
    };

    updateOutput = function() {
        clearMarkers();

        if (isCompanySet() && isDistanceSet())
        {
            var distance    = parseInt($('#distance').val()); // user specified radius in kilometers
            var companyName = $('#company option:selected').text();

            // circle
            var radius      = distance * 1000; // maps API require circle radius in meters
            var companyArea = new google.maps.Circle({
                center:         currentCenter,
                clickable:      false,
                fillColor:      '#333',
                fillOpacity:    0.1,
                map:            map,
                strokeColor:    '#333',
                strokeOpacity:  0.4,
                strokeWeight:   1,
                radius:         radius
            });

            // center point
            var companyPosition = new google.maps.Marker({
                clickable:      false,
                map:            map,
                position:       currentCenter
            });

            $.ajax({
                url:            '/map/search',
                data: {
                    company:    parseInt($('#company').val()),
                    distance:   distance
                },
                success: function(data) {
                    console.log(data);

                    // living cost
                    var costAverage = data.avg;
                    var costOutput = $('<li class="cost">');
                    costOutput.append('<span>Average cost of living ' + distance + ' km from ' + companyName + ' is </span>')
                    costOutput.append('<strong>$' + costAverage.toFixed(2) + '</strong>');
                    $('#app ul').find('.cost').remove();
                    $('#app ul').append(costOutput);

                    // heatmap
                    var heatMapData = [];
                    var houses = data.houses;
                    for (var i = houses.length - 1; i >= 0; i--) {
                        heatMapData.push({
                            location:   new google.maps.LatLng(parseFloat(houses[i].lat), parseFloat(houses[i].long)),
                            weight:     houses[i].price / costAverage
                        });
                    };

                    var heatmap = new google.maps.visualization.HeatmapLayer({
                        data:       heatMapData,
                        map:        map,
                        radius:     40 / distance
                    });
                    markers.push(heatmap);
                },
                error: function(xhr, textStatus, errorThrown) {
                    alert(textStatus);
                }
            });

            markers.push(companyArea);
            markers.push(companyPosition);
        }
    };

})();
