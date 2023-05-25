// Make it like the wind

FrencHrn fh => JCRev r => Pan2 p => dac;
.9 => fh.gain;
.4 => r.mix;

1000::ms => dur refreshMillis;

//FrencHrn f => NRev r => dac;
// turn down the volume a bit
//.5 => r.gain;

// reverb mix
//0.10 => r.mix;

36 => Std.mtof => fh.freq; // Play an unually low note
1 => fh.noteOn;  

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

fun void foo( int a )
{
    while( true )
    {
        <<<36 => Std.mtof>>>;
        <<<a>>>;
        1 => fh.noteOn;  
        refreshMillis => now;
        1 => fh.noteOff;  
        refreshMillis * 2 => now;
    }
}

spork ~ foo( 1 );

// infinite event loop
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
        
        // print
        <<< "got (via OSC):", msg.address, f >>>;
    }
}


fun float map(float value, float inMin, float inMax, float outMin, float outMax)
{
    return (value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
}








