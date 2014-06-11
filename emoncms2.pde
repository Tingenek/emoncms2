import org.gicentre.utils.stat.*;        // Chart stuff.
import java.util.Date;                   // Date stuff.
import java.text.DateFormat;
import java.text.SimpleDateFormat;

String avgurl = "http://emoncms.org/feed/average.json?&apikey=7f1b46367a013db07d2d65e588d2ad93&id=43348&interval=86400";
String pwrurl = "http://emoncms.org/feed/value.json?&apikey=7f1b46367a013db07d2d65e588d2ad93&id=43348";

PFont baseFont;
color cBackground = #222222;
color cTitle = #aaaaaa;
color cChart = #0699fa;
color cReadings = #ffffff; 

BarChart barChart;
Emon emon;
Elapsed timer;
float currentReading;
String tLatest;

void setup(){
size(displayWidth, displayHeight);
// size(480,700); 
// use instead if you're using it on the desktop
  smooth();
  //Lock to portrait
  orientation(PORTRAIT);
  //This font is in /data so it gets sent to Android
  baseFont = createFont("Roboto-Regular.ttf", 16, true);
  textFont(baseFont);
  
  //Set up barchart
  barChart = new BarChart(this);
  barChart.setBarColour(cChart); 
  barChart.showValueAxis(false); 
  barChart.showCategoryAxis(true); 
  barChart.setMinValue(0);
  // barChart.showValueAxis(true);
  //  barChart.transposeAxes(true);
  
  //Timer
  timer= new Elapsed(60);
  
  //Our utility class
  emon = new Emon(); 
  
  //Start point
  updateGraph();
  updateLatest();
}

void draw()
{
  //Update current power
  if (timer.checktime()) {
     updateLatest();
  }
  background(cBackground);
  //Title
  textSize(36);
  fill(cTitle);
  text("POWER @" + tLatest + ":",20,70);
  //Power
  textSize(100);
  fill(cChart);
  if (currentReading > 1000) {
    text(String.format("%.1fKw", currentReading/1000),20,170);
  } else {
    text(String.format("%.1fW", currentReading),20,170);
  }  
  //Chart
  textSize(16);
  barChart.draw(width*0.04,height*.35,width*0.95,height*0.6);
   //Add labels in bars
  fill(cReadings);   
  textSize(24);
  addLabels();
}

//Get data for graph
void updateGraph() {
  emon.getData(avgurl);
  barChart.setData(emon.readings);
  barChart.setBarLabels(emon.dspDates);   
}

//Get latest power
void updateLatest() {
    String lines[] = loadStrings(pwrurl);    
    currentReading =  Float.parseFloat(split(lines[0], '"')[1]);
    tLatest = nf(hour(),2) + ":" +nf( minute(),2);
}

void addLabels() {
  //Add integere values at the top of thre bars
  PVector j;
  float r;
  String s ;
  //Get readings
  for (int i = 0; i < emon.readings.length; i++) {
    r=emon.readings[i];
    //Find middle of bar[n] at 90% up
    j = barChart.getDataToScreen(new PVector(i,r * 0.9));
    //Write out int value
    s=str(int(r));
    text(s,j.x - textWidth(s)/2,j.y);
  }
}



