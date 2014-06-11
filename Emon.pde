class Emon {
  float [] readings ;
  String [] dspDates ;
  DateFormat formatter;
  
  Emon() {
    formatter = new SimpleDateFormat("E dd");
  }
  
  void getData(String url) {
    //Get EMONCMS data
    String lines[] = loadStrings(url + "&start=" + mydate(-7) + "&end=" + mydate(0));    
    //Strip out JSON format and convert into single array
    String entries [] = lines[0].replaceAll("[\\[\\]]", "").split(",");
    //Set up arrays for data
    readings = new float[entries.length/2];
    dspDates = new String[entries.length/2];
    int j=0;
    for (int i = 0; i < entries.length; i=i+2) {
      j=i/2;
      //time to string wd day
      long l = Long.parseLong(entries[i]);
      dspDates[j] = formatter.format(l);
      //Watts to KWh as float
      readings[j] = float(entries[i+1]) * 0.024 ;
     }  
  }
  
  String mydate(int offset) {
  //Get Unix Date offset from now  
  Date d = new Date();
  long timestamp = d.getTime();  
  int aDay = 86400000;
  //whole days => no time part
  timestamp = timestamp - (timestamp % aDay);
  //add offset
  timestamp = timestamp + (aDay * offset);
  return ""+timestamp; 
}
  
}
