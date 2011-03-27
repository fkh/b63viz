boolean busIsTracked = false;

boolean isFresh = false;

String latestTime = "";
String oldTime = "";

void fetchBusInfo() {

  println(millis() + " getting xml");

  // println("Accessing " + busTimeApiCall);

  xml = new XMLElement(this, busTimeApiCall);

  //check to see if the timestamp is different
  XMLElement timeCheck = xml.getChild("ServiceDelivery/StopMonitoringDelivery/MonitoredStopVisit/RecordedAtTime");



  if (latestTime.equals(oldTime)) {
      
    isFresh = false;
      
  } else {
   
   oldTime = latestTime;
   isFresh = true;
   
  }
   
  //get the buses
  XMLElement[] busXml = xml.getChildren("ServiceDelivery/StopMonitoringDelivery/MonitoredStopVisit");

  // for each bus we need to get the bus id, then extract the stop distance
  for (int i = 0; i < busXml.length ; i++) {


    // get the distance data
    XMLElement stopDistanceData = busXml[i].getChild("MonitoredVehicleJourney/MonitoredCall/Extensions/Distances/DistanceFromCall");
    XMLElement stopsAwayData = busXml[i].getChild("MonitoredVehicleJourney/MonitoredCall/Extensions/Distances/StopsFromCall");

    Float stopDistance = float(stopDistanceData.getContent());
    int stopsAway = int(stopsAwayData.getContent());

    // get the bus id
    XMLElement vehicleRefData = busXml[i].getChild("MonitoredVehicleJourney/VehicleRef");
    String vehicleRef = vehicleRefData.getContent();

    slices.add(new Slice(step, vehicleRef, stopDistance, isFresh, stopsAway));
  }

  
}

