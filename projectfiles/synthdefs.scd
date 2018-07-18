
"ixi lang: loading synthdefs for the project: lofi".postln;


/*
if testing you need to use create the SynthDescLib:
SynthDescLib(\noise);
*/

SynthDef(\woodnoise, {arg out=0, amp=0.3, pan=0, sustain=0.5, t_trig=1, freq=100, rq=0.06;
	var env, signal;
	var rho, theta, b1, b2;
	b1 = 2.0 * 0.97576 * cos(0.161447);
	b2 = 0.9757.squared.neg;
	signal = SOS.ar(K2A.ar(t_trig), 1.0, 0.0, 0.0, b1, b2);
	//signal = RHPF.ar(signal, freq, rq);
	signal = Decay2.ar(signal, 0.4, 0.8, signal);
	signal = Limiter.ar(Resonz.ar(signal, freq, rq*0.5), 0.9);
	env = EnvGen.kr(Env.perc(0.00001, sustain, amp), doneAction:2);
	Out.ar(out, Pan2.ar(signal, pan)*env);
}).add(\lofi);

SynthDef(\xylonoise, { |out=0, freq=440, amp=0.3, sustain=0.5, pan=0, gate=1|
	var sig = StkBandedWG.ar(freq, instr:1, mul:3);
	var env = EnvGen.kr(Env.adsr(0.0001, sustain, sustain*0.8, 0.3), gate, doneAction:2);
	Out.ar(out, Pan2.ar(sig, pan, env * amp));
}).add(\lofi);

SynthDef(\sinesynth, { |out=0, freq=220, gate=4, amp=0.1, sustain=0.8, pan=0|
	var sig = SinOsc.ar(freq, phase:4, mul:2);
	var env = EnvGen.kr(Env.adsr(0.3, sustain, sustain, 0.6), gate, doneAction:2);
	Out.ar(out, Pan2.ar(sig, pan, env*amp));
}).add(\lofi);

SynthDef(\smooth, { |out, freq = 440, sustain = 1, gate=1, amp = 0.1|
    var sig;
    sig = SinOsc.ar(freq, 0, amp) * EnvGen.kr(Env.linen(0.05, sustain, 0.8), doneAction:2);
    Out.ar(out, sig ! 2)
}).add(\lofi);

SynthDef(\fmbass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq = freq / 4;
	freq = freq * ((0..1)/1 - 0.5 * 0.0007 + 1);
	env1 = EnvGen.kr(Env([0,1,0.051,0],[0.001,0.01,0.8], [4,-8]), 1);
	env2 = EnvGen.kr(Env([0,1,0.051,0],[0.005,0.5,1.5], [0,-8], releaseNode:2), 1);
	env3 = EnvGen.kr(Env([0,1,1,0],[0.01,0.01,0.2], [0,0,-4], releaseNode:2), gate);
	env4 = EnvGen.kr(Env([0,1,0],[0.002,2.8], [0,-4]), 1);
	env5 = EnvGen.kr(Env([0,1,1,0],[0.001,0.1,0.8], [4,0,-4], releaseNode:2), gate);
	env6 = EnvGen.kr(Env([0,1,0],[0.001,3.0], [0,-4]), 1);
	//freq = freq * EnvGen.kr(Env([1,1.002,0.998,1],[0.1,0.8]), 1);
	sig1 = SinOsc.ar(freq * 11 + 0) * env1; 
	sig2 = SinOsc.ar(freq * 6 * ( sig1 * 2.5 + 1 )) * env2;
	sig3 = SinOsc.ar(freq * 2 * 1 + 0) * env3;
	sig4 = SinOsc.ar(freq * 1 * ( sig3 * 2.5 + 1 ) + 0) * env4;
	sig5 = SinOsc.ar(freq * 1 * ( sig2 * 2.5 + 1 ) * (sig4 * 2.5 + 1)) * env5;
	sig6 = SinOsc.ar(freq * 2) * env6;
	//sig = sig2 + sig3 + sig4 + sig5 + sig6;
	sig = [sig1, sig2, sig3, sig4, sig5, sig6] * DC.ar([0.0, 0.0, 0.0,  0.0, 0.5, 0.5]);
	sig.debug("sig");
	sig = sig /2;
	sig = sig.flop.sum;
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.001,0,1,0.01, 1,-1) ),gate,doneAction:2);
	sig = sig * AmpComp.kr(freq);
	sig.debug("sigx");
	sig = Pan2.ar(sig, pan + [ 0, 0, 0, 0, 0, 0], amp).sum;
	Out.ar(out, sig);
}).add;

SynthDef(\softwgnoise, { |out=0, freq=440, gate=1, amp=0.3, sustain=0.5, pan=0|
	var sig = StkBandedWG.ar(freq, instr:1, mul:3);
	var env = EnvGen.kr(Env.adsr(0.0001, sustain, sustain, 0.3), gate, doneAction:2);
	Out.ar(out, Pan2.ar(sig, pan, env*amp));
}).add(\lofi);


