// Create an instance of the SineOscillator class.
SinOsc ugen => blackhole;
Noise n => NRev r => BiQuad f => dac;
SinOsc modulator => blackhole;

// set the filter's pole radius
.98 => f.prad; 
// set equal gain zeros
2 => f.eqzs;
// initialize float variable
.25 => f.gain;

//2 => f.Q;

1. => r.gain;

0.8 => r.mix;

// 0 - apple trackpad probably
// 1 - mouse probably
0 => int device;


// Set the frequency of the carrier oscillator.
440.0 => ugen.freq;

// Set the frequency of the modulator.
0.1 => modulator.freq;

// This is the amplitude of the modulator. The amplitude of the modulator determines the extent of the amplitude modulation.
1. => modulator.gain;

// 
Hid hi;
HidMsg msg;

if ( !hi.openMouse(device) ) me.exit();
<<< "mouse " + hi.name() + " ready" >>>;

// This is the main loop where the amplitude modulation takes place.
while( true ) 
{
    //hi => now;
    
    while ( hi.recv( msg ) ) {
        
        if ( msg.isMouseMotion() ) {
            
            // Map the amplitude
            map(msg.scaledCursorX, 0., 1., 0.1, 10.) => modulator.freq;
            map(msg.scaledCursorY, 0., 1., 120, 1000) => ugen.freq;
            map(msg.scaledCursorY, 0., 1., 0, 800) => f.pfreq;

        }
        
        //<<< msg >>>;
        //printHidMsg( msg );
    }
    //100 + Math.fabs(Math.sin(now/second)) * 5000 => f.freq;
    
    
    // Modulate the amplitude of the carrier signal by the current sample of the modulator.
    //0.5 * (modulator.last() + 1) => ugen.gain;
    
    // Advance time by one sample.
    1::samp => now;
}

fun void printHidMsg(HidMsg msg)
{
    <<< "Which:", msg.which >>>;
    <<< "Delta X:", msg.deltaX >>>;
    <<< "Delta Y:", msg.deltaY >>>;
    <<< "Mouse motion: ", msg.isButtonDown() >>>;
    <<< "is Button up ", msg.isButtonUp() >>>;
    <<< "is Button down", msg.isButtonDown() >>>;   
    <<< "mouse normalized position --", "x:", msg.scaledCursorX, "y:", msg.scaledCursorY >>>;
}

fun float map(float value, float inMin, float inMax, float outMin, float outMax)
{
    return (value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
}
