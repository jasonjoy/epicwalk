var directionsDisplay;
var directionsService = new google.maps.DirectionsService();
var map;
var myStartAddr = '<%= @journey.start_addr %>';
var myDestAddr = '<%= @journey.dest_addr %>';
var myCurrentLatLng = null;

function initialize() {
  directionsDisplay = new google.maps.DirectionsRenderer();
  var startMap = new google.maps.LatLng(41.8337329,-87.7321555);
  var mapOptions = {
    zoom: 7,
    center: startMap
  };
  map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
  directionsDisplay.setMap(map);
}

function getDistanceFromLatLng(lat1,lon1,lat2,lon2) {
  var R = 6371; // Radius of the earth in km
  var dLat = deg2rad(lat2-lat1);  // deg2rad below
  var dLon = deg2rad(lon2-lon1); 
  var a = 
    Math.sin(dLat/2) * Math.sin(dLat/2) +
    Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * 
    Math.sin(dLon/2) * Math.sin(dLon/2)
    ; 
  var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
  var d = R * c; // Distance in km
  return d * 1000; // Convert km to meters in return value
}

function deg2rad(deg) {
  return deg * (Math.PI/180)
}

function calcRoute() {
  var request = {
    origin: myStartAddr,
    destination: myDestAddr,
    /* Commented out waypoints until we have calculation of current_addr working
    waypoints: [
      {
        location: myCurrentAddr,
        stopover: true
      }],
    optimizeWaypoints: true,
    */
    travelMode: google.maps.TravelMode.WALKING,
    unitSystem: google.maps.UnitSystem.IMPERIAL
  };
  
  directionsService.route(request, function(response, status) {
    if (status == google.maps.DirectionsStatus.OK) {
      console.log("This is a valid walking route");
      //console.log(google.maps.DirectionsStatus);
      console.log("\nHere is the whole routes object:");
      console.log(response);
      
      // Grab the total distance from directionsService output, then load it into the journeys database 
      var distanceInMeters = response.routes[0].legs[0].distance.value;
      console.log("\nHere is the calculate route distance in meters");
      console.log(distanceInMeters);

      var totalFitbitMetersWalked = <%= @journey.dist_so_far %>;
      console.log("\nHere is how far you've walked in meters");          
      console.log(totalFitbitMetersWalked);

      // Add the distance of each step in the directions. Stop on the first step where total distance would exceed totalFitbitMetersWalked
      // Note: This assume entire journey is one leg. If multiple legs, we need to iterate through legs before iterating through steps
      var steps = response.routes[0].legs[0].steps;
      console.log(steps);
      var totalDistance = 0;
      var currentNode = null;
      $.each(steps, function( index, value ) {
        if ((totalDistance + value.distance.value) < totalFitbitMetersWalked) {
          totalDistance = totalDistance + value.distance.value;
          currentNode = value;
        }
        else {
          return false;
        }
      });
      console.log(currentNode);
      var paths = currentNode.lat_lngs;
      console.log(paths);
      
      // Starting from the step closest to totalFitbitMetersWalked, add the distance between each latitude-longitude pair on the path.
      // Calculate the distance between lat-long pairs using the getDistanceFromLatLonInMeters() function.
      var prevLocation = null;
      $.each(paths, function( index, value ) {
        if (prevLocation == null) {
          prevLocation = value;
        }
        else {
          var thisLocationLat = value.k;
          var thisLocationLng = value.D;
          var prevLocationLat = prevLocation.k;
          var prevLocationLng = prevLocation.D;
          var distanceBtwnPoints = getDistanceFromLatLng(thisLocationLat, thisLocationLng, prevLocationLat, prevLocationLng);
          myCurrentLatLng = [prevLocationLat, prevLocationLng];
          if ((totalDistance + distanceBtwnPoints) < totalFitbitMetersWalked) {
            totalDistance = totalDistance + distanceBtwnPoints;
            prevLocation = value;
          }
          else {
            return false;
          }
        }
      });
      console.log("\nprevLocation");
      console.log(prevLocation);

      console.log("\nmyCurrentLatLng");
      console.log(myCurrentLatLng);
      
      // Should put a marker at the current location, but it's not working now
      var marker = new google.maps.Marker({
        postion: (41.20064, -73.11271), //Static coordinates are just for testing
        //postion: (myCurrentLatLng),
        map: map
      });
      marker.setMap(map);

      directionsDisplay.setDirections(response);
      // Save the calculated distanceInMeters to the @journey record
      $.ajax({
          url: '/journeys/<%= @journey.id%>.json',
          type: 'PUT',
          data: {journey: {total_distance_in_meters: distanceInMeters}},
          success: function(result) {
              // Do something with the result
          }
      });
    }
    else {
      // Expand this to do route validation during create/edit actions
      console.log("You can't walk this route!!");
    }
  });
}

//google.maps.event.addDomListener(window, 'load', initialize);
$(function() {
  initialize();
  calcRoute();
});

