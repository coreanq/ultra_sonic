#include <Firmata.h>

#define trigPin 11
#define echoPin 12
#define switchPin 10
#define RedLed 4
#define greenLed 3
#define pingPin 7

void setup() {
  Serial.begin (115200);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  pinMode(RedLed, OUTPUT);
  pinMode(greenLed, OUTPUT);
  pinMode(switchPin, INPUT);
  Firmata.setFirmwareVersion(FIRMATA_FIRMWARE_MAJOR_VERSION, FIRMATA_FIRMWARE_MINOR_VERSION);
  Firmata.begin(115200);
}

void loop()
{
  while (Firmata.available()) {
    Firmata.processInput();
  }

  int distance = computeDistance();

  //  Serial.print(distance);
  //  Serial.println(" cm");
  Firmata.sendAnalog(pingPin, distance);
  bool pinState = digitalRead(switchPin);
  Firmata.sendDigitalPort(switchPin, pinState);
}


long computeDistance()
{
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  // 30 msec time out in sensor spec
  long duration = pulseIn(echoPin, HIGH, 30000);
  int distance = microsecondsToCentimeters(duration);

  if (distance < 4) {  // This is where the RED LED On/Off happens
    digitalWrite(RedLed, HIGH); // When the Red condition is met, the Green LED should turn off
    digitalWrite(greenLed, LOW);
  }
  else {
    digitalWrite(RedLed, LOW);
    digitalWrite(greenLed, HIGH);
  }
  // it's timeout(30us) when the distance is 0, so dont need to delay
  if ( distance != 0 )
    delay(30);

  return distance;
}
long microsecondsToInches(long microseconds)
{
  // According to Parallax's datasheet for the PING))), there are
  // 73.746 microseconds per inch (i.e. sound travels at 1130 feet per
  // second).  This gives the distance travelled by the ping, outbound
  // and return, so we divide by 2 to get the distance of the obstacle.
  // See: [http://www.parallax.com/dl/docs/prod/acc/28015-PING-v1.3.pdf](http://www.parallax.com/dl/docs/prod/acc/28015-PING-v1.3.pdf)
  return microseconds / 74 / 2;
}

long microsecondsToCentimeters(long microseconds)
{
  // The speed of sound is 340 m/s or 29 microseconds per centimeter.
  // The ping travels out and back, so to find the distance of the
  // object we take half of the distance travelled.
  return microseconds / 29 / 2;
}


