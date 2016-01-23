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
s.options.inDevice = "Fireface 400 (CA4)";
//s.options.outDevice = "Fireface 400 (CA4)";
//Server.default.options.outDevice_("Soundflower (16ch)");
s.options.outDevice = "Soundflower (64ch)";
Server.default = Server.local;
s.reboot;
)

(
s.makeGui;
s.meter;
)


(
SynthDef(\cautious,{arg freq= 440,amp=0.2, ffreq=1000, pan=0.0;
var sound;
sound= LPF.ar(LFSaw.ar(freq),ffreq)*amp*EnvGen.ar(Env.perc, doneAction:2);
Out.ar(0,Pan2.ar(sound,pan))
}).add;
)


(
SynthDef(\arv, {arg matchlength=0.01, freeze=0;
	var concat, control, input, amp, env, freq, hasFreq;

	control = SoundIn.ar(0);
	amp = Amplitude.ar(control);

	# freq, hasFreq = Pitch.kr(control, ampThreshold: 0.02, median: 7);
	env = EnvGen.kr(Env.perc(2, 2), 1, doneAction:2);
	input = {
		      a = SinOsc.ar(100*[0.5,2,4,8], SinOsc.ar(80,5,10,15), LFNoise1.ar(3,6)).tanh;
	          9.do
	          {
			    a = AllpassL.ar(a, 2, {0.2.rand+0.1}!2, 85)
		      };
		      a.tanh;
	        } * env;

	concat = Concat.ar(control, input, 1.0, 1.0, matchlength, freeze, 0.0, 1.0, 0.0, 0.0);
	Out.ar(0, Pan2.ar(AllpassL.ar(10*concat*amp, 1, 0.2, 4), 0.0))
}).add;
)


(
SynthDef(\arv, {arg matchlength=0.01, freeze=0, pan=0.0, ampScale=0.2, ffreq=1000;
	var concat, control, input, amp, env, freq, hasFreq;

	control = SoundIn.ar(0);
	amp = Amplitude.ar(control);

	# freq, hasFreq = Pitch.kr(control, ampThreshold: 0.02, median: 7);
	env = EnvGen.ar(Env.linen, doneAction:2);

	input = {
		LPF.ar(
			LFSaw.ar(freq), ffreq)*ampScale*env};
	concat = Concat.ar(control, input, 1.0, 1.0, matchlength, freeze, 0.0, 1.0, 0.0, 0.0);

	Out.ar(0, Pan2.ar(AllpassL.ar(10*concat*amp, 1, 0.2, 4), 0.0)*env)
}).add;
)

(
SynthDef(\arv, {arg matchlength=0.01, freeze=0;
	var concat, control, input, amp, env, freq, hasFreq;

	control = SoundIn.ar(0);
	amp = Amplitude.ar(control);

	# freq, hasFreq = Pitch.kr(control, ampThreshold: 0.02, median: 7);
	env = EnvGen.kr(Env.perc(2, 2), 1, doneAction:2);

	input = {a=
		VarSaw.ar(freq * [0.5,2,4],
			SinOsc.ar(0.1,5,10,15),
			VarSaw.ar(3,6,10)).tanh;
		9.do{a=AllpassL.ar(a,1,{0.2.rand+0.1}!2,6)};a.asin} * env;

	concat = Concat.ar(control, input, 1.0, 1.0, matchlength, freeze, 0.0, 1.0, 0.0, 0.0);
	Out.ar(0, Pan2.ar(AllpassL.ar(10*concat*amp, 1, 0.2, 4), 0.0))
}).add;
)

(
SynthDef(\arv, {arg matchlength=0.01, freeze=0;
	var concat, control, input, amp, env, freq, hasFreq;

	control = SoundIn.ar(0);
	amp = Amplitude.ar(control);

	# freq, hasFreq = Pitch.kr(control, ampThreshold: 0.02, median: 7);
	env = EnvGen.kr(Env.perc(1, 2), 1, doneAction:2);

	input = {a=
		VarSaw.ar(freq * [0.2,0.6,0.8],
			SinOsc.ar(0.1,5,10,15),
			VarSaw.ar(3,6,10)).tanh;
		9.do{a=AllpassL.ar(a,1,{0.2.rand+0.1}!2,6)};a.asin} * env;

	concat = Concat.ar(control, input, 1.0, 1.0, matchlength, freeze, 0.0, 1.0, 0.0, 0.0);
	Out.ar(0, Pan2.ar(AllpassL.ar(10*concat*amp, 1, 0.2, 4), 0.0) *env)
}).add;
)

(
SynthDef(\arv, {arg matchlength=0.01, freeze=0;
	var concat, control, input, amp, env, freq, hasFreq;

	control = SoundIn.ar(0);
	amp = Amplitude.ar(control);

	# freq, hasFreq = Pitch.kr(control, ampThreshold: 0.02, median: 7);
	env = EnvGen.kr(Env.perc(1, 3), 1, doneAction:2);

	input = {a=
		VarSaw.ar(freq * [0.4,0.8],
			SinOsc.ar(0.1,5,10,15),
			VarSaw.ar(3,6,10)).tanh;
		9.do{a=AllpassL.ar(a,1,{0.2.rand+0.1}!2,6)};a.asin} * env;

	concat = Concat.ar(control, input, 1.0, 1.0, matchlength, freeze, 0.0, 1.0, 0.0, 0.0);
	Out.ar(0, Pan2.ar(AllpassL.ar(10*concat*amp, 1, 0.2, 4), 0.0) *env)
}).add;
)

(
SynthDef(\arv, {arg matchlength=0.01, freeze=0;
	var concat, control, input, amp, env, freq, hasFreq;

	control = SoundIn.ar(0);
	amp = Amplitude.ar(control);

	# freq, hasFreq = Pitch.kr(control, ampThreshold: 0.02, median: 7);

	env = EnvGen.kr(Env.linen(), 1, doneAction:2);
	input = {a=
		SinOsc.ar(freq * [0.4,0.8],
			VarSaw.ar(0.1,5,10,15),
			VarSaw.ar(3,6,10)).tanh;
		9.do{a=AllpassL.ar(a,1,{0.2.rand+0.1}!2,6)};a.asin} * env;

	concat = Concat.ar(control, input, 1.0, 1.0, matchlength, freeze, 0.0, 1.0, 0.0, 0.0);
	Out.ar(0, Pan2.ar(AllpassL.ar(10*concat*amp, 1, 0.2, 2), 0.0) *env)
}).add;
)

(
SynthDef(\arv, {arg matchlength=0.01, freeze=0;
	var concat, control, input, amp, env, freq, hasFreq;

	control = SoundIn.ar(0);
	amp = Amplitude.ar(control);

	# freq, hasFreq = Pitch.kr(control, ampThreshold: 0.02, median: 7);
	env = EnvGen.kr(Env.perc(2, 2), 1, doneAction:2);

    input = {a=
		Blip.ar(freq,
			LFNoise1.ar(0.1,5),
			LFNoise1.ar(3,6)).tanh;
		9.do{a=AllpassL.ar(a,2,{0.2.rand+0.1}!2,5)};a.tanh} * env;

	concat = Concat.ar(control, input, 1.0, 1.0, matchlength, freeze, 0.0, 1.0, 0.0, 0.0);
	Out.ar(0, Pan2.ar(AllpassL.ar(10*concat*amp, 1, 0.6, 30), 0.0) *env)
}).add;
)

(
SynthDef(\arv, {arg matchlength=0.01, freeze=0;
	var concat, control, input, amp, env, freq, hasFreq;

	control = SoundIn.ar(0);
	amp = Amplitude.ar(control);

	# freq, hasFreq = Pitch.kr(control, ampThreshold: 0.02, median: 7);

	env = EnvGen.kr(Env.linen(), 1, doneAction:2);

    input = {a=
		Blip.ar(freq,
			LFNoise1.ar(0.1,5),
			LFNoise1.ar(3,6)).tanh;
		9.do{a=AllpassL.ar(a,2,{0.2.rand+0.1}!2,5)};a.tanh} * env;

	concat = Concat.ar(control, input, 1.0, 1.0, matchlength, freeze, 0.0, 1.0, 0.0, 0.0);
	Out.ar(0, Pan2.ar(AllpassL.ar(10*concat*amp, 1, 0.6, 20), 0.0) *env)
}).add;
)

(
SynthDef(\arv, {arg matchlength=0.01, freeze=0;
	var concat, control, input, amp, env, freq, hasFreq;

	control = SoundIn.ar(0);
	amp = Amplitude.ar(control);

	# freq, hasFreq = Pitch.kr(control, ampThreshold: 0.02, median: 7);
	env = EnvGen.kr(Env.linen(), 1, doneAction:2);

	input = {a=
		Blip.ar(freq*[0.2,0.6,1],
			LFNoise1.ar(0.1,5),
			LFNoise1.ar(3,6)).tanh;
		9.do{a=AllpassL.ar(a,2,{0.2.rand+0.1}!2,5)};a.tanh} * env;

	concat = Concat.ar(control, input, 1.0, 1.0, matchlength, freeze, 0.0, 1.0, 0.0, 0.0);
	Out.ar(0, Pan2.ar(AllpassL.ar(10*concat*amp, 1, 0.6, 20), 0.0) *env)
}).add;
)


(
SynthDef(\arv, {arg matchlength=0.01, freeze=0;
	var concat, control, input, amp, env, freq, hasFreq;

	control = SoundIn.ar(0);
	amp = Amplitude.ar(control);

	# freq, hasFreq = Pitch.kr(control, ampThreshold: 0.02, median: 7);
	env = EnvGen.kr(Env.linen(), 1, doneAction:2);

	input = {a=
		Blip.ar(freq*[0.2,0.6],
			LFNoise1.ar(0.1,5),
			LFNoise1.ar(3,6)).tanh;
		9.do{a=AllpassL.ar(a,2,{0.2.rand+0.1}!2,5)};a.tanh} * env;

	concat = Concat.ar(control, input, 1.0, 1.0, matchlength, freeze, 0.0, 1.0, 0.0, 0.0);
	Out.ar(0, Pan2.ar(AllpassL.ar(10*concat*amp, 1, 0.6, 20), 0.0) *env)
}).add;
)

(
SynthDef(\arv, {arg matchlength=0.01, freeze=0;
	var concat, control, input, amp, env, freq, hasFreq;

	control = SoundIn.ar(0);
	amp = Amplitude.ar(control);

	# freq, hasFreq = Pitch.kr(control, ampThreshold: 0.02, median: 7);
	env = EnvGen.kr(Env.linen(), 1, doneAction:2);

	input = {a=
		SinOsc.ar(freq*[0.2,0.6],
			LFNoise1.ar(0.1,5),
			LFNoise1.ar(3,6)).tanh;
		9.do{a=AllpassL.ar(a,2,{0.2.rand+0.1}!2,5)};a.tanh} * env;

	concat = Concat.ar(control, input, 1.0, 1.0, matchlength, freeze, 0.0, 1.0, 0.0, 0.0);
	Out.ar(0, Pan2.ar(AllpassL.ar(10*concat*amp, 1, 0.6, 20), 0.0) *env)
}).add;
)


(
SynthDef(\arv, {arg matchlength=0.01, freeze=0;
	var concat, control, input, amp, env, freq, hasFreq;

	control = SoundIn.ar(0);
	amp = Amplitude.ar(control);

	# freq, hasFreq = Pitch.kr(control, ampThreshold: 0.02, median: 7);
	env = EnvGen.kr(Env.linen(), 1, doneAction:2);

	input = {a=
		SinOsc.ar(freq*[0.2,0.6],
			SinOsc.ar(0.1,5),
			SinOsc.ar(3,6)).tanh;
		9.do{a=AllpassL.ar(a,2,{0.2.rand+0.1}!2,5)};a.tanh} * env;

	concat = Concat.ar(control, input, 1.0, 1.0, matchlength, freeze, 0.0, 1.0, 0.0, 0.0);
	Out.ar(0, Pan2.ar(AllpassL.ar(10*concat*amp, 1, 0.6, 20), 0.0) *env)
}).add;
)


(
SynthDef(\arv, {arg matchlength=0.01, freeze=0;
	var concat, control, input, amp, env, freq, hasFreq;

	control = SoundIn.ar(0);
	amp = Amplitude.ar(control);

	# freq, hasFreq = Pitch.kr(control, ampThreshold: 0.02, median: 7);
	env = EnvGen.kr(Env.linen(), 1, doneAction:2);

	input = {a=
		SinOsc.ar(freq*[1],
			SinOsc.ar(0.1,5),
			SinOsc.ar(3,6)).tanh;
		9.do{a=AllpassL.ar(a,2,{0.2.rand+0.1}!2,5)};a.tanh} * env;

	concat = Concat.ar(control, input, 1.0, 1.0, matchlength, freeze, 0.0, 1.0, 0.0, 0.0);
	Out.ar(0, Pan2.ar(AllpassL.ar(10*concat*amp, 1, 0.6, 20), 0.0) *env)
}).add;
)

(
SynthDef(\arv, {arg matchlength=0.01, freeze=0;
	var concat, control, input, amp, env, freq, hasFreq;

	control = SoundIn.ar(0);
	amp = Amplitude.ar(control);

	# freq, hasFreq = Pitch.kr(control, ampThreshold: 0.02, median: 7);
	env = EnvGen.kr(Env.linen(), 1, doneAction:2);

	input = {a=
		SinOsc.ar(freq*[0.4,0.8,8],
			SinOsc.ar(0.1,5),
			SinOsc.ar(3,6)).tanh;
		9.do{a=AllpassL.ar(a,2,{0.2.rand+0.1}!2,5)};a.tanh} * env;

	concat = Concat.ar(control, input, 1.0, 1.0, matchlength, freeze, 0.0, 1.0, 0.0, 0.0);
	Out.ar(0, Pan2.ar(AllpassL.ar(10*concat*amp, 1, 0.6, 20), 0.0) *env)
}).add;
)

(
SynthDef(\arv, {arg matchlength=0.01, freeze=0;
	var concat, control, input, amp, env, envTwo, freq, hasFreq;

	control = SoundIn.ar(0);
	amp = Amplitude.ar(control);

	# freq, hasFreq = Pitch.kr(control, ampThreshold: 0.02, median: 7);
	//env = EnvGen.kr(Env.linen(), 1, doneAction:2);
	envTwo = env = EnvGen.kr(Env.perc(), 1, doneAction:2);

	input = {a=
		SinOsc.ar(freq*[0.2,0.6,1],
			SinOsc.ar(0.1,5),
			SinOsc.ar(3,6)).tanh;
		9.do{a=AllpassL.ar(a,2,{0.2.rand+0.1}!2,5)};a.tanh} * env;

	concat = Concat.ar(control, input, 1.0, 1.0, matchlength, freeze, 0.0, 1.0, 0.0, 0.0);
	Out.ar(0, Pan2.ar(AllpassL.ar(10*concat*amp, 1, 0.6, 20), 0.0) *env)
}).add;
)



Pdef(\a, Pbind(\instrument, \arv));
Pdef(\a).play;


(Pdef(\a, Pbind( \instrument, \arv)));

(
Pdef(\a,
	Pbind(
	\instrument, \arv,
	\matchlength, Prand([0.01,0.03,0.05,0.07,0.09,0.10,0.5,1], inf),
	\ffreq, Pseq([4,00,600,800,1000,1200,1400,1600,1800], inf);
    ))
);


(Pdef(\b, Pbind( \instrument, \arvb)));
Pdef(\b).play;
Pdef(\b).stop;


Pdef(\a).play;
Pdef(\a).stop;