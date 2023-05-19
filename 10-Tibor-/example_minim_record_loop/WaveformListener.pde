import javax.sound.sampled.*;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.DataLine;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.TargetDataLine;
import java.io.FileOutputStream;

class WaveformListener implements AudioListener
{
  private float[] left;
  private float[] right;
  int counter = 0;

  float[] leftAccu;
  float[] rightAccu;

  public AudioSample audioSample;

  WaveformListener(int sampleCount)
  {
    left = null;
    right = null;
    leftAccu = new float[sampleCount];
    rightAccu = new float[sampleCount];

    println("Sample count " + sampleCount);
  }

  public synchronized void samples(float[] samp)
  {
    left = samp;
  }
  boolean created = false;
  void createSample() {
    println("Create sample");
    if (!created) {
      println("creating thing");
      saveSampleChatGPT();
      created = true;
      exit();
    }
  }

  void saveSampleChatGPT() {
    int sampleSizeInBits = 16;
    int channels = 2;
    boolean signed = true;
    boolean bigEndian = false;
    int sampleRate = 44100;

    try {
      saveWavFile(sketchPath() + "/out.wav", leftAccu, rightAccu, sampleRate);
    }
    catch (IOException e) {
      System.out.println("An error occurred while saving the file: " + e.getMessage());
    }
  }



public  void saveWavFile(String filename, float[] samplesLeft, float[] samplesRight, int sampleRate) throws IOException {
  AudioFormat format = new AudioFormat(sampleRate, 16, 2, true, false);
  byte[] byteArray = toByteArray(samplesLeft, samplesRight, format);

  ByteArrayInputStream bais = new ByteArrayInputStream(byteArray);
  AudioInputStream ais = new AudioInputStream(bais, format, samplesLeft.length);

  try (FileOutputStream fos = new FileOutputStream(filename)) {
    AudioSystem.write(ais, AudioFileFormat.Type.WAVE, fos);
  }
}

private  float[] interleaveSamples(float[] leftSample, float[] rightSample) {
  float[] samples = new float[leftSample.length * 2];
  for (int i = 0, j = 0; i < leftSample.length; i++, j += 2) {
    samples[j] = leftSample[i];
    samples[j + 1] = rightSample[i];
  }
  return samples;
}
/*
  private  byte[] toByteArray(float[] samples, AudioFormat format) {
 int sampleSizeInBits = format.getSampleSizeInBits();
 int channels = format.getChannels();
 int bufferSize = (samples.length * sampleSizeInBits * channels) / 8;
 byte[] byteArray = new byte[bufferSize];
 int sampleIndex, channelIndex;
 for (int i = 0; i < samples.length; i++) {
 sampleIndex = i * sampleSizeInBits * channels / 8;
 channelIndex = i * channels % 8 / sampleSizeInBits;
 int sample = (int) (samples[i] * (float) Math.pow(2, sampleSizeInBits - 1));
 for (int j = 0; j < sampleSizeInBits / 8; j++) {
 byteArray[sampleIndex + channelIndex + j] = (byte) (sample >>> (j * 8));
 }
 }
 return byteArray;
 }
 */

private byte[] toByteArray(float[] samplesLeft, float[] samplesRight, AudioFormat format) {
  int sampleSizeInBits = format.getSampleSizeInBits();
  int channels = format.getChannels();
  int bufferSize = (samplesLeft.length * sampleSizeInBits * channels) / 8;
  byte[] byteArray = new byte[bufferSize];
  int sampleIndex, channelIndex;
  for (int i = 0; i < samplesLeft.length; i++) {
    sampleIndex = i * sampleSizeInBits * channels / 8;
    int sampleLeft = (int) (samplesLeft[i] * (float) Math.pow(2, sampleSizeInBits - 1));
    int sampleRight = (int) (samplesRight[i] * (float) Math.pow(2, sampleSizeInBits - 1));
    for (int j = 0; j < sampleSizeInBits / 8; j++) {
      channelIndex = j;
      byteArray[sampleIndex + channelIndex] = (byte) (sampleLeft >>> (j * 8));
      channelIndex = j + sampleSizeInBits / 8;
      byteArray[sampleIndex + channelIndex] = (byte) (sampleRight >>> (j * 8));
    }
  }
  return byteArray;
}


public synchronized void samples(float[] sampL, float[] sampR)
{
  assert(sampL.length == sampR.length);

  for (int i = 0; i < sampL.length; i++)
  {
    if (counter + i >= leftAccu.length) {
      println("hit limit");
      createSample();
      break;
    }
    leftAccu[counter + i] = sampL[i];
    rightAccu[counter + i] = sampR[i];
  }

  counter = min(counter + sampL.length, leftAccu.length);
  //println("Total number of samples " + counter);

  left = sampL;
  right = sampR;
}

synchronized void draw()
{
}
}
