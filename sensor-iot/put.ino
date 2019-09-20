#include <ArduinoJson.h>
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>

float leitura;
const char* ssid = "SSID_WIFI";
const char* password = "senha_wifi";

void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.print("\nConectando, aguarde...");
  }
}

void loop() {
  if (WiFi.status() != WL_CONNECTED) {
    Serial.print("\nDesconectado");
    delay(1000);
    return;
  } 

  leitura = analogRead(A0);
  Serial.print("\nConectado");

  StaticJsonDocument<300> doc;
  doc["_id"] = "5d76d8491c9d440000d40308";
  doc["code"] = "sensor-1";
  doc["value"] = leitura; 
  
  char bufferSensor[300];
  
  serializeJson(doc, bufferSensor);
  
  HTTPClient http;
  BearSSL::WiFiClientSecure client;
  client.setInsecure();
  
  http.begin(client, "https://weight-sensor-api.herokuapp.com/v1/public/sensors/sensor-1");
  http.addHeader("Content-Type", "application/json");

  int httpCode = http.PUT(bufferSensor);

  Serial.print("\nCódigo HTTP:");
  Serial.print(httpCode);
  
  if (httpCode == 200) {
    String payload = http.getString();
    Serial.print("\n");
    Serial.println(payload);
  }

  http.end();
  delay(10000);
}
