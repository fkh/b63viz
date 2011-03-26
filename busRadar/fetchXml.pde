void fetchBusInfo() {
  
  println(millis() + " getting xml");

 // println("Accessing " + busTimeApiCall);
  
  xml = new XMLElement(this, busTimeApiCall);

  //check to see if the timestamp is different
  
  //get the buses
  XMLElement[] buses = xml.getChildren("ServiceDelivery/StopMonitoringDelivery/MonitoredStopVisit");

  // for each bus we need to extract the stop distance
  for (int i = 0; i < buses.length ; i++) {
    XMLElement stopDistanceData = buses[i].getChild("MonitoredVehicleJourney/MonitoredCall/Extensions/Distances/DistanceFromCall");
    XMLElement stopsAwayData = buses[i].getChild("MonitoredVehicleJourney/MonitoredCall/Extensions/Distances/StopsFromCall");

    Float stopDistance = float(stopDistanceData.getContent());
    Float stopsAway = float(stopsAwayData.getContent());

    println(stopDistance);

    busLocations.add(stopDistance);
  }

  //print(xml);

  
}
