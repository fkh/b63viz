
// bus radar
// by fkh


// xml bustime call details
XMLElement xml;

String busTimeUrl = "http://bustime.mta.info/api/siri/stop-monitoring.xml";
String busTimeKey = "7be28507-72fe-45ba-a312-d1e6d927b644";
String busTimeOperatorRef = "MTA%20NYCT";
String busTimeMonitoringRef = "308214";

String busTimeApiCall = "stop-monitoring.xml";

// radar graphics stuff
RadarGUI radar;
Sweep sweepArm;


//font stuff
PFont basicFont;

// keeping track of time
long current;
int tickerDelay = 10000; //fetch the xml this often
long busTicker; //tracks when to fetch the xml
int step = 0;
int pulse;

//store the bus distances
ArrayList slices;

//rotations
// complete circle in 20 mins... 360 degrees / (20 mins * 60 secs / 10 second step)
int rotationSteps = (30 * 60 / (tickerDelay / 1000));
int rotationIncrement = 360/rotationSteps;

//how far are we going to look?
int myopicDistance = 3000;

// how long is our radar sweep?
int radarSweepLength;

void setup() {

  size(700, 700);
  // hint(DISABLE_OPENGL_2X_SMOOTH);  

  colorMode(HSB, 100);
  background(0,0,0,100);

  noStroke();

  busTimeApiCall = busTimeUrl + "?key=" + busTimeKey + "&MonitoringRef=" + busTimeMonitoringRef + "&OperatorRef=" + busTimeOperatorRef;

  //get a timestamp 
  Date d = new Date();
  current = d.getTime()/1000; 

  //set up the bus list
  slices = new ArrayList();
  //  slices.add(new Slice(0, "foo", 0.1));

  //font stuff
  basicFont = loadFont("Monospaced-12.vlw");
  textFont(basicFont);
  //  textMode(SCREEN);

  // drawing stuff
  rectMode(CENTER);
  smooth();

  // graphical
  radarSweepLength = (height/2) - 40;
  radar = new RadarGUI(500);
  sweepArm = new Sweep();
}


void draw() {

  //clean up
  noStroke();
  fill(0);
  rect(0,0,width*2,height*2);

  //draw the UI
  radar.drawGUI();

  if (busTicker + tickerDelay < millis()) { 
    step++;
    fetchBusInfo();
    busTicker = millis(); 

    // report the tracked buses
    for (int j = 0; j < slices.size(); j++) {

      Slice currentSlice = (Slice) slices.get(j);
      if (currentSlice.slice() == step) {
        println(currentSlice.busInfo() + " ");
      }
    }
    println(" -- ");
  }

  pushMatrix();

  translate(width/2, height/2);

  boolean showLabel = false;

  // for each step
  for (int k = 0; k <= step; k++) {

    pushMatrix();

    Float rotateDegrees = float(rotationIncrement * (step - k) * -1);

    rotate(radians(rotateDegrees));

    if (k == 0) { // draw the time line

      sweepArm.drawSweep();
    }

    // draw the bus locations 
    for (int j = 0; j < slices.size(); j++) {

      Slice currentSlice = (Slice) slices.get(j);

      if (currentSlice.slice() == k) {

        if (k == step) {
          showLabel = true;
        } 
        else {
          showLabel = false;
        }

        currentSlice.drawBus(showLabel);
      }
    }

    popMatrix();
  }

  popMatrix();

  loop();

  //saveFrame(current + ".png");
}

