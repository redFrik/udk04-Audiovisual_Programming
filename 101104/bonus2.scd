a= NodeProxy.new.play
a.source= {SinOsc.ar([400, 404], 0, 0.2)}
a.source= {SinOsc.ar([LFPulse.ar(1).range(400, 500), LFPulse.ar(1.1).range(404, 505)], 0, 0.2)}
a.source= {SinOsc.ar([400, 404], SinOsc.ar(SinOsc.ar(SinOsc.ar(1, 0, 4), 0, 200), 0, 2pi), 0.2)}
a.fadeTime= 3
a.source= {SinOsc.ar([400, 404], SinOsc.ar(SinOsc.ar(SinOsc.ar(SinOsc.ar([1, 1.1], 0, SinOsc.ar(0.5, 0, 5)), 0, 4), 0, SinOsc.ar(13, 0, 200)), 0, 2pi), 0.2)}
a.stop
a.play
a.source= {|freq= 400, amp= 0.2| SinOsc.ar([freq, freq+4], SinOsc.ar(SinOsc.ar(SinOsc.ar(SinOsc.ar([1, 1.1], 0, SinOsc.ar(0.5, 0, 5)), 0, 4), 0, SinOsc.ar(13, 0, 200)), 0, 2pi), amp)}
a.set(\freq, 300)
a.set(\freq, 10)
a.set(\freq, 1000)
a.set(\freq, 3000)
a.set(\amp, 0.05)
a.source= {|freq= 400, amp= 0.2, a= 4, b= 0.5, c= 5, d= 4, e= 13, f= 200| SinOsc.ar([freq, freq+a], SinOsc.ar(SinOsc.ar(SinOsc.ar(SinOsc.ar([1, 1.1], 0, SinOsc.ar(b, 0, c)), 0, d), 0, SinOsc.ar(e, 0, f)), 0, 2pi), amp)}
a.fadeTime= 0.5
a.set(\a, 1, \b, 1, \c, 1, \d, 1, \e, 1, \f, 10)
a.set(\freq, 300)
a.set(\a, 1000.0.rand, \b, 100.0.rand, \c, 10.0.rand, \d, 1.0.rand, \e, 10.0.rand, \f, 100.rand)


//sine soundscape
(
Routine({
	a.fadeTime= 4;
	a.play;
	10.do{|i|
		i.postln;
		a.xset(\freq, i.linexp(0, 9, 400, 1000));
		a.xset(\amp, 0.05.rrand(0.1));
		a.xset(\a, 1000.0.rand, \b, 100.0.rand, \c, 10.0.rand, \d, 1.0.rand, \e, 10.0.rand, \f, 100.rand);
		6.wait;
	};
	a.stop(4);
}).play;
)


a.stop
a.clear
