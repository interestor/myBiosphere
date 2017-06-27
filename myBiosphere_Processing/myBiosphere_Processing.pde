import processing.serial.*;//import serial library
Serial myPort;//make instance named myPort

BufferedReader reader;//for read csv
String line; 

String datastr;  // data for write csv
PrintWriter output;  // PrintWriterobject for write csv


//GUI parts location varieble
int light_y_location=80*6;
int heater_y_location=80*7;
int onbox_x_location=300;
int offbox_x_location=500;
int input_location_x;
int input_location_y;


//varieble of setting  threshold 
String heart_on="22.4";
String heart_off="";
String light_on="";
String light_off="";


String light_val="0";
String temp_val="0";
String CO2_val="0";

int which_box_click;
String keys;
String submit;

int day_diff;
PImage light_img;
PImage temp_img;
PImage CO2_img;

void setup() {
  size(700, 700);//window size
  
  light_img = loadImage("light.png");
  temp_img = loadImage("temp.png");
  CO2_img = loadImage("CO2.png");

  
  //set Serial 
  //println(Serial.list());  // 使えるポート一覧。下記ポートをSerial.list()[0]に書き換えると自動でシリアルポートが選択される（自分は二番だったのでマニュアル指定した）
  myPort = new Serial(this, "/dev/tty.usbserial-A4001CMh", 9600);//Serial port setting.Write your Serial port name appear in Arduino tool.
  myPort.clear();
  
  keys = new String();//テキストボックス用。複数文字の入力ができるようにkeysという文字列変数を作る
  
    //show how long myBiosphere keep
  reader = createReader("myBiosphere_log.csv");//open csv file
  line=null;
  try {
    line = reader.readLine();//1行読む
  } 
  catch (IOException e) {//エラー処理
    e.printStackTrace();
    println("read error");
  }

/*   
 String[] co = split(line, ','); // , で分割して日にちの情報だけどり出す
 String[] yyyymmdd = split(co[0], '/');// /で分割して年、月、日にちをわける
 println(co[0]);
 int mon_to_days[]={0,0,31,59,90,120,151,181,212,243,273,304,334,365,396};//その月までの経過日数

  //記録し始めた日までの経過日数
 int year1=int(yyyymmdd[0]);
 int month1=int(yyyymmdd[1]);
 int day1=int(yyyymmdd[2]);
 int dy1= (year1-1)*365;
 int dl1 = year1 / 4 - year1 / 100 + year1 / 400;//うるう年
 int dm1 = mon_to_days[month1];
 int d1 = day1;
 int start_days= dy1 + dl1 + dm1 + d1-1;//1年1月1日から始めた年までの経過日数
 
  //今日までの経過日数
 int now_year=year();
 int now_month=month();
 int now_day=day();
 int now_dy= (now_year-1)*365;
 int now_dl = now_year / 4 - now_year / 100 + now_year / 400;//うるう年
 int now_dm = mon_to_days[now_month];
 int now_d = now_day;
 int now_days= now_dy + now_dl + now_dm + now_d-1;//1年1月1日から今日までの経過日数
 
 day_diff=now_days - start_days;
 
 // make and open log file to write
 output = createWriter("myBiosphere_log.csv");  
*/ 
   
 
}

void draw() {
  //draw background color
  background(255, 255, 255);
  fill(218,235,0);
  noStroke();
  rect(0,0,width,80*1.5);
  fill(200,200,200);
  rect(0,80*5,width,height);
  

  //draw text (text,x, y)
  fill(255,255,255);
  textSize(20);
  text("This biosphere keeps",160,80);
  textAlign(CENTER);
  text("days",width/2+160,80);

  fill(0,0,0);
  textSize(50);
  text(day_diff,width/2,80);
  
  fill(0,0,0);
  textSize(16);
  text("Illumination",width/2-50, 80*2+40);
  text("temprature", width/2-50, 80*3+40);
  text("CO2", width/2-50, 80*4+40);
  
  image(light_img, width/2-200, 80*2-25+40);
  image(temp_img, width/2-200+8, 80*3-25+40);
  image(CO2_img, width/2-200, 80*4-25+40);
  
  
 
  textSize(16);
  text("setting", 100, 80*5+40);
  text("light", 180, light_y_location);
  text("on", onbox_x_location-50, light_y_location);
  text("off", offbox_x_location-50, light_y_location);
  text("heater", 180, heater_y_location);
  text("on", onbox_x_location-50, heater_y_location);
  text("off", offbox_x_location-50, heater_y_location);

  fill(255, 255, 255);//color of box
  rect(onbox_x_location, light_y_location-20, 60, 21);
  rect(offbox_x_location, light_y_location-20, 60, 21); 
  rect(onbox_x_location, heater_y_location-20, 60, 21);
  rect(offbox_x_location, heater_y_location-20, 60, 21);


  //draw valu at that time
  textSize(40);
  fill(0, 0, 0);//color of text
  text(light_val + " ", width/2+100, 80*2+8+40);//change value every cycle
  text(temp_val, width/2+100+3, 80*3+8+40);//change value every cycle
  text(CO2_val, width/2+100, 80*4+8+40);//change value every cycle
  textSize(16);
  text("℃", width/2+200, 80*3+40);
  text("ppm", width/2+200, 80*4+40);
  


  //draw setting text box
  textSize(16);

  text(light_on, onbox_x_location+30, light_y_location);// light on box
  text(light_off, offbox_x_location+30, light_y_location);//lght off box
  text(heart_on, onbox_x_location+30, heater_y_location);// heater on box
  text(heart_off, offbox_x_location+30, heater_y_location);//heater off box  


  //draw submit button
  fill(10, 10, 10);
  rect(160, 80*8-20, 400, 30);
  fill(250, 255, 255);
  text("submit",width/2+15,80*8);
  fill(10, 10, 10);
 

  
  
//read sensor value from arduino
    if ( myPort.available() > 0) {
    //for debug // println("port available");
    delay(1000);
    datastr = myPort.readString();//read data
    String[] datastr_split = splitTokens(datastr,",");
    temp_val = datastr_split[1];
    light_val = datastr_split[3];
    CO2_val = datastr_split[5];
    //println(temp_val);for debug
    //println(light_val);
    //println(CO2_val);
    
 /*   
  //write csv    
    datastr = nf(year(),2)+"/"+nf(month(),2)+"/"+nf(day(),2)+","+nf(hour(),2) + ":" + nf(minute(),2) + ":" + nf(second(),2) + "," + datastr  ;
    output.println(datastr);
    output.flush();  // 出力バッファに残っているデータを全て書き出し
    //    output.close();  // ファイルを閉じる
   //println(datastr); //print in console.
 */   } 
    
}



void mousePressed() {
  //jadge which box is clicked
  //when click light on box
  
keys = "";
  
  if (mouseY>light_y_location-20 && mouseY<light_y_location && mouseX> onbox_x_location && mouseX<onbox_x_location+30) {
    which_box_click=1;
  } else {

    //when click light off box
    if (mouseY>light_y_location-20 && mouseY<light_y_location && mouseX> offbox_x_location && mouseX<offbox_x_location+30) {
      which_box_click=2;
    } else {

      //when click heater on box
      if (mouseY>heater_y_location-20 && mouseY<heater_y_location && mouseX> onbox_x_location && mouseX<onbox_x_location+30) {
        which_box_click=3;
      } else {

        //when click heater off box
        if (mouseY>heater_y_location-20 && mouseY<heater_y_location && mouseX> offbox_x_location && mouseX<offbox_x_location+30) {
          which_box_click=4;
        } else {
          //when click background 
          which_box_click=0;

        }
      }
    }
  }
}

 
void keyPressed() {//when you push key,below event run. "keys" shoud be here,otherwise "keys" store same massive charactors.

  

  switch (which_box_click) {

  case 1: 
    keys = keys + key; //Store multiple entered characters
    light_on=keys;
    break; // switch文を抜ける
  case 2:
    keys = keys + key; //Store multiple entered characters
    light_off=keys;
    break; // switch文を抜ける

  case 3:
    keys = keys + key; //Store multiple entered characters
    heart_on=keys;
    break; // switch文を抜ける
  case 4: 
    keys = keys + key; //Store multiple entered characters
    heart_off=keys;
    break; // switch文を抜ける
  }
}


/*これなに？テストに使ったっぽいな。
void serialEvent(Serial p) {
  light_val = p.read();
}
*/



void mouseClicked() {  // if push submit button

  if (mouseX>160 && mouseX<400 && mouseY>80*8-20 && mouseY<80*8-20+30) { // submit lacationis  rect(160, 80*8-20, 400, 30); 
    
    String sent_data = heart_on+","+heart_off+","+light_on+","+light_off;
    myPort.write(sent_data);
    println(sent_data);
    myPort.write(";");
    
  }
}