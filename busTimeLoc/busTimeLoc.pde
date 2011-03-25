
// bus time

import processing.video.*;

MovieMaker mm;

XMLElement xml;

String busTimeUrl = "http://bustime.mta.info/api/siri/vehicle-monitoring.xml";
String busTimeKey = "7be28507-72fe-45ba-a312-d1e6d927b644";
String busTimeOperatorRef = "MTA%20NYCT";


color bgCol, dotCol;

String busTimeApiCall = "vehicle-monitoring.xml";

float  minX, maxX, minY, maxY ;

//set up the bus array

Bus[] buses;

void setup() {

  size(1000, 1000, P2D);
  hint(DISABLE_OPENGL_2X_SMOOTH);  

  colorMode(HSB, 100);
  background(0,0,0,100);

  noStroke();

  busTimeApiCall = busTimeUrl + "?key=" + busTimeKey + "&OperatorRef=" + busTimeOperatorRef + "&VehicleMonitoringDetailLevel=calls";
  
  Date d = new Date();
  long current = d.getTime()/1000; 

  String movieName = "b63_" + current + ".mov";
  
  print(movieName);
  
  mm = new MovieMaker(this, width, height, movieName,
  25, MovieMaker.RAW, MovieMaker.HIGH);
  
  loop();
}


void draw() {

  fill(0,0,0,5);
  rect(0,0,width,height);

  print("Accessing " + busTimeApiCall);
  xml = new XMLElement(this, busTimeApiCall);

  XMLElement[] allBuses = xml.getChildren("ServiceDelivery/VehicleMonitoringDelivery/VehicleActivity");
  
  print(xml);

  delay(7000);   

  buses = new Bus[allBuses.length];
  println("Got " + allBuses.length + " buses");

  float[] busX = new float[allBuses.length];
  float[] busY = new float[allBuses.length];
  String[] busId = new String[allBuses.length];


  for (int i = 0; i < allBuses.length ; i++) {

    XMLElement thisBusLongitude = allBuses[i].getChild("MonitoredVehicleJourney/VehicleLocation/Longitude");
    XMLElement thisBusLatitude = allBuses[i].getChild("MonitoredVehicleJourney/VehicleLocation/Latitude");
    XMLElement thisBusId = allBuses[i].getChild("MonitoredVehicleJourney/CourseOfJourneyRef");

    Float busLocLongitude = float(thisBusLongitude.getContent());
    Float busLocLatitude = float(thisBusLatitude.getContent());

    // buses[i] = new Bus(busLocLongitude, busLocLatitude, busId);

    busX[i] = busLocLongitude;
    busY[i] = busLocLatitude;

    println(thisBusId);

    if (thisBusId == null ) {  
      busId[i] = "Not a B63";
    } 
    else {
      busId[i] = thisBusId.getContent();
    }
  }

  // get the bounds


  minX = min(busX);
  maxX = max(busX);
  minY = min(busY);
  maxY = max(busY);

  minX = -74.04;
  maxX = -73.91;
  minY = 40.58;
  maxY = 40.70;


  // loop through all buses
  for (int i = 0; i < busX.length; i++) {
    fill(map(i,0,busX.length,0,100),50,90,100);
    ellipse(map(busX[i],minX,maxX,0,width), map(busY[i],maxY,minY,0,height),5,5);
  }

  println( minX + " " + maxX  + " " + minY  + " " + maxY);
   mm.addFrame(); 
}


void keyPressed() {
  if (key == ' ') {
    mm.finish();  // Finish the movie if space bar is pressed!
    println("Closed movie!");
  }
}

class Bus {
  float latitude;
  float longitude;
  String id;


  Bus(float bx, float by, String bid) {
    latitude = bx;
    longitude = by;
    id = bid;
  }
}

