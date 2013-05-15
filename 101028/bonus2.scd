s.boot;
(
SynthDef(\pulsesound, {|freq= 500, amp= 0.5, width= 0.5, filterFreq= 600, freqMax= 100|
	var snd, filter, freqControl;
	freqControl= LFPulse.ar(6)+LFPulse.ar(5)*freqMax;//0 or 200
	snd= LFPulse.ar(freq+freqControl, 0, width);
	filter= MoogFF.ar(snd, filterFreq)*amp;
	Out.ar(0, Pan2.ar(filter, 0));
}).add;
)

(
var win, usr, width= 640, height= 480, cnt= 0, cnt2= 45, cnt3= 0, syn;
var c1= 45, c2= 240, c3= 0.002, c4= 4, c5= 3, c6= 0.75, c7= 11, c8= 10, c9= 0.5;
win= Window("bonus", Rect(200, 200, width, height), false);
usr= UserView(win, Rect(0, 0, width, height));
usr.background= Color.white;
syn= Synth(\pulsesound);
usr.animate= true;
usr.drawFunc= {
	c7.do{|x|
		c8.do{|y|
			Pen.color= Color.blue(c6, c9);
			Pen.addRect(Rect(x%cnt*cnt2%640, y*cnt2%480, cnt, cnt));
		};
	};
	Pen.draw(c5);
	cnt= cnt+1%c1;
	cnt2= cnt2+cnt3%c2;
	cnt3= cnt3+c3%c4;
	syn.set(
		\freq, cnt3.linlin(0, 4, 100, 300),
		\width, cnt/45,
		\filterFreq, cnt2.linexp(0, 239, 400, 4000),
		\freqMax, cnt3.linexp(0, 4, 100, 1000),
		\amp, c9
	);
};
win.front;
CmdPeriod.doOnce({
	c.remove;
	if(win.isClosed.not, {win.close});
});
c.remove;
c= CCResponder({|src, chan, num, val|
	switch(num.postln,
		2, {c1= val.linlin(0, 127, 0, 45)},
		3, {c2= val.linlin(0, 127, 0, 240)},
		4, {c3= val.linlin(0, 127, 0, 1)},
		5, {c4= val.linlin(0, 127, 0, 4)},
		6, {c5= val.linlin(0, 127, 0, 4)},
		8, {c6= val.linlin(0, 127, 0, 1)},
		9, {c7= val.linlin(0, 127, 1, 50)},
		12, {c8= val.linlin(0, 127, 1, 50)},
		13, {c9= val.linlin(0, 127, 0, 1)}
	);
});
)
