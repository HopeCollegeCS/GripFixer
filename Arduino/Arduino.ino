// for communication
#include <ArduinoBLE.h>
// for string manipulation
#include <string>  
#include <vector>  
// for IMU
#include <Arduino_LSM6DS3.h>

/*  This code sets up a Bluetooth Low Energy (BLE) peripheral device using the ArduinoBLE library. 
It defines a BLE service and two characteristics: one for receiving requests and one for sending responses. */

// define the UUIDS for the BLE service and characteristics
const char * deviceServiceUuid = "19b10000-e8f2-537e-4f6c-d104768a1214";
const char * deviceServiceRequestCharacteristicUuid = "19b10001-e8f2-537e-4f6c-d104768a1215"; 
const char * deviceServiceResponseCharacteristicUuid = "19b10001-e8f2-537e-4f6c-d104768a1216";
const char * deviceServiceMaxGripStrengthCharacteristicUuid = "19b10001-e8f2-537e-4f6c-d104768a1217"; // New UUID for max grip strength characteristic
const char * deviceServiceTargetGripPercentageCharacteristicUuid = "19b10001-e8f2-537e-4f6c-d104768a1218"; // New UUID for target grip percentage characteristic
const char * deviceServiceEnableFeedbackCharacteristicUuid = "19b10001-e8f2-537e-4f6c-d104768a1219"; // New UUID for enabling feedback
const char * deviceServiceSensorNumberCharacteristicUuid = "19b10001-e8f2-537e-4f6c-d104768a1220"; // New UUID for enabling feedback

// create instances of the BLE service and characteristics
BLEService servoService(deviceServiceUuid);
BLEIntCharacteristic servoRequestCharacteristic(deviceServiceRequestCharacteristicUuid, BLEWrite);
BLEIntCharacteristic servoResponseCharacteristic(deviceServiceResponseCharacteristicUuid, BLENotify);
BLEIntCharacteristic maxGripStrengthCharacteristic(deviceServiceMaxGripStrengthCharacteristicUuid, BLEWrite | BLERead); // New characteristic for max grip strength
BLEIntCharacteristic targetGripPercentageCharacteristic(deviceServiceTargetGripPercentageCharacteristicUuid, BLEWrite | BLERead); // New characteristic for target grip percentage
BLEBoolCharacteristic enableFeedbackCharacteristic(deviceServiceEnableFeedbackCharacteristicUuid, BLEWrite | BLERead); // New characteristic for enabling feedback
BLEIntCharacteristic sensorNumberCharacteristic(deviceServiceSensorNumberCharacteristicUuid, BLEWrite | BLERead); // New characteristic for sensor number

//2 sensors - buzz on and off until loosen and displays force values
int forceSensorPin1 = A0; // Define the analog pin for the first force sensor
const int buzzerPin = A6; //Define the analog pin for the buzzer pin
const int motorPin = A7; // Define the digital pin for the motor
int threshold = 0; // Define the threshold value for the force sensor

float maxGripStrength = 2000.0; // Variable to store the player's maximum grip strength
float targetGripPercentage = 2.0; // Variable to store the target grip percentage
bool enableFeedback = true; // Variable to store whether feedback is enabled
int sensorNumber;

// Variables for IMU
float x, y, z;
float prevX, prevY, prevZ;
float impactThreshold = 1.0; // change this to detect the threshole of hitting a tennis ball
bool impactOccurred = false;

// A function that audiates a beep depending on the amount of times given
void beep(int times) {
  for (int i = 0; i < times; i++) {
    tone(buzzerPin, 1000); 
    delay(1000);
    noTone(buzzerPin);
    delay(1000);
  }
}

// Detects and displays impact information
void displayImpact() {
  // Calculate the change in acceleration
  float deltaX = x - prevX;
  float deltaY = y - prevY;
  float deltaZ = z - prevZ;

  // Calculate the magnitude of the impact
  float impactMagnitude = sqrt(deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ);

  // Check if the impact magnitude exceeds the threshold
  if (impactMagnitude > impactThreshold) {
    Serial.println("Impact detected!");
    Serial.print("Impact magnitude: ");
    Serial.println(impactMagnitude, 2);
    impactOccurred = true;
  }

  // Update previous acceleration values
  prevX = x;
  prevY = y;
  prevZ = z;
}

/* In the setup() function, the code initializes serial communication, sets the device name and local name for BLE, 
starts the BLE module, sets up the BLE service and characteristics, and starts advertising the BLE service. */ 
void setup() {
  beep(2);
  BLE.setDeviceName("CSArduino");
  BLE.setLocalName("CSArduino");
  delay(1000);
  beep(3);
  
  // start the BLE module
  if (!BLE.begin()) {
    beep(2); 
    Serial.println("- Starting Bluetooth® Low Energy module failed!");
    while (1);
  } else {
    beep(1); // Beep once when connected
  }

  // The BLE service and characteristics are set up and added to the BLE device.
  BLE.setAdvertisedService(servoService);
  servoService.addCharacteristic(servoRequestCharacteristic);
  servoService.addCharacteristic(servoResponseCharacteristic);
  servoService.addCharacteristic(maxGripStrengthCharacteristic);
  servoService.addCharacteristic(targetGripPercentageCharacteristic);
  servoService.addCharacteristic(enableFeedbackCharacteristic);
  servoService.addCharacteristic(sensorNumberCharacteristic);
  BLE.addService(servoService);

  // initialize the servoRequestCharacteristic value to 0
  servoRequestCharacteristic.setValue(0);
  // initialize maxGripStrengthCharacteristic and targetGripPercentageCharacteristic
  maxGripStrengthCharacteristic.setValue(maxGripStrength);
  targetGripPercentageCharacteristic.setValue(targetGripPercentage);
  enableFeedbackCharacteristic.setValue(enableFeedback);

  // The BLE device starts advertising its service.
  if (!BLE.advertise()) {
    Serial.println("Failed to advertise service");
  }
  else {
    Serial.println("Advertising service successful");
  }

  // prints a message to the serial monitor
  Serial.println("Arduino R4 WiFi BLE (Peripheral Device)");
  Serial.println(" ");

  Serial.begin(9600); // Initialize serial communication at 9600 baud
  Serial.print("Force sensor 1 is connected to analog pin: ");
  Serial.println(forceSensorPin1);

  pinMode(buzzerPin, OUTPUT); // Set the motor pin as an output
  pinMode(motorPin, OUTPUT); // Set the motor pin as an output
  digitalWrite(motorPin, LOW); // Ensure motor is off initially

  // Set up for IMU
   if (!IMU.begin()) {
    Serial.println("Failed to initialize IMU!");
    while (1);
  }
  Serial.print("Accelerometer sample rate = ");
  Serial.print(IMU.accelerationSampleRate());
  Serial.println("Hz");

  // Initialize previous acceleration values
  if (IMU.accelerationAvailable()) {
    IMU.readAcceleration(prevX, prevY, prevZ);
  }
}
/* The loop() function continuously checks for a connected central device. 
If a central device is connected, it prints a message to the serial monitor and enters a loop. */
void loop() {
  // get the central device
  BLEDevice central = BLE.central();
  // wait for half a second
  delay(500);

  if (central) {
    beep(1); // Beep once when connected
    // while the central device is connected
    while (central.connected()) {
      // Check if acceleration data is available from the IMU sensor, then read the acceleration values
      if (IMU.accelerationAvailable()) {
        IMU.readAcceleration(x, y, z);
        displayImpact();
      }
      
      int sensorValue1 = analogRead(forceSensorPin1); // Read the analog value from the first force sensor
 
      Serial.print("Force Sensor 1 Value: ");
      Serial.println(sensorValue1); // Print the value from the first force sensor

      // Update the maximum grip strength if the current value is higher
      if (sensorValue1 > maxGripStrength) {
        maxGripStrength = sensorValue1;
        maxGripStrengthCharacteristic.writeValue(maxGripStrength); 
      }

      if (sensorValue1 > threshold && enableFeedback) {
        digitalWrite(motorPin, HIGH); // Turn the motor on if the first force sensor value is above the threshold
        delay(150); //on for 150 milliseconds
        digitalWrite(motorPin, LOW); //
        delay(75); //off for 75 milliseconds
      } else {
        digitalWrite(motorPin, LOW); // Turn the motor off if the first force sensor value is below the threshold
      }

      // Check if an impact occurred
      if (impactOccurred) {
        // Skip sending servoResponseCharacteristic
        Serial.println("Impact detected, skip data send");
        delay(1000);  // Delay for 1 second
        impactOccurred = false;  // Reset the flag
      } else {
        // Send the sensor values over BLE
        if (!servoResponseCharacteristic.writeValue(sensorValue1)) {
          Serial.println("Failed to write value for sensor 1");
        }
      }

      // if the request characteristic has been written to
      if (servoRequestCharacteristic.written()) {
        // read the value from the request characteristic
        int newAngle = servoRequestCharacteristic.value();
      }

      // Check if there is data available in the Serial monitor
      if (Serial.available()) {
        // read user input from the serial monitor
        String userInput = Serial.readStringUntil('\n'); 
        userInput.trim(); 

        // Send the user input over BLE
        int intValue = userInput.toInt();
        servoRequestCharacteristic.writeValue(intValue);
      }

      // Check if the max grip strength characteristic has been written to
      if (maxGripStrengthCharacteristic.written()) {
        maxGripStrength = maxGripStrengthCharacteristic.value();
        Serial.print("Max Grip Strength: ");
        Serial.println(maxGripStrength);
      }

      // Check if the target grip percentage characteristic has been written to
      if (targetGripPercentageCharacteristic.written()) {
        // Read the value from the target grip percentage characteristic
        targetGripPercentage = targetGripPercentageCharacteristic.value();
        targetGripPercentage = targetGripPercentage*0.1;
        Serial.print("Target Grip Percentage: ");
        Serial.println(targetGripPercentage);
      }

      // Check if the enable feedback characteristic has been written to
      if (enableFeedbackCharacteristic.written()) {
        enableFeedback = enableFeedbackCharacteristic.value();
        Serial.print("Enable Feedback: ");
        Serial.println(enableFeedback);
      }

      // Calculate the threshold based on the target grip percentage and maximum grip strength
      threshold = (maxGripStrength * targetGripPercentage);

      delay(100);
    }
    beep(2); // Beep twice when disconnected
    Serial.println("* Disconnected to central device!");
  }
}
