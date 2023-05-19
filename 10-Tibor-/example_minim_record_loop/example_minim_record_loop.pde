/**
  Attempt a perfect loop with sound recording
  It should stop exactly at 1s - audio time, not visual frame time
    
  Get sample rate
  ffprobe -v error -select_streams a:0 -show_entries stream=sample_rate -of default=noprint_wrappers=1 input.wav
    
  
  
*/

import ddf.minim.*;
import javax.sound.sampled.*;
import ddf.minim.ugens.*;
import ddf.minim.AudioSample;
import ddf.minim.javasound.*;

Minim minim;
AudioRecorder recorder;
AudioSample sample;
AudioOutput out;
Oscil wave;
WaveformListener wl;
AudioPlayer audioPlayer;
Sampler s;
AudioSample pAudioSample;

int sampleSize = 44100; // Number of samples to record

int rate = 44100;
float[] samples = new float[rate * 8]; // 8 seconds worth

float waveFrequency  = 220f;
float waveSampleRate = 44100f;

void setup() {
  size(200, 200);
  minim = new Minim(this);
  out = minim.getLineOut();
  println("Buffer size " +  out.bufferSize());
  println("Sample rate " + out.sampleRate());

  // Just getting the left one

  println("--------------------");
  wave = new Oscil( 440, 0.5f, Waves.SINE );
  wave.patch( out );

  AudioFormat format = new AudioFormat( waveSampleRate, // sample rate
    16, // sample size in bits
    1, // channels
    true, // signed
    true   // bigEndian
    );

  //recorder = minim.createRecorder(out, "output.wav");
  sample = minim.createSample(samples, format, 1024); // Create an empty sample of the specified size
  wl = new WaveformListener(int(out.sampleRate()));
  out.addListener(wl);
  //recorder.beginRecord();

  // TODO
  // 1. Add samples into an AudioSample
  // 1.5 - playback audioSample with loop
  // 2. Save the AudioSample with the audio recorder
  // 3. Make sure we have exactly the right number of samples
  // 4. Should know how many audio samples
}
boolean tr = false;
void draw() {
  float t = 1.0 * frameCount / frameRate;
  //println(t);
  
  if (t > 1.5) {
    wave.unpatch(out);
  }
  /*
  if (t > 2 && !tr) {
    //wl.audioSample.trigger();
    // Save sample to file and load it back
    
    //JSStreamingSampleRecorder jsr; - not visible to be used directly
    recorder = minim.createRecorder(wl.audioSample, "output-loop.wav");
    // JSBufferedSampleRecorder  a;
    
    recorder.beginRecord();
    recorder.endRecord();
    recorder.save();
    //audioPlayer = minim.loadFile("output-loop.wav");
    //audioPlayer.loop(10);
    tr = true; 
  }

  if (t > 100) {
    recorder.endRecord(); // Stop recording
    noLoop(); // Stop the draw() method
    stop();
  }*/
}

void stop() {
  print("Stopped the sketch");
  recorder.endRecord();
  recorder.save();
  minim.stop();
  exit();
}
