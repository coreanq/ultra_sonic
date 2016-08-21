#define trigPin 11
#define echoPin 12
#define RedLed 13
#define greenLed 3

void setup() {
  Serial.begin (9600);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  pinMode(RedLed, OUTPUT);
  pinMode(greenLed, OUTPUT);
}

void loop() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(5);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  // 30 msec time out in sensor spec
  float duration = pulseIn(echoPin, HIGH, 30000);
  int distance = int(duration * 0.034 / 2);

  if (distance < 4) {  // This is where the RED LED On/Off happens
    digitalWrite(RedLed, HIGH); // When the Red condition is met, the Green LED should turn off
    digitalWrite(greenLed, LOW);
  }
  else {
    digitalWrite(RedLed, LOW);
    digitalWrite(greenLed, HIGH);
  }

  Serial.print(distance);
  Serial.println(" cm");


  //  if (distance >= 200 || distance <= 0){
  //      Serial.println(distance);
  //      Serial.println(duration);
  //  }
  //  else {
  //        Serial.print(distance);
  //        Serial.println(" cm");
  //  }
  delay(30);
}
