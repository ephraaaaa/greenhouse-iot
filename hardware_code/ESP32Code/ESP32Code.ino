#include <WiFiClient.h>
#include <NTPClient.h>
#include <TimeLib.h>
#include <HTTPClient.h>
#include<Firebase_ESP_Client.h>
#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"
#define API_KEY "AIzaSyCMf_3QMVYAdNPYQsV9e-vJDr2VrGjYyZU"
#define DB_URL "https://green-house-monitoring-4f6c7-default-rtdb.asia-southeast1.firebasedatabase.app/"
#define USER_EMAIL "arduinoproject@gmail.com"
#define USER_PASSWORD "arduinoproject1"
#define RAIN_SENSOR_PIN 4
#ifndef STASSID
#define STASSID "Ephra" 
#define STAPSK "myAcccount3"// replace with your own wifi credentials
#endif
const char* ssid = STASSID;
const char* password = STAPSK;
const char* firebase_email = USER_EMAIL;
const char* firebase_password = USER_PASSWORD;
const char* api_key = API_KEY;
const char* database_url = DB_URL;
const char* serverUrl = "https://greenhousemonitoring.site/server/open_roof_status";
String previousPayload = ""; // Variable to store the previous payload
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP);

void setup() {
  Serial.begin(115200);
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  Serial.println("");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  
  Serial.print("Connected to ");
  Serial.println(ssid);
  timeClient.begin();
  config.api_key = api_key;
  config.database_url = database_url;

  auth.user.email = firebase_email;
  auth.user.password = firebase_password;
  
  Firebase.reconnectWiFi(true);
  Firebase.begin(&config, &auth);

}

void loop() {

  
  
  int temperature = random(27, 33);
  int humidity = random(45, 57);
  int soilMoisture = random(50, 60);  
  int lightIntensity = random(0, 100);
  int sensorValue = analogRead(RAIN_SENSOR_PIN);
  float percentage = map(sensorValue, 0, 1023, 0, 100);
  
  // Print the percentage to the serial monitor
  Serial.print("Rain percentage: ");
  Serial.print(percentage);
  Serial.println("%");
  
  // Determine if it's raining based on the percentage
  if (percentage > 50) {
    Serial.println("It's raining!");
  } else {
    Serial.println("It's not raining.");
  }
  if(WiFi.status() != WL_CONNECTED){
      Serial.println("Not connected restart device.");
      ESP.restart();
    }
  else{
  HTTPClient http;
  http.begin(serverUrl); // Specify the URL
  int httpResponseCode = http.GET(); // Make the request
  if (httpResponseCode > 0) {
    String payload = http.getString(); // Get the response payload
    if (payload != previousPayload) {
      Serial.println(payload);
      previousPayload = payload; // Update the previous payload
      // Do something with the changed payload here
    }
  } else {
    Serial.print("Error code: ");
    Serial.println(httpResponseCode);
  }
  
  http.end(); // Close connection
  delay(1000); // Wait for 5 seconds before making the next request
  

   timeClient.update();
   int dayOfWeekInt = timeClient.getDay() ;
 
   String dayOfWeekStr = String(dayOfWeekInt);
   realTimeUpdate(temperature, humidity, soilMoisture, lightIntensity);
   weeklyBroadcast(dayOfWeekStr, temperature, humidity, soilMoisture, lightIntensity);
   delay(1000);

    
    
   
    }
 
}





void realTimeUpdate(int temperature, int humidity, int soilMoisture, int lightIntensity){
  
  if(Firebase.RTDB.setInt(&fbdo,"real-time/temperature", temperature)&&
  Firebase.RTDB.setInt(&fbdo,"real-time/humidity", humidity)&&
  Firebase.RTDB.setInt(&fbdo,"real-time/soil-moisture", soilMoisture)&&
  Firebase.RTDB.setInt(&fbdo,"real-time/light-intensity", lightIntensity)){
    Serial.println("Data uploaded. -- Real-time");
    }
  else{
    Serial.println("Uploading error. -- Real-time");
    }
  }

void weeklyBroadcast(String dayOfWeekStr, int temperature, int humidity, int soilMoisture, int lightIntensity){
  if(Firebase.RTDB.setInt(&fbdo,"weekly_broadcast/"+dayOfWeekStr+"/temperature", temperature)&&
  Firebase.RTDB.setInt(&fbdo,"weekly_broadcast/"+dayOfWeekStr+"/humidity", humidity)&&
  Firebase.RTDB.setInt(&fbdo,"weekly_broadcast/"+dayOfWeekStr+"/soil-moisture", soilMoisture)&&
  Firebase.RTDB.setInt(&fbdo,"weekly_broadcast/"+dayOfWeekStr+"/light-intensity", lightIntensity)){
    Serial.println("Data uploaded. -- Weekly");
    }
  else{ 
    Serial.println("Uploading error. -- Weekly");
    }
  }
