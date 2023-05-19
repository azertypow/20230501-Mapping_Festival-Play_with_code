// Creating the UGens
Noise noise => LPF lpf => ADSR envelope => dac;

// Setting up the noise generator
0.5 => noise.gain;

// Setting up the low pass filter
1000 => lpf.freq; // Adjust this value for desired wind sound
0.1 => lpf.Q; // Adjust this value for desired wind resonance

// Setting up the envelope
envelope.set(2.0, 1.0, 0.7, 4.0); // attack, decay, sustain, release

// Applying the envelope and playing the wind sound
envelope.keyOn();
5::second => now; // Play the sound for 5 seconds
envelope.keyOff();