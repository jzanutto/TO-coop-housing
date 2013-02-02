(function(){google.load("jquery","1.4.2"),google.load("maps","3",{other_params:"sensor=true&libraries=visualization"}),google.setOnLoadCallback(function(){window.toronto=new google.maps.LatLng(43.6481,-79.4042),window.currentCenter=toronto,window.markers=[],window.map=new google.maps.Map(document.getElementById("map"),{center:toronto,zoom:13,mapTypeId:google.maps.MapTypeId.ROADMAP,disableDefaultUI:!0}),$(document).ready(function(){getCompanies(),$("#company").change(updateCompany),$("#distance").change(updateDistance)})}),clearMarkers=function(){for(var e=markers.length-1;e>=0;e--)markers[e].setMap(null)},isCompanySet=function(){return parseInt($("#company").val())!=-1},isDistanceSet=function(){return parseInt($("#distance").val())!=-1},getCompanies=function(){$.ajax({url:"/map/search/all",success:function(e){var t=$("#company");for(var n=e.length-1;n>=0;n--){var r=$("<option>");r.attr({value:e[n].id,"data-addr":e[n].location,"data-lat":e[n].lat,"data-lng":e[n].long}),r.text(e[n].name),t.append(r)}},error:function(e,t,n){alert(t)}})},updateCompany=function(){if(parseInt($("#company").val())!=-1){var e=$("#company").find("option:selected"),t=parseFloat(e.attr("data-lat")),n=parseFloat(e.attr("data-lng"));currentCenter=new google.maps.LatLng(t,n)}else currentCenter=toronto;updateDistance()},updateDistance=function(){var e=13,t=parseInt($("#distance").val());t<=1?e=15:t>1&&t<=3?e=14:t>3&&t<=5?e=13:t>5&&t<=10?e=12:e=11,map.setCenter(currentCenter),map.setZoom(e),updateMarkers()},updateMarkers=function(){clearMarkers();if(isCompanySet()&&isDistanceSet()){var e=parseInt($("#distance").val()),t=e*1e3,n=new google.maps.Circle({center:currentCenter,clickable:!1,fillColor:"#333",fillOpacity:.1,map:map,strokeColor:"#333",strokeOpacity:.4,strokeWeight:1,radius:t}),r=$("#company option:selected").text(),i=$("#company option:selected").attr("data-addr"),s=new google.maps.Marker({map:map,position:currentCenter,title:r}),o=new google.maps.InfoWindow({content:'<strong style="display:block">'+r+'</strong><span style="display:block">'+i+"</span>"});google.maps.event.addListener(s,"click",function(){o.open(map,s)}),$.ajax({url:"/map/search",data:{company:parseInt($("#company").val()),distance:e},success:function(t){var n=t.avg,i=$('<li class="cost">');i.append("The average monthly rent of living <span>"+e+" km</span> from <span>"+r+"</span> is:"),i.append("<strong>$"+n.toFixed(2)+"</strong>"),$("#app ul").find(".cost").remove(),$("#app ul").append(i);var s=[],o=t.houses;for(var u=o.length-1;u>=0;u--)s.push({location:new google.maps.LatLng(parseFloat(o[u].lat),parseFloat(o[u].long)),weight:o[u].price/n});var a=new google.maps.visualization.HeatmapLayer({data:s,map:map,radius:Math.max(40/e,15)});markers.push(a)},error:function(e,t,n){alert(t)}}),markers.push(n),markers.push(s)}}})(),function(){google.load("jquery","1.4.2"),google.load("maps","3",{other_params:"sensor=true&libraries=visualization"}),google.setOnLoadCallback(function(){window.toronto=new google.maps.LatLng(43.6481,-79.4042),window.currentCenter=toronto,window.markers=[],window.map=new google.maps.Map(document.getElementById("map"),{center:toronto,zoom:13,mapTypeId:google.maps.MapTypeId.ROADMAP,disableDefaultUI:!0}),$(document).ready(function(){getCompanies(),$("#company").change(updateCompany),$("#distance").change(updateDistance)})}),clearMarkers=function(){for(var e=markers.length-1;e>=0;e--)markers[e].setMap(null)},isCompanySet=function(){return parseInt($("#company").val())!=-1},isDistanceSet=function(){return parseInt($("#distance").val())!=-1},getCompanies=function(){$.ajax({url:"/map/search/all",success:function(e){var t=$("#company");for(var n=e.length-1;n>=0;n--){var r=$("<option>");r.attr({value:e[n].id,"data-addr":e[n].location,"data-lat":e[n].lat,"data-lng":e[n].long}),r.text(e[n].name),t.append(r)}},error:function(e,t,n){alert(t)}})},updateCompany=function(){if(parseInt($("#company").val())!=-1){var e=$("#company").find("option:selected"),t=parseFloat(e.attr("data-lat")),n=parseFloat(e.attr("data-lng"));currentCenter=new google.maps.LatLng(t,n)}else currentCenter=toronto;updateDistance()},updateDistance=function(){var e=13,t=parseInt($("#distance").val());t<=1?e=15:t>1&&t<=3?e=14:t>3&&t<=5?e=13:t>5&&t<=10?e=12:e=11,map.setCenter(currentCenter),map.setZoom(e),updateMarkers()},updateMarkers=function(){clearMarkers();if(isCompanySet()&&isDistanceSet()){var e=parseInt($("#distance").val()),t=e*1e3,n=new google.maps.Circle({center:currentCenter,clickable:!1,fillColor:"#333",fillOpacity:.1,map:map,strokeColor:"#333",strokeOpacity:.4,strokeWeight:1,radius:t}),r=$("#company option:selected").text(),i=$("#company option:selected").attr("data-addr"),s=new google.maps.Marker({map:map,position:currentCenter,title:r}),o=new google.maps.InfoWindow({content:'<strong style="display:block">'+r+'</strong><span style="display:block">'+i+"</span>"});google.maps.event.addListener(s,"click",function(){o.open(map,s)}),$.ajax({url:"/map/search",data:{company:parseInt($("#company").val()),distance:e},success:function(t){var n=t.avg,i=$('<li class="cost">');i.append("The average monthly rent of living <span>"+e+" km</span> from <span>"+r+"</span> is:"),i.append("<strong>$"+n.toFixed(2)+"</strong>"),$("#app ul").find(".cost").remove(),$("#app ul").append(i);var s=[],o=t.houses;for(var u=o.length-1;u>=0;u--)s.push({location:new google.maps.LatLng(parseFloat(o[u].lat),parseFloat(o[u].long)),weight:o[u].price/n});var a=new google.maps.visualization.HeatmapLayer({data:s,map:map,radius:Math.max(40/e,15)});markers.push(a)},error:function(e,t,n){alert(t)}}),markers.push(n),markers.push(s)}}}();