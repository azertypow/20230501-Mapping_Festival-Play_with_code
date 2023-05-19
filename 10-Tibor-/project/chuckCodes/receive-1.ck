// Make it like the wind

SinOsc s => JCRev r => dac;
.5 => s.gain;
.1 => r.mix;

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
            msg.getFloat(0) => f => s.freq;
        }
        else if (msg.address == "/amplitude")
        {
            // fetch the first data element as float
            msg.getFloat(0) => f => s.gain;
        }
        else if (msg.address == "/scl")
        {
            msg.getFloat(0) => f => s.gain;
        }
        
        // print
        <<< "got (via OSC):", msg.address, f >>>;
    }
}