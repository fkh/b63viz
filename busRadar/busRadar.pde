
// bus radar

XMLElement xml;

String busTimeUrl = "http://bustime.mta.info/api/siri/stop-monitoring.xml";
String busTimeKey = "7be28507-72fe-45ba-a312-d1e6d927b644";
String busTimeOperatorRef = "MTA%20NYCT";
String busTimeMonitoringRef = "308214";

String busTimeApiCall = "stop-monitoring.xml";

long current;

long tickerDelay = 10000; //fetch the xml every 10 secs
long busTicker; //tracks when to fetch the xml

//store the bus distances
ArrayList busLocations;

void setup() {

  size(700, 700, P2D);
  hint(DISABLE_OPENGL_2X_SMOOTH);  

  colorMode(HSB, 100);
  background(0,0,0,100);

  noStroke();

   busTimeApiCall = busTimeUrl + "?key=" + busTimeKey + "&MonitoringRef=" + busTimeMonitoringRef + "&OperatorRef=" + busTimeOperatorRef;

  //get a timestamp 
  Date d = new Date();
  current = d.getTime()/1000; 

  //set up the location array
  busLocations = new ArrayList();
  busLocations.add(100.1);
}


void draw() {
  
   //clean up
   fill(0);
   rect(0,0,width,height);

  if (busTicker + tickerDelay < millis()) { 
    fetchBusInfo();
    busTicker = millis(); 
  }
  
 // println(busLocations.size());
  
  for (int i = 0; i < busLocations.size(); i++) {

    Float location = (Float) busLocations.get(i);
    rect(width/2, norm(location, 0, 12000) * height/2, 3, 3);
  }

  noFill();
  stroke(10,20,10);

  ellipse(width/2,height/2, 10,10);
  ellipse(width/2,height/2, width-50,height-50);

  loop();
}



