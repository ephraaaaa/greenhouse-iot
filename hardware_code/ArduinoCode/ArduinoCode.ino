#include <Servo.h>
#define SERVO_1 10
Servo servo1;

String toogle = "";

String rcvTrue = "{\"toggle\":true}";
String rcvFalse = "{\"toggle\":false}";

void setup() {
  Serial.begin(115200);
  servo1.attach(SERVO_1);

  while (!Serial){
    ;
  }
}
int a = 0;


void loop() {
  
  if (Serial.available() > 0) {
    String receivedString = Serial.readStringUntil("\n");
    receivedString.trim();  // Trim any leading or trailing spaces
    //receivedString.replace("\n", ":"); 
    Serial.print(receivedString);
    Serial.println("MEOW");
    
    if (receivedString == rcvTrue) {
      a = 0;
      openRoof();
    } else if (receivedString == rcvFalse) {
      a = 35;
      closeRoof();
    }
  } else{
  }
}

void openRoof(){
    while(a<=35){
    meow(a);
    delay(100);
    a++;
    } 
}

void closeRoof(){
    while(a>=0){
    meow(a);
    delay(100); 
    a--;
  }
}

void meow(int number){
  moveServoToAngle(servo1, number);
}

// Function to move a servo to a specific angle
void moveServoToAngle(Servo &servo, int angle) {
  // Convert the angle to the corresponding PWM value (500 to 2400)
  int pwmValue = map(angle, 0, 180, 500, 2400);
  
  // Move the servo to the desired angle
  servo.writeMicroseconds(pwmValue);
}
