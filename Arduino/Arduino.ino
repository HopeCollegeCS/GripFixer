// for communication
#include <ArduinoBLE.h>
// for string manipulation
#include <string>  
#include <vector>  


/*  This code sets up a Bluetooth Low Energy (BLE) peripheral device using the ArduinoBLE library. 
It defines a BLE service and two characteristics: one for receiving requests and one for sending responses. */

// define the UUIDS for the BLE service and characteristics
const char * deviceServiceUuid = "19b10000-e8f2-537e-4f6c-d104768a1214";
const char * deviceServiceRequestCharacteristicUuid = "19b10001-e8f2-537e-4f6c-d104768a1215"; 
const char * deviceServiceResponseCharacteristicUuid = "19b10001-e8f2-537e-4f6c-d104768a1216";
const char * deviceServiceMaxGripStrengthCharacteristicUuid = "19b10001-e8f2-537e-4f6c-d104768a1217"; // New UUID for max grip strength characteristic
const char * deviceServiceTargetGripPercentageCharacteristicUuid = "19b10001-e8f2-537e-4f6c-d104768a1218"; // New UUID for target grip percentage characteristic

// create instances of the BLE service and characteristics
BLEService servoService(deviceServiceUuid);
BLEIntCharacteristic servoRequestCharacteristic(deviceServiceRequestCharacteristicUuid, BLEWrite);
BLEIntCharacteristic servoResponseCharacteristic(deviceServiceResponseCharacteristicUuid, BLENotify);
BLEFloatCharacteristic maxGripStrengthCharacteristic(deviceServiceMaxGripStrengthCharacteristicUuid, BLERead); // New characteristic for max grip strength
BLEFloatCharacteristic targetGripPercentageCharacteristic(deviceServiceTargetGripPercentageCharacteristicUuid, BLERead); // New characteristic for target grip percentage

//2 sensors - buzz on and off until loosen and displays force values

const int forceSensorPin1 = A0; // Define the analog pin for the first force sensor
const int motorPin = A1; // Define the digital pin for the motor
int threshold = 2000; // Define the threshold value for the force sensor

float maxGripStrength = 2000.0; // Variable to store the player's maximum grip strength
float targetGripPercentage = 2.0; // Variable to store the target grip percentage

/* In the setup() function, the code initializes serial communication, sets the device name and local name for BLE, 
starts the BLE module, sets up the BLE service and characteristics, and starts advertising the BLE service. */ 
void setup() {
  BLE.setDeviceName("CSArduino");
  BLE.setLocalName("CSArduino");

  // start the BLE module
  if (!BLE.begin()) {
    Serial.println("- Starting Bluetooth® Low Energy module failed!");
    while (1);
  }

  // The BLE service and characteristics are set up and added to the BLE device.
  BLE.setAdvertisedService(servoService);
  servoService.addCharacteristic(servoRequestCharacteristic);
  servoService.addCharacteristic(servoResponseCharacteristic);
  servoService.addCharacteristic(maxGripStrengthCharacteristic);
  servoService.addCharacteristic(targetGripPercentageCharacteristic);
  BLE.addService(servoService);

  // initialize the servoRequestCharacteristic value to 0
  servoRequestCharacteristic.setValue(0);
  // initialize maxGripStrengthCharacteristic and targetGripPercentageCharacteristic
  maxGripStrengthCharacteristic.setValue(maxGripStrength);
  targetGripPercentageCharacteristic.setValue(targetGripPercentage);

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

  // Mia and Isaac's code
  Serial.begin(9600); // Initialize serial communication at 9600 baud
  Serial.print("Force sensor 1 is connected to analog pin: ");
  Serial.println(forceSensorPin1);

  pinMode(motorPin, OUTPUT); // Set the motor pin as an output
  digitalWrite(motorPin, LOW); // Ensure motor is off initially
}


/* The loop() function continuously checks for a connected central device. 
If a central device is connected, it prints a message to the serial monitor and enters a loop. */
void loop() {
  // get the central device
  BLEDevice central = BLE.central();
  // wait for half a second
  delay(500);

  if (central) {
    Serial.println("* Connected to central device!");
    Serial.print("* Device MAC address: ");
    Serial.println(central.address());
    Serial.println(" ");

    // while the central device is connected
    while (central.connected()) {
      
      int sensorValue1 = analogRead(forceSensorPin1); // Read the analog value from the first force sensor
 
      Serial.print("Force Sensor 1 Value: ");
      Serial.println(sensorValue1); // Print the value from the first force sensor

      // Update the maximum grip strength if the current value is higher
      if (sensorValue1 > maxGripStrength) {
        maxGripStrength = sensorValue1;
        maxGripStrengthCharacteristic.writeValue(maxGripStrength); 
      }

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

      // Send the sensor values over BLE
      if (!servoResponseCharacteristic.writeValue(sensorValue1)) {
        Serial.println("Failed to write value for sensor 1");
      }
      // if the request characteristic has been written to
      if (servoRequestCharacteristic.written()) {
        // read the value from the request characteristic
        int newAngle = servoRequestCharacteristic.value();
        Serial.println(newAngle);
        Serial.println();
      }

      // Check if there is data available in the Serial monitor
      if (Serial.available()) {
        // read user input from the serial monitor
        String userInput = Serial.readStringUntil('\n'); 
        userInput.trim(); 

        // Send the user input over BLE
        int intValue = userInput.toInt();
        servoRequestCharacteristic.writeValue(intValue);
        Serial.print("Sent value: ");
        Serial.println(intValue);
      }

      // Check if the max grip strength characteristic has been written to
      if (maxGripStrengthCharacteristic.written()) {
        maxGripStrength = maxGripStrengthCharacteristic.value();
        Serial.print("Max Grip Strength: ");
        Serial.println(maxGripStrength);
      }

      // Check if the target grip percentage characteristic has been written to
      //if (targetGripPercentageCharacteristic.written()) {
        // Read the value from the target grip percentage characteristic
        targetGripPercentage = targetGripPercentageCharacteristic.value();
        targetGripPercentage = targetGripPercentage*0.1;
        Serial.print("Target Grip Percentage: ");
        Serial.println(targetGripPercentage);
      //}

      // Calculate the threshold based on the target grip percentage and maximum grip strength
      threshold = (maxGripStrength * targetGripPercentage);
      Serial.print("Threshold: ");
      Serial.println(threshold);

      delay(1000);
    }
    Serial.println("* Disconnected to central device!");
  }
}
