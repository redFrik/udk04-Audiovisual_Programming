//--bonus - hack it!

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
win= Window("bonus", Rect(200, 200, width, height), false);
usr= UserView(win, Rect(0, 0, width, height));
usr.background= Color.white;
syn= Synth(\pulsesound);
usr.drawFunc= {
	11.do{|x|
		10.do{|y|
			Pen.color= Color.blue(0.75, 0.5);
			Pen.addRect(Rect(x%cnt*cnt2%640, y*cnt2%480, cnt, cnt));
		};
	};
	Pen.draw(3);
	cnt= cnt+1%45;
	cnt2= cnt2+cnt3%240;
	cnt3= cnt3+0.002%4;
	syn.set(\freq, cnt3.linlin(0, 4, 100, 300), \width, cnt/45, \filterFreq, cnt2.linexp(0, 239, 400, 4000), \freqMax, cnt3.linexp(0, 4, 100, 1000));
};
Routine({while({win.isClosed.not}, {usr.refresh; (1/60).wait})}).play(AppClock);
win.front;
)