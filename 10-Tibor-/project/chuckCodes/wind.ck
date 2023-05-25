// Create noise generator, filters, and gain for volume control
Noise noise => LPF filter => Gain gain => dac;

// Set initial values
.2 => gain.gain;
0 => int lastChange;

// Filter settings for the "alien wind" sound
440.0 => filter.freq;

// Function for random filter frequency within a specified range
fun float randomFreq() {
    return Std.rand2f(20.0, 1000.0);
}

// Main loop
while(true) {
    // Every second, check if it's time to change the sound
    1::second => now;
    if(++lastChange > Std.rand2(5, 15)) {
        // Reset the counter
        0 => lastChange;

        // Change filter parameters
        randomFreq() => filter.freq;
    }
}