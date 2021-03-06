
// bus time

//import processing.video.*;

//MovieMaker mm;

XMLElement xml;

String busTimeUrl = "http://bustime.mta.info/api/siri/vehicle-monitoring.xml";
String busTimeKey = "7be28507-72fe-45ba-a312-d1e6d927b644";
String busTimeOperatorRef = "MTA%20NYCT";

color bgCol, dotCol;

String busTimeApiCall = "vehicle-monitoring.xml";

//float  minX, maxX, minY, maxY ;

// get the bounds
float minX = -74.04;
float  maxX = -73.91;
float minY = 40.58;
float  maxY = 40.70;

boolean firstRun = true;

long current;


//set up the bus array

Bus[] buses = new Bus[100];


void setup() {

  size(1200, 1200, P2D);
  hint(DISABLE_OPENGL_2X_SMOOTH);  

  colorMode(HSB, 100);
  background(0,0,0,100);

  noStroke();

  busTimeApiCall = busTimeUrl + "?key=" + busTimeKey + "&OperatorRef=" + busTimeOperatorRef + "&VehicleMonitoringDetailLevel=calls";

  //get a timestamp for these pics
  Date d = new Date();
  current = d.getTime()/1000; 
  
  
  // font to write the date/time onto the pic
  PFont font;
  font = loadFont("Monospaced-48.vlw"); 
  textFont(font); 

  loop();
}

void draw() {

  // refresh the background with a transparent black box
  fill(0,0,0,3);
  rect(0,0,width,height);
  
  // prep the timestamp
  fill(0);
  rect(30,20,150,50);
  fill(100);
  String mins;
  if (minute() < 10) {
    mins = "0" + minute();
  } else {
    mins = minute() + "";  
  }
  
  // write the timestamp
  String timerecord = hour() + ":" + mins;
  text(timerecord, 30, 60);

  print("Accessing " + busTimeApiCall);
  
  xml = new XMLElement(this, busTimeApiCall);

  XMLElement[] allBuses = xml.getChildren("ServiceDelivery/VehicleMonitoringDelivery/VehicleActivity");


  //print(xml);

  // poll every minute
  delay(60000);   

  //println("Got " + allBuses.length + " buses");

  for (int i = 0; i < allBuses.length ; i++) {

    XMLElement thisBusLongitude = allBuses[i].getChild("MonitoredVehicleJourney/VehicleLocation/Longitude");
    XMLElement thisBusLatitude = allBuses[i].getChild("MonitoredVehicleJourney/VehicleLocation/Latitude");
    XMLElement thisBusId = allBuses[i].getChild("MonitoredVehicleJourney/CourseOfJourneyRef");

    Float busLocLongitude = float(thisBusLongitude.getContent());
    Float busLocLatitude = float(thisBusLatitude.getContent());

    String busIdOutput;

    if (thisBusId == null ) {  
      busIdOutput = "Not a B63";
    } 
    else {
      busIdOutput = thisBusId.getContent();
    }

    if (firstRun) {   

      buses[i] = new Bus(busLocLatitude, busLocLongitude, busIdOutput); 
      buses[i].drawBus();
    } 
    else {

      buses[i].update(busLocLatitude, busLocLongitude);
    }
  }

  firstRun = false;

  saveFrame(current + "-####.png"); 
}

class Bus {
  float latitude;
  float longitude;
  float oldLatitude;
  float oldLongitude;
  float busX;
  float busY;
  float oldBusX;
  float oldBusY;
  String id;
  color busColor;

  Bus(float bx, float by, String bid) {
    latitude = bx;
    longitude = by;
    oldLatitude = bx;
    oldLongitude = by;
    id = bid;
    busColor = color(int(random(0,100)),50,90,100);
  }

  void drawBus() {

    stroke(50,50,50,50);
    noStroke();
    fill(busColor);
    ellipse(map(latitude,minX,maxX,0,width), map(longitude,maxY,minY,0,height),5,5);
  }

  void update(float newLat, float newLon) {

    float busX = map(newLon, minX, maxX, 0, width);
    float busY = map(newLat,maxY,minY,0, height);

    stroke(busColor);

    fill(busColor);
    if (oldBusX > 0) {
      line(oldBusX,oldBusY,busX,busY);
    }

    noStroke();
    ellipse(busX, busY, 5, 5);

    oldBusX = busX;
    oldBusY = busY;
    latitude = newLat;
    longitude = newLon;
  }
}

