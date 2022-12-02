// TUTORIAL: HOW TO MAKE A RAIN SYNTHESIZER

// 1. Find out, how many raindrops fall to the ground per second, based on the mm-data from DWD and the weight of one drop
(
{
	arg mm = 2.5, dropweight = 0.03;
	var raindrops;
	raindrops = ((1000*mm) / dropweight) / (60*60);

};
)

// 2. Choose an Oscillator that triggers n times per second. Here: Dust2.ar()
(
{
	arg mm = 2.5, dropweight = 0.03;
	var raindrops;
	raindrops = ((1000*mm) / dropweight) / (60*60);

	Dust2.ar(raindrops);

}.play;
)


// 3. Put everything inside a SynthDef and add effects (Reverb, High- & Lowpassfilter)

(
SynthDef.new(\rain, {
	arg mm = 2.5, dropweight = 0.03, out_bus=0, amp = 2;
	var raindrops, sig;
	raindrops = ((1000*mm) / dropweight) / (60*60);

	sig = Dust2.ar(raindrops);

	sig = GVerb.ar(sig, roomsize: 1, revtime: 0.3, inputbw: 0.5, drylevel: 0.9, earlyreflevel:0.2, taillevel: 0.9);

	sig = LPF.ar(sig, 200, mul: 2);
	sig = HPF.ar(sig, 2000, mul: 2);

	sig = sig*amp;

	Out.ar(out_bus,[sig,sig]);
}).add;
)

Synth(\rain);

// 4. Add a Noise Oscillator with Effects to make it feel more rainy and mix it


(
SynthDef.new(\rain, {
	arg mm = 2.5, dropweight = 0.03, out_bus=0, amp = 2;
	var raindrops, sig, sig_rain, ampnoise;

	raindrops = ((1000*mm) / dropweight) / (60*60);

	sig = Dust2.ar(raindrops);

	sig = GVerb.ar(sig, roomsize: 1, revtime: 0.3, inputbw: 0.5, drylevel: 0.9, earlyreflevel:0.2, taillevel: 0.9);

	sig = LPF.ar(sig, 200, mul: 2);
	sig = HPF.ar(sig, 2000, mul: 2);

	sig = sig*amp;

	ampnoise = mm.linlin(0,100,0.001,0.9);
	sig_rain = GrayNoise.ar(ampnoise);
	sig_rain = LPF.ar(sig_rain, 1000);
	sig_rain = HPF.ar(sig_rain, 3000);

	sig = Mix.ar([sig, sig_rain]);

	Out.ar(out_bus,[sig,sig]);
}).add;
)


Synth(\rain);

// 5. Finally, save it to your Synth-Folder to later load it back into Sonic Pi!

(
SynthDef.new(\rain, {
	arg mm = 2.5, dropweight = 0.03, out_bus=0, amp = 2;
	var raindrops, sig, sig_rain, ampnoise;

	raindrops = ((1000*mm) / dropweight) / (60*60);

	sig = Dust2.ar(raindrops);

	sig = GVerb.ar(sig, roomsize: 1, revtime: 0.3, inputbw: 0.5, drylevel: 0.9, earlyreflevel:0.2, taillevel: 0.9);

	sig = LPF.ar(sig, 200, mul: 2);
	sig = HPF.ar(sig, 2000, mul: 2);

	sig = sig*amp;

	ampnoise = mm.linlin(0,100,0.001,0.9);
	sig_rain = GrayNoise.ar(ampnoise);
	sig_rain = LPF.ar(sig_rain, 1000);
	sig_rain = HPF.ar(sig_rain, 3000);

	sig = Mix.ar([sig, sig_rain]);

	Out.ar(out_bus,[sig,sig]);
}).writeDefFile("yourfolder/synths");
)


// THE ORIGINAL RAIN SYNTHESIZER:


(
SynthDef.new(\rain, {
	arg mm=10, dropweight=0.03, amp=1, out_bus=0, attack=1, sustain= 3, release=10, freq=3000;
	var sig_drops, sig_rain, sig, amplfo, ampnoise, raindrops, env_rain, hpf_drops, autopos, drops_color;

	raindrops = ((1000*mm) / dropweight) / (60*60);


	hpf_drops = dropweight.linexp(0.005, 0.03, 1500,300);

	//hpf_drops = LFNoise0.ar(raindrops).range(hpf_drops*0.8,hpf_drops*1.2);

	sig_drops = GVerb.ar(Dust2.ar(raindrops), 1, 0.3, 0.5, drylevel: 0.9, earlyreflevel:0.2, taillevel: 0.9);
	sig_drops = LPF.ar(sig_drops, 200, mul: 2);
	sig_drops = HPF.ar(sig_drops, hpf_drops, mul: 2);

	sig_drops = sig_drops * amp * 1.2;

	env_rain = EnvGen.ar(Env.new([0,1,1,0],[attack,sustain,release]), doneAction:2);
	ampnoise = mm.linlin(0,100,0.001,0.9);
	sig_rain = GrayNoise.ar(ampnoise);
	amplfo = SinOsc.ar(0.2).range(0.2,0.3);
	sig_rain = LPF.ar(sig_rain, 1000);
	sig_rain = HPF.ar(sig_rain, hpf_drops);
	sig_rain = sig_rain*amplfo * amp;

	drops_color = FreeVerb.ar(LFPulse.ar(raindrops/100*LFNoise0.ar(raindrops/1000).range(0.5,1.2), 0.1, 0.02).range(0,1)*BPF.ar(GrayNoise.ar(0.5), LFNoise0.ar(raindrops/100*LFNoise0.ar(raindrops/1000).range(0.5,1.2)).range(freq,freq+3000), 0.01, 1), room:0.7)*amp*2;

	drops_color = LPF.ar(drops_color, 1000);
	//drops_color = HPF.ar(drops_color, hpf_drops);

	//sig = Splay.ar([sig_drops,sig_rain],1,1);
	sig = Mix.ar([sig_drops, sig_rain, drops_color]);

	sig = sig*env_rain;

	Out.ar(out_bus, sig);
}).writeDefFile("yourfolder/synths");
)




