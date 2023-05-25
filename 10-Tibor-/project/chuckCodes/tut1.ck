// https://chuck.cs.princeton.edu/doc/learn/notes/

StifKarp inst => dac;

Scale sc; TimeGrid tg;

StifKarp inst => dac; //plucked string

tg.set( 1::minute/140/2, 8, 8 ); //140::bpm, 8 beats, 8 measures
[0, 3, 4, 1, 5, 4, 3, 3] @=> int bass[];


[0,2,3,1,4,2,6,3,4,4] @=> int mel[]; //sequence data
[0,2,4,5,7,9,11,12] @=> int major[]; //major scale

for (0=>int i; 1==1 ; i++) { //infinite loop
  //std.mtof( 48 + scale( mel[i%mel.cap()], major )) => inst.freq; //set the note
  std.mtof( 3*12 + 7 //3rd octave, 7 semitones from C
  + scale( mel[i%mel.cap()] +5, mel )) => inst.freq; //set the note

  inst.noteOn( 0.5 ); //play a note at half volume
  300::ms => now; //compute audio for 0.3 sec
}

fun int scale(int a, int sc[]) {
    sc.cap() => int n; //number of degrees in scale
    a/n => int o; //octave being requested, number of wraps
    a%n => a; //wrap the note within first octave
    
    if ( a<0 ) { //cover the negative border case
        a + 12 => a;
        o - 1 => o;
    }
    
    //each octave contributes 12 semitones, plus the scale
    return o*12 + sc[a];
}