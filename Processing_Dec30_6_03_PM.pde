import processing.serial.*; // add the serial library
Serial myPort; // define a serial port object to monitor

//References: The Processing forum page for assistance with how to get the best looking heart shape in processing

// Define initial "time" coordinates of cursor location 
float x = 0;
int flip; //this value will flip on when a human is detected and will reset the screen
int data1; //variable to store the first value of the pair of data points used to connect the lines of the graph
int data2; //variable to store the second value of the pair of data points used to connect the lines of the graph
int i;

void setup() {
  size(1200, 612); // set the window size
  println(Serial.list()); // list all available serial ports
  myPort = new Serial(this, Serial.list()[4], 38400); // define input port
  myPort.clear(); // clear the port of any initial junk
  background(0, 0, 0); // pick the fill color (r,g,b). Feel free to change this.
  
  flip = 0; //start off as no human detected
  i = 1; //initialize i to be 1
}

void draw () {
  
  //draw the horizontal axes lines
   stroke(0, 110, 0);
   line(0, 40, 1200, 40); //create the axes here
   line(0, 142, 1200, 142);
   line(0, 244, 1200, 244);
   line(0, 346, 900, 346);
   line(0, 346, 1200, 346);
   stroke(0, 0, 190);
   line(900, 448, 1200, 448);
   stroke(0, 110, 0);
   line(0, 448, 900, 448);
   line(0, 550, 900, 550);
   
   //draw the vertical axes lines
   stroke(0, 110, 0);
   line(100, 0, 100, 612);
   line(200, 0, 200, 612);
   line(300, 0, 300, 612);
   line(400, 0, 400, 612);
   line(500, 0, 500, 612);
   line(600, 0, 600, 612);
   line(700, 0, 700, 612);
   line(800, 0, 800, 612);
   line(900, 0, 900, 448);
   line(1000, 0, 1000, 448);
   line(1100, 0, 1100, 448);
   stroke(0, 0, 190);
   line(900, 448, 900, 612);

   textSize(15);
   fill(200, 200, 200);
   text("bpm", 910, 470);
   fill(200, 200, 200);

  
while (myPort.available () > 0) { // make sure port is open
  String inString = myPort.readStringUntil('\n'); // read input string
  
if (inString != null) { // ignore null strings
inString = trim(inString); // trim off any whitespace
String[] xyzaRaw = splitTokens(inString, "\t"); // extract x & y into an array
// proceed only if correct # of values extracted from the string:

if (xyzaRaw.length == 3) {
  
  int a0 = int(xyzaRaw[0]); //initialize an array //this is the sensor data
  int a1 = int(xyzaRaw[1]); //initialize an array  //this is the binary detection data
  int a2 = int(xyzaRaw[2]); //initialize an array //this is the bpm data

  
  a0 = int((float)a0*(512.0/1024.0)*1.5); // note the type conversions
  
  if (i == 1){
    data1 = a0; //mark the first value out of the two value pair that will make up one line segment
  }
  else if (i == 2){
    data2 = a0; //mark the second value out of the two value pair that will make up one line segment
  }
  
  fill(0, 255, 0);  //Print the two value pair line segment
  stroke(0, 255, 0);
  line(x, 550-data1+140, x+0.2, 550-data2+140);
  
  
  if (a1 == 0){ //meaning there is no one detected
  
   flip = 0; //meaning that a transition has taken place
   fill(0, 0, 0); 
   stroke(0, 0, 0);
   rect (980, 470, 280, 116);
   fill(0, 0, 0); 
   
   textSize(100);
   fill(250, 250, 250);
   text("CALIBRATING...", 200, 300); //User feedback message
   fill(250, 250, 250);
   
   textSize(60);
   fill(250, 250, 250);
   text("(searching for human)", 250, 400); //User feedback message
   fill(250, 250, 250);
   
   textSize(60);
   fill(250, 250, 250);
   text("N/A", 1000, 540); 
   fill(250, 250, 250);
   }
   
   if (flip == 0 && a1 == 1){
     flip = 1; //Meaning that a transition has taken place
     background(0, 0, 0); //Clear the screen 
     break; //start back up at the top of the draw() loop
   }
   
   if (a1 == 1){
   fill(0, 0, 0); 
   stroke(0, 0, 0);
   rect (980, 470, 280, 116);
   fill(0, 0, 0); 
   textSize(60);
   fill(250, 250, 250);
   text(a2, 1000, 540);
   fill(250, 250, 250);
   
   }
  
  //Alternate between i = 1 and i = 2 to keep reassigning the data to use in our line segments
  if (i == 2){
    i = 1; 
  }
  else if (i == 1){
    i = 2;
  }
  
  x = x + 0.3; //this is our delta x, basically our graphical axes step
  
  // Set the bounds inside with the cursor can translate
  // This prevents the cursor from moving off the screen
  if(x > 1200){
    background(0, 0, 0); // pick the fill color (r,g,b). Feel free to change this.
    x = 0;
  }
  
}
}
}
}
