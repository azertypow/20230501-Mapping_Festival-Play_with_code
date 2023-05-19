// name: frenchrn-algo2.ck
// desc: FM 4 Operator (TX81Z Algorithm 2) French Horn Demo
//
// author: Perry R. Cook
// date: June 2021, for REPAIRATHON 2021
//       needs chuck 1.4.1.0 or above

// patch
FrencHrn f => NRev r => dac;
// turn down the volume a bit
.5 => r.gain;

// reverb mix
0.10 => r.mix;

// to learn more about FrencHrn, uncomment this:
//f.apropos();

36 => Std.mtof => f.freq; // Play an unually low note
1 => f.noteOn;  

20* second => now;

