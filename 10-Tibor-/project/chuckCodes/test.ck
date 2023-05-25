// The OSC receiver event loop
OscIn oin;
6449 => oin.port;  // port where ChucK is listening

oin.addAddress("/noise, f");

OscMsg msg;

SinOsc s => dac;

while(true) {
    
    while (oin.recv(msg)) {
        if (msg.address == "/noise") {
            msg.getFloat(0) * 10000 => s.freq;
            //msg.getFloat(0) * 100  => s.gain;

        }
    }
    
    1::samp => now;
}