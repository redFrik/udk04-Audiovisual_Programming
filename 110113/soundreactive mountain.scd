(
var peak0= 0.2, peak1= 0.2, peak2= 0.3;
var width= 500, height= 500;
var win= Window("soundreactive mountain", Rect(300, 300, width, height), false);
var usr= UserView(win, Rect(0, 0, width, height));
usr.background= Color.white;
usr.drawFunc= {
	Pen.strokeColor= Color.black;
	Pen.moveTo(Point(width*0.1, height*0.5));
	Pen.quadCurveTo(Point(width*0.2, height*0.5), Point(width*0.13, height*peak0));
	Pen.quadCurveTo(Point(width*0.3, height*0.5), Point(width*0.23, height*peak1));
	Pen.quadCurveTo(Point(width*0.4, height*0.5), Point(width*0.33, height*peak2));
	Pen.stroke;
};
win.front;
CmdPeriod.doOnce({if(win.isClosed.not, {win.close})});
Routine({while({win.isClosed.not}, {usr.refresh; (1/40).wait})}).play(AppClock);

OSCresponder(nil, \lfos, {|t, r, m|
	peak0= m[3].linlin(-1, 1, 0.5, 0.1);
	peak1= m[4].linlin(-1, 1, 0.5, 0.1);
	peak2= m[5].linlin(-1, 1, 0.5, 0.1);
}).add;
s.waitForBoot{
	Ndef(\peaksnd, {
		var lfo0= LFNoise1.kr(1, 0.5);
		var lfo1= LFNoise1.kr(2, 0.7);
		var lfo2= LFNoise1.kr(1, 0.5);
		SendReply.kr(Impulse.kr(60), \lfos, [lfo0, lfo1, lfo2]);
		Splay.ar(SinOsc.ar([lfo0, lfo1, lfo2].linexp(-1, 1, 300, 3000)));
	}).play;
};
)
