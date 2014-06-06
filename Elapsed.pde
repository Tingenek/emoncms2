class Elapsed {
//Timer utility class
  
  
int time;
int wait = 60000; 

Elapsed(int w) {
    //store the current time
    wait = w * 1000;
    time = millis(); 
}
  
boolean checktime() {
  //Check is time is up. If so get new colour
  boolean result = false;
  if (millis() - time >= wait) {
    result=true;
    time = millis();
  }
  return result;
}
}
