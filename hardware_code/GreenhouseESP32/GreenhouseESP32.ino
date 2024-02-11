#include <WiFiClient.h>
#include <NTPClient.h>
#include <TimeLib.h>
#include<Firebase_ESP_Client.h>
#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"


#define API_KEY "AIzaSyCMf_3QMVYAdNPYQsV9e-vJDr2VrGjYyZU"
#define DB_URL "https://green-house-monitoring-4f6c7-default-rtdb.asia-southeast1.firebasedatabase.app/"
#define USER_EMAIL "arduinoproject@gmail.com"
#define USER_PASSWORD "arduinoproject1"

#ifndef STASSID
#define STASSID "Ephra" // replace with your own wifi credentials
#define STAPSK "myAcccount3"// replace with your own wifi credentials
#endif

const char* ssid = STASSID;
const char* password = STAPSK;
const char* firebase_email = USER_EMAIL;
const char* firebase_password = USER_PASSWORD;
const char* api_key = API_KEY;
const char* database_url = DB_URL;


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

   timeClient.update();
   int dayOfWeekInt = timeClient.getDay() ;
 
   String dayOfWeekStr = String(dayOfWeekInt);
   Serial.println(dayOfWeekStr);
   realTimeUpdate(temperature, humidity, soilMoisture, lightIntensity);
   weeklyBroadcast(dayOfWeekStr, temperature, humidity, soilMoisture, lightIntensity);
   delay(1000);
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
