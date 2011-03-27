int labelShow;
long labelPulse;
String dotLabel;

class Slice {
  int sliceId;
  String busId;
  float busDistance;
  boolean isFresh;
  int stopsAway;

  Slice(int sid, String bid, float bdis, boolean iF, int sA) {
    sliceId = sid;
    busId = bid;
    busDistance = bdis;
    isFresh = iF;
    stopsAway = sA;
  }

  void drawBus(boolean drawLabel) {
    pushMatrix();

    translate(0, -1 * radarSweepLength);

    int dotSize = 4;

    if (isFresh) {
      dotSize = 8;
    }

    float distanceToDraw;

    if (busDistance > myopicDistance) { // the bus is really far away, so we'll draw it on the edge of the chart

      distanceToDraw = norm(myopicDistance,float(0),float(myopicDistance)) * radarSweepLength;
    } 
    else { 

      distanceToDraw = norm(busDistance,float(0),float(myopicDistance)) * radarSweepLength;
    }

    if (stopsAway > 10) {
      stroke(50);
      noFill();
    } 
    else {
      noStroke();
      fill(30,10 * (9 - stopsAway),70);
    }
    ellipse(0,distanceToDraw,dotSize,dotSize);

    fill(30,90,50);

    if (drawLabel) {
      if (labelPulse < millis()) {
       labelShow++;
       if (labelShow > 2) {
         labelShow = 0; 
       }
      
      switch (labelShow) {
      case 0:
        dotLabel = busId;
        break;
      case 1:
        dotLabel = stopsAway + " stops away";
        break;
      case 2:
      dotLabel = int(busDistance) + " meters away";
        break;
      }
           
     labelPulse = millis() + 2500;
     
    }
      text(dotLabel, 10, distanceToDraw + 5);
    }

    popMatrix();
  }

  public int slice() {
    return sliceId;
  }

  public String busInfo() {
    return "bus: " + busId + ", distance: " + int(busDistance) + ", stops: " + stopsAway + " slice: " + sliceId;
  }
}

