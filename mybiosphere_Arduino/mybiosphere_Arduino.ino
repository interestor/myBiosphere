
#define TEMP_SENSORPIN  (2)
#define LIGHT_SENSORPIN  (1)
#define LED_PIN 4
#define CO2_PWM 3 //CO2
#define HEATER_PIN (5)


int temp_val = 0;
float B=3435,T0=298.15,R0=10.0,R1=3.25,rr1,t;//for temprature

float v = 5;
float temp = 0;
float heat_on = 35;
float heat_off = heat_on + 100;
int light_on = 40;
int light_off = 40;
int break_co2_loop;

//for CO2
int prevVal = LOW;
long th, tl, h, l, ppm;

String recieve= "22.4,0,0,0";

void setup() {
  Serial.begin(9600);
  pinMode(LED_PIN, OUTPUT);
  pinMode(CO2_PWM, INPUT);
  pinMode(HEATER_PIN,OUTPUT);
    pinMode(13,OUTPUT);//////////////////test
  ppm=0;
}

void loop() {

 
 
 //mesuare temprature by AT-103
  temp_val = analogRead(TEMP_SENSORPIN);
  rr1=R1*temp_val/(1024.0-temp_val);
  t=1/(log(rr1/R0)/B+(1/T0));
  temp=(t-273.15);
 

  //mesure light by cds

  int light_val = analogRead( LIGHT_SENSORPIN );
  int light  = map(light_val, 0, 100, 0, 1023);


  //mesure CO2
  

  break_co2_loop=0;
  while( break_co2_loop < 2 ){

    long tt = millis();
    int myVal = digitalRead(CO2_PWM);

    if (myVal == HIGH) {
      if (myVal != prevVal) {
        h = tt;
        tl = h - l;
        prevVal = myVal;
      }
    }  
    else {
      if (myVal != prevVal) {
        l = tt;
        th = l - h;
        prevVal = myVal;
        ppm = 5000 * (th - 2) / (th + tl - 4);
        break_co2_loop++;
        if(break_co2_loop==2){
          
          Serial.print("temp,");//どこに入れる？
          Serial.print(temp);
          Serial.print(",");
          Serial.print("light,");
          Serial.print(light);
          Serial.print(",");
          Serial.println("CO2 ," + String(ppm));
        }
      }
    }
  }


///recieve threshold

while (Serial.available()) { // If data is available to read,
  recieve  = Serial.readStringUntil(';'); // read it and store it in val
 
  char recieve_c[255];
  recieve.toCharArray(recieve_c, 255);//文字列操作のためchar型に変換
  
  //,で分割してcharに格納
  char *heat_on_c = strtok(recieve_c,",");
  char *heat_off_c = strtok(NULL,",");  //2回目以降は第一引数はNULL
  char *light_on_c = strtok(NULL,","); 
  char *light_off_c = strtok(NULL,","); 

  
  //Serial.println(heat_on_c);//for debug
  //Serial.println(heat_off_c);
  //Serial.println(light_on_c);
  //Serial.println(light_off_c);
 
 //char からfloatに変換 
  heat_on = atof(heat_on_c);
  heat_off = atof(heat_off_c);
  light_on = atof(light_on_c);
  light_off = atof(light_off_c);

 delay(100); // Wait 100 milliseconds for next reading
   
 }
 
 
 
  //swich light
  if (light < light_on ) {//if light sensor val shows  daker than light_on threshold 
    digitalWrite(LED_PIN, HIGH);
  }
  else{
      digitalWrite(LED_PIN, LOW);
    }

  //swich heater
  if (temp < heat_on ) {//if temprature cooler than heat_on threshold 
    digitalWrite(HEATER_PIN, HIGH);
  }
  else{
    if(temp > heat_off){
      digitalWrite(HEATER_PIN, LOW);
    }
  }


}




