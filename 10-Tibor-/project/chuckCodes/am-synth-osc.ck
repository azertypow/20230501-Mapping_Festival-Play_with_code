// Create an instance of the SineOscillator class.
SawOsc ugen => blackhole;

 Noise n  => ResonZ f => NRev r => Pan2 pan => Dyno d => dac;
//Noise n  => f;
FrencHrn fh => f;
Impulse imp => r;

.9 => fh.gain;
SinOsc modulator => blackhole;
36 => Std.mtof => fh.freq; // Play an unually low note

1500::ms => dur refreshMillis;

fun void foo( int a )
{
    while( true )
    {
        <<<36 => Std.mtof>>>;
        <<<a>>>;
        1 => fh.noteOn;  
        refreshMillis => now;
        1 => fh.noteOff;  
        refreshMillis * 3 => now;
    }
}

spork ~ foo( 1 );

//400 => fh.freq;

//d.limit(); 

0.2 => n.gain;
5 => f.Q;

1. => r.gain;

0.5 => r.mix;

0 => int device;

// Set the frequency of the carrier oscillator.
440.0 => ugen.freq;

// Set the frequency of the modulator.
3 => modulator.freq;

// This is the amplitude of the modulator. The amplitude of the modulator determines the extent of the amplitude modulation.
1. => modulator.gain;

// 
Hid hi;
HidMsg hidMsg;
OscMsg msg;

if ( !hi.openMouse(device) ) me.exit();
<<< "mouse " + hi.name() + " ready" >>>;

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
oin.addAddress("/xOffset, f");

while( true ) 
{
    //hi => now;
    
    while (oin.recv(msg)) {
        
        if (msg.address == "/scl")
        {
            //msg.getFloat(0) => f => fh.gain;
        }
        else if (msg.address == "/dotSizePct")
        {
            //map(msg.getFloat(0), 0., 1., 100., 65.) => f => fh.freq;
            //map(msg.getFloat(0), 0., 1., 0.1, .5) => f => fh.gain;
            
            //map(msg.getFloat(0), 0., 1., 200, 500)::ms => refreshMillis;
            //map(msg.getFloat(0), 0., 1., .2, .4) => r.mix;
           

        } else if (msg.address == "/mx") {
           map( msg.getFloat(0), 0., 1., 1000, 50 ) => f.freq;
           map( msg.getFloat(0), 0., 1., 1., 0.4 ) => f.gain;
           map( msg.getFloat(0), 0., 1., 1., 0.1 ) => fh.gain;

        } else if (msg.address == "/xOffset") {
            
        } else if  (msg.address == "/rad") {
            map( msg.getFloat(0), 0., 1., 1, 30 ) => modulator.freq;
        } 
        else if  (msg.address == "/cols") {
            //cmap( msg.getFloat(0), 0., 1., 1, 30 ) => modulator.freq;
            //1 => imp.next;
            //Math.random2f(-1.0,1.0) => pan.pan;     // (2) Random pan position

        } 
        
        

    }
    
    
    
    //100 + Math.fabs(Math.sin(now/second)) * 5000 => f.freq;
    
    
    // Modulate the amplitude of the carrier signal by the current sample of the modulator.
    0.5 * (modulator.last() + 1) => fh.gain;
    
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
