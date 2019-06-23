#include <Arduino.h>
#include <Wire.h>
#include <radio.h>
#include <RDA5807M.h>

RDA5807M radio;
int current_frequency = 8750, frequency = 8750;

void setup() {
  Serial.begin(9600);
  DDRA = 0x00;
  radio.init();
  radio.setBandFrequency(RADIO_BAND_FM, 8750);
  radio.setVolume(10);
  radio.setMono(false);
  radio.setMute(false);
}

void loop() {
  frequency = PINA * 10 + 8750;
  if (current_frequency != frequency)
  {
    radio.setBandFrequency(RADIO_BAND_FM, frequency);
    current_frequency = frequency;
  }
}
