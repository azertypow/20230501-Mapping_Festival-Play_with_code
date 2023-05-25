// Make it like the wind
//Oscillator Frequency: You can connect the position or velocity of a particle to the frequency of an oscillator, such as a sine, square, sawtooth, or triangle wave. This can create a sense of motion in the sound.
//Filter Cutoff and Resonance: Consider using a filter (like a low-pass, high-pass, or band-pass filter) and controlling its cutoff frequency and resonance based on the particle's parameters. For example, particles with higher velocity or energy could result in a higher cutoff frequency.
//Volume/Amplitude: The volume of the sound could correspond to the distance of a particle from a certain point. Closer particles could be louder, and those further away could be quieter, creating a sense of space and depth.
//Panning: If the particle system is 2D or 3D, you could use the particle's position to control the stereo panning of the sound, providing a spatial dimension to the soundscape.
//Granular Synthesis: Granular synthesis involves the superposition of small fragments of sound, or "grains," to create complex sounds. Each particle could trigger a grain, with properties of the grain (like pitch, volume, or grain size) related to the properties of the particle.
//Envelope Parameters: You can use the particle's lifetime or state to influence the envelope of the sound (Attack, Decay, Sustain, Release - ADSR). For example, newly created particles could have a quick attack and longer sustain, whereas particles that are about to disappear could have a longer release.
//Reverb/Delay Effects: You can use reverb or delay effects to create a sense of space or environment. The parameters of these effects could be manipulated based on global properties of the system, such as the overall energy or number of particles.

SqrOsc o => dac;




SqrOsc o2 => blackhole;
.1 => o.gain;
.1 => o2.gain;

120 => o.freq;
//220 => o2.freq;

FrencHrn fh => JCRev r => Pan2 p => blackhole;
.5 => fh.gain;
.4 => r.mix;

1000::ms => dur refreshMillis;

Noise n => JCRev nr => Pan2 np => blackhole;
.2 => n.gain;
.4 => nr.mix;

SinOsc s => JCRev sr => Pan2 sp => blackhole;
.2 => s.gain;
.4 => sr.mix;





//FrencHrn f => NRev r => dac;
// turn down the volume a bit
//.5 => r.gain;

// reverb mix
//0.10 => r.mix;

//36 => Std.mtof => fh.freq; // Play an unually low note
//1 => fh.noteOn;  

//20* second => now;

// create our OSC receiver
OscIn oin;
// use port 6449 (or whatever)
6449 => oin.port;
// create an address in the receiver, expect two floats
oin.addAddress("/frequency, f");
oin.addAddress("/amplitude, f");
oin.addAddress("/scl, f");
oin.addAddress("/cols, f");
oin.addAddress("/rows, f");
oin.addAddress("/dotSizePct, f");
oin.addAddress("/mx, f");
oin.addAddress("/my, f");
oin.addAddress("/aFillMix, f");
oin.addAddress("/bgFill, f");
oin.addAddress("/offScl, f");
oin.addAddress("/rad, f");

while (true)
{
    // wait for event to arrive
    oin => now;
    
    // grab the next message from the queue. 
    OscMsg msg;
    while (oin.recv(msg))
    {
        float f;
        
        if (msg.address == "/frequency")
        {
            // fetch the first data element as float
            msg.getFloat(0) => f => fh.freq;
        }
        else if (msg.address == "/amplitude")
        {
            // fetch the first data element as float
            msg.getFloat(0) => f => fh.gain;
        }
        else if (msg.address == "/scl")
        {
            msg.getFloat(0) => f => fh.gain;
        }
        else if (msg.address == "/dotSizePct")
        {
            map(msg.getFloat(0), 0., 1., 100., 65.) => f => fh.freq;
            map(msg.getFloat(0), 0., 1., 0.1, .5) => f => fh.gain;
            
            map(msg.getFloat(0), 0., 1., 200, 500)::ms => refreshMillis;
            map(msg.getFloat(0), 0., 1., .2, .4) => r.mix;
        } else if (msg.address == "/mx") {
            map(msg.getFloat(0), 0., 1., -1., 1.) => p.pan;
        }
        // Adjust the mappings in the OSC message handler
        else if (msg.address == "/cols")
        {
            map(msg.getFloat(0), 0., 1., 0.1, 0.4) => nr.mix;
        }
        else if (msg.address == "/rows")
        {
            map(msg.getFloat(0), 0., 1., 200., 600.) => s.freq;
        }
        else if (msg.address == "/my")
        {
            //map(msg.getFloat(0), 0., 1., 0.1, 0.9) => nr.time;
        }
        else if (msg.address == "/aFillMix")
        {
            map(msg.getFloat(0), 0., 1., 0.1, 0.5) => n.gain;
        }
        else if (msg.address == "/bgFill")
        {
            map(msg.getFloat(0), 0., 1., 36., 72.) => Std.mtof => fh.freq;
        }
        else if (msg.address == "/offScl")
        {
            //map(msg.getFloat(0), 0., 1., 0.1, 0.9) => sr.damp;
        }
        else if (msg.address == "/rad")
        {
            map(msg.getFloat(0), 0., 1., -1., 1.) => sp.pan;
        }
        
        // print
        <<< "got (via OSC):", msg.address, f >>>;
    }
}


fun float map(float value, float inMin, float inMax, float outMin, float outMax)
{
    return (value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
}