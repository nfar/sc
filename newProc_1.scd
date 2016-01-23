s.recSampleFormat_("int16")
s.record
s.stopRecording
Server.killAll;

ServerOptions.inDevices
ServerOptions.outDevices

input:
Server.default.options.inDevice_("Fireface 400 (CA4)")

output:
Server.default.options.outDevice_("Soundflower (2ch)")


(
s = Server.local;
s.options.memSize_(2097152);
s.options.sampleRate = 44100;
//s.options.inDevice = "Fireface 400 (CA4)";
//s.options.outDevice = "Fireface 400 (CA4)";
Server.default = Server.local;
s.reboot;
)

(
s.makeGui;
s.meter;
)

(
SynthDef(\arv, {arg matchlength=0.01, freeze=0;
	var concat, control, input, amp, env, freq, hasFreq;

	control = SoundIn.ar(0);
	amp = Amplitude.ar(control);

	# freq, hasFreq = Pitch.kr(control, ampThreshold: 0.02, median: 7);

	env = EnvGen.kr(Env.perc(2, 2), 1, doneAction:2);

	input = {
		a=VarSaw.ar(freq * [0.5,2,4],
			SinOsc.ar(0.1,5,10,15),
			VarSaw.ar(3,6,10)).tanh;
		    9.do{a=AllpassL.ar(a,1,{0.2.rand+0.1}!2,6)};a.asin} * env;
	        concat = Concat.ar(control, input, 1.0, 1.0, matchlength, freeze, 0.0, 1.0, 0.0, 0.0);
	Out.ar(0, Pan2.ar(AllpassL.ar(10*concat*amp, 1, 0.2, 4), 0.0))
}).add;
)


(Pdef(\a, Pbind( \instrument, \arv)));

Pdef(\a).play;
Pdef(\a).stop;



(
SynthDef(\inDelay, { arg out=0;
     var concat, control, input, env;

     env = EnvGen.kr(Env.perc(2, 2), 1, doneAction: 2);

     control=GVerb.ar(
		BBandStop.ar(
			VarSaw.ar(
				SinOsc.ar(6,0,5,
					SinOsc.ar([0.5,0.08],0,50,160).round([65,35,100])),0,
				SinOsc.ar(0.2,0,0.5,
					Formlet.ar(
						VarSaw.ar(8,0,0.2,0.5)))))/4,80) * env;

       input = SoundIn.ar(1);
       concat = Concat.ar(control, input, 4.0, 4.0, 4.0, 0.1, 0, 0.5, 1.0, 0.5, 0.0);
       Out.ar(out, Splay.ar(concat * env, 0.0))
}).add
)

(
Pdef(\b,
    Pbind(
    \instrument, \inDelay
    ))
    )

(
Pdef(\b).play;
Pdef(\a).stop;
)

(
Pdef(\b).stop;
Pdef(\a1).stop;
h.free;
)

///////////////////////////////////////////////////////////////////////////////////


(
~length = 6;
c = Buffer.alloc( s, s.sampleRate * ~length );


SynthDef("grainySoundin2", {arg out=0, out1=2, trate=20, sustain=5, nrate=1;
	   var dur, grains, env, rec, in, z, d;
	   d = { Dwhite(0.1,0.4,1, 1.5, 1.05, 0.98, 1.01, 0.87, 0.11, 0.08, 086,0.01,0.02,0.03,0.025,0.04,0.4,0.0114,0.113,0.18)};
	   z = {Dseq([Dseq(0.1, 1 + d.value, Diwhite(20, 40)), Dgeom(1, 1 - d.value, Dgeom(20, 25))])
	   };
	   in = SoundIn.ar(0);
                rec  = BufWr.ar( in, c, Phasor.ar(0, BufRateScale.kr(0) * nrate, 0, BufFrames.kr(0)));
       env = EnvGen.kr(Env.perc(4), doneAction: 2);
	   grains = GrainBuf.ar(2, GVerb.ar(LFPar.ar(trate)),
	   sndbuf: c,
	   pos: Dseq(d.dup(2,2.1,2.3,2.34,2.5,1.88,1.87,1.86,4), inf),
	   rate: Drand([1], inf),
	   dur: Dseq([ 60, 120, 180, 220, 300, 400, 700, 45, 260, 240, 200, d.value, z.value], inf) / trate,
	   pan: Dseq([1, 1, 1, z.value, 0.5, 0.2, 0.1, 0, 0, 0], inf) * 2 - 1,
	   envbufnum: -1);
	   out = Out.ar([out,out1], grains * env);
}).add;



~length = 6;
b = Buffer.alloc( s, s.sampleRate * ~length );

SynthDef("grainySoundin", {arg out=0, out1=2, trate=100, sustain=5, nrate=1;
	   var dur, grains, env, rec, in, z, d;
	   d = {
		Dwhite
		(0.1,0.4,1, 1.5, 1.05, 0.98, 1.01, 0.87,
			0.11, 0.08, 086,0.01,0.02,0.03,0.025,
			0.04,0.4,0.0114,0.113,0.18)};
	   z = {Dseq([
		Dseq(0.1, 1 + d.value,
			Diwhite(20, 40)),
		Dgeom(1, 1 - d.value,
			Dgeom(20, 25))])
	   };
	   in = SoundIn.ar(0);

       rec  = BufWr.ar(in, b,
		Phasor.ar(0,
			BufRateScale.kr(0) * nrate, 0,
			BufFrames.kr(0)));
       env = EnvGen.kr(Env.perc(2), doneAction: 2);
	   grains =
	   TGrains.ar(2,
		CombL.ar(
	    SinOsc.ar(trate)),
	    bufnum: b,
	    centerPos: Dseq(d.dup(2,2.1,2.3,2.34,2.5,1.88,1.87,1.86,4), inf),
	    rate: Drand([-0.2, 0.2, 0.6], inf),
	    dur: Dseq([ 60, 120, 180, 220, 300, 400, 700, 45, 260, 240, 200,
			d.value,
			z.value],
			inf) / trate,
	    pan: Dseq([1, 1, 1, z.value, 0.5, 0.2, 0.1, 0, 0, 0], inf) * 2 - 1,
	    amp: Dseq([1, 0, 0, 2, 1.0, 1, 0.1, 0.1], inf));
	    out = Out.ar([out,out1], grains * env);
}).add
)


(
Pdef(\d1, Pbind(\instrument, \grainySoundin));
Pdef(\d, Pbind(\instrument, \grainySoundin2));
)

(
Pdef(\d).play;
Pdef(\d1).play;
)


(
SynthDef(\loop3, {|out= 0, fb= 0.9, inbus, outbus|
        var adc= SoundIn.ar(0);
        var delread= DelayN.ar(InFeedback.ar(inbus), 0.5, 0.5);
        var snd= adc+delread;
        Out.ar(out, Pan2.ar(snd));
        Out.ar(outbus, snd*fb);
}).add;
)

~fbbusin= Bus.audio(s, 1);
~fbbusout= Bus.audio(s, 1);
CmdPeriod.doOnce({~fbbusin.free; ~fbbusout.free});
a= Synth(\loop3, [\inbus, ~fbbusin, \outbus, ~fbbusout])
a.set(\inbus, ~fbbusout)
a.set(\inbus, 99)
a.set(\inbus, 0)
a.set(\outbus, 0)
a.set(\outbus, ~fbbusout, \inbus, ~fbbusin)


NdefMixer(s);

(
Tdef(\c, {
	loop {
		Ndef(\x).fadeTime = rrand(0.1, 5);
		Ndef(\x).send([\freq, exprand(75, 4000), \detune, [0.0, 4.0].choose.rand]);
		2.wait;
	}
})
)
Tdef(\c).play;


(Ndef(\x, {|freq=200, detune=0| a=LFNoise1.ar(freq * [detune, 1 - detune] * 0.2, Ndef(\x).ar*LFNoise1.ar(0.1,5),SinOsc.ar(freq,6)).tanh;9.do{AllpassL.ar(a,2,{0.2.rand+0.1}!2,5)};a.tanh}));



//////////////////////////////////////////////////////////////////////////////////////////

(
SynthDef(\bitty, { arg out=0;
	var env, synth;

         env = EnvGen.kr(Env.linen(2, 2), 1, doneAction:2);

         synth = {a=LFTri;LFPulse.ar(a.ar(Duty.ar(1/8,0,Dswitch([Dseq((4..18),4), Dseq([60,1,2],[4,3])]/2,Dseq([0,1],99))*99), 0, 3e3,300), mul: 0.1)};

         Out.ar(out, Pan2.ar(synth * env));
}).add
)

(
Pdef(\e,
        Pbind(\instrument, \bitty
        ))
        )

Pdef(\e).play;
Pdef(\e).stop;



////////////////////////////////////////

(
SynthDef(\bitty2, { arg out=0;
	var env, synth;

         env = EnvGen.kr(Env.linen(2, 2), 1, doneAction:2);

         synth = {a=LFTri; LFPar.ar(a.ar(Duty.ar(1/8,0,Dswitch([Dseq((4..8),4),Dseq([100,1,2],[4,3])]/2,Dseq([0,1],99))*99), 0, 3e3, 300),  mul:0.0045)};

         Out.ar(out, Pan2.ar(synth * env));
}).add
)

(
Pdef(\f,
        Pbind(\instrument, \bitty2
        ))
        )

Pdef(\f).play;
Pdef(\f).stop;      