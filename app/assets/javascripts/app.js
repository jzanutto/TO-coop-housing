$(document).ready(function () {
   
    var toronto = new google.maps.LatLng(43.6481, -79.4042);
    var map     = new google.maps.Map(document.getElementById('map'), {
        center:             toronto,
        zoom:               13,
        mapTypeId:          google.maps.MapTypeId.ROADMAP,
        disableDefaultUI:   true
    });

});