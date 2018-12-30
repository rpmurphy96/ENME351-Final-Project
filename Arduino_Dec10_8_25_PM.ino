#include <Servo.h>

//Citation: some material relating to writing the servo position was taken from the "Servo Sweep" script supplied by Arduino in their “Examples” library

Servo myservo;  // creating servo object to control a servo

int pos = 0;    // declare a variable to store the servo's position
int numbeats; //varible to count how many times the heart has beat
int bpm; //variable to hold the beats per minute of the heart
int threshold = 500;
int detection; //detects if there is a finger on the sensor, the value is 0 if there is not, and 1 is there is
int beatPeriod = 500; // (in milliseconds) presumably there is no human with a bpm lower than 30 so setting the beat Period to around 0.5 seconds seems sufficent
int timebetweenbeats;
int sensor;
int state; //binary variable to hold a state
int bpmArray[4];
long sum = 0;
int i;
int bpmAvg;
int pointer;



void setup() {
  Serial.begin(38400); //change to 38400
  myservo.attach(9);  // attaches the servo on pin 9 to the servo object
  pinMode(A0, INPUT);
  millis();
  numbeats = 0; //reset all statistics
  bpm = 0;
  detection = 0;
  pointer = 0;
}



void loop() {
  long tlastbeat; 

  sensor = analogRead(A0);
   
  myservo.write(map(sensor, 0, 1023, 155, 45)); //Write the servo to the angle that corresponds to the sensor value 
    
  if ((sensor > threshold) && (millis()-tlastbeat > beatPeriod)){
    if (detection == 1){
        timebetweenbeats = millis() - tlastbeat;
    }
    tlastbeat = millis();
    numbeats++; 
  }
  if (numbeats <= 15 || (millis() - tlastbeat) > 10000){
    detection = 0;
    state = 0;
  }
  else if (numbeats >=15 && state == 0){
    detection = 1;
  }
  if (state = 1 && (millis() - tlastbeat) > 10000){
    state = 0;
    numbeats = 0;
  }
  if (detection == 1){
   bpm = (((float) 1 / timebetweenbeats)  * 1000 * 60); //Calculating the bpm using the time elapsed between beats
   bpmAvg = MovingAverage(bpm); //Compute the moving average of our bpm array for a more accurate value for the user
  }
  
  //Now send all the data collected during this loop to processing
  Serial.print(sensor);   //Send the sensor data to processing
  Serial.print("\t");
  Serial.print(detection); //Send the binary detection data to processing (0 if it detects no one, 1 if it detects someone)
  Serial.print("\t");
  Serial.print(bpmAvg); //Send the bpm data to processing
  Serial.println("\t");
}


//Function definition to compute the moving average of the beats per minute
int MovingAverage (int bpm){
  bpmArray[pointer] = bpm; //store the sensor sample in the array
  pointer++;
  pointer = pointer % 4; //set the range of the pointer from 0 to 15
  
  sum = 0;
  for (i = 0; i < 4; i++){
    sum = sum + bpmArray[i];
  }
  return (int) sum/4; // sum << 3 or just sum/8 would work
  }
  
