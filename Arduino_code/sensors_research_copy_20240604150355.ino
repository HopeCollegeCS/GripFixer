const int forceSensorPin1 = A0; // Define the analog pin for the first force sensor
const int forceSensorPin2 = A1; // Define the analog pin for the second force sensor
const int forceSensorPin3 = A2; // Define the analog pin for the third force sensor33
const int motorPin = A7; // Define the digital pin for the motor
const int threshold = 600; // Define the threshold value for the force sensor


void setup() {
  Serial.begin(9600); // Initialize serial communication at 9600 baud
  Serial.print("Force sensor 1 is connected to analog pin: ");
  Serial.println(forceSensorPin1);
  Serial.print("Force sensor 2 is connected to analog pin: ");
  Serial.println(forceSensorPin2);
   Serial.print("Force sensor 3 is connected to analog pin: ");
  Serial.println(forceSensorPin3);
  pinMode(motorPin, OUTPUT); // Set the motor pin as an output
  digitalWrite(motorPin, LOW); // Ensure motor is off initially
}


void loop() {
  int sensorValue1 = analogRead(forceSensorPin1); // Read the analog value from the first force sensor
  int sensorValue2 = analogRead(forceSensorPin2); // Read the analog value from the second force sensor
 int sensorValue3 = analogRead(forceSensorPin3); // Read the analog value from the second force sensor
 
  Serial.print("Force Sensor 1 Value: ");
  Serial.println(sensorValue1); // Print the value from the first force sensor
 
  Serial.print("Force Sensor 2 Value: ");
  Serial.println(sensorValue2); // Print the value from the second force sensor

  Serial.print("Force Sensor 3 Value: ");
  Serial.println(sensorValue3); // Print the value from the second force sensor
 
  if (sensorValue1 > threshold) {
    digitalWrite(motorPin, HIGH); // Turn the motor on if the first force sensor value is above the threshold
    Serial.println("Motor ON");
    delay(150); //on for 100 milliseconds
    digitalWrite(motorPin, LOW); //
    Serial.println("Motor OFF");
    delay(75); //off for 100 milliseconds
  } else {
    digitalWrite(motorPin, LOW); // Turn the motor off if the first force sensor value is below the threshold
    Serial.println("Motor OFF");
  }


  delay(75); // Wait for 500 milliseconds (0.5 second)
}
