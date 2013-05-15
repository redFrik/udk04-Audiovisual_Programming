s.boot
(
SynthDef(\tracking3ch, {|bus= 5, fps= 60|
	SendReply.ar(Impulse.ar(fps), \tracking3ch, InFeedback.ar(bus, 3));
}).add;
)

(
var width= 640, height= 480;
var win= Window("reply", Rect(100, 100, width, height), false);
var usr= UserView(win, Rect(0, 0, width, height));

var x= 0, y= 0, z= 0;
var osc= OSCresponder(s.addr, \tracking3ch, {|t, r, m|
	x= m[3];
	y= m[4];
	z= m[5];
}).add;
Synth(\tracking3ch, [\bus, 5]);		//reading channels bus 5, 6 and 7

//--main loop
usr.drawFunc= {
	Pen.translate(width*0.5, height*0.5);
	//Pen.fillColor= Color.grey(0.8);
	Pen.fillColor= Color.grey(z.linlin(-1, 1, 0, 1), z.linlin(-1, 1, 0, 1));
	Pen.addOval(Rect.aboutPoint(Point(x, y)*150, z.linlin(-1, 1, 0, 30), z.linlin(-1, 1, 0, 30)));
	Pen.draw(3);
};

//--window management
usr.background= Color.black;
usr.clearOnRefresh= false;
CmdPeriod.doOnce({if(win.isClosed.not, {win.close})});
win.front;
usr.animate= true;	//for linux replace with this: Routine({while({win.isClosed.not}, {usr.refresh; (1/60).wait})}).play(AppClock);
)


//--make some sound on channels 5, 6, 7
Ndef(\test).play(out:5, numChannels:3)
Ndef(\test, {SinOsc.ar(MouseX.kr(0, 10), [0.1, 0.6, 0.3], 1)})
Ndef(\test, {SinOsc.ar(MouseX.kr(0, 10), [0.1, SinOsc.ar(0.1, 0, 2pi), 0.3], 1)})

Ndef(\test, {[SinOsc.ar(0.2), LFSaw.ar(0.2), LFSaw.ar(0.1)]})
Ndef(\test, {[SinOsc.ar(0.2), LFSaw.ar(0.2), SinOsc.ar(0.1)]})

//bounce
Ndef(\test, {[LFTri.ar(0.42), LFTri.ar(0.32), DC.ar(1)]})
Ndef(\test, {[LFTri.ar(0.42), LFTri.ar(0.32), SinOsc.ar(2)]})

//circle
Ndef(\test, {[SinOsc.ar(0.2, -pi*0.5), SinOsc.ar(0.2, 0), SinOsc.ar(0.5)]})

//spiral
Ndef(\test, {[SinOsc.ar(0.2, pi*0.5, SinOsc.ar(0.01)), SinOsc.ar(0.2, 0, SinOsc.ar(0.01)), DC.ar(1)]})

//add jitter
Ndef(\test, {[SinOsc.ar(0.2, pi*0.5, SinOsc.ar(0.01))+BrownNoise.ar(0.05), SinOsc.ar(0.2, 0, SinOsc.ar(0.01)), DC.ar(1)]})

Ndef(\test, {[LFSaw.ar(2)+SinOsc.ar(0.1), LFSaw.ar(1.8), LFSaw.ar(1)]})
Ndef(\test, {[LFSaw.ar(10)*SinOsc.ar(0.1), LFSaw.ar(1.25)*SinOsc.ar(0.2), LFSaw.ar(0.2)]})
Ndef(\test, {[LFSaw.ar(-1)*Saw.ar(5), LFSaw.ar(2)*Saw.ar(0.5), LFSaw.ar(4)*Saw.ar(2/3)]})

Ndef(\snd).play
Ndef(\snd, {Splay.ar(SinOsc.ar(InFeedback.ar(5, 3).exprange(200, 1000), 0, 0.1))})

Ndef(\snd).stop
Ndef(\test).stop
