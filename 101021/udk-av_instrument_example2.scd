(
s.waitForBoot{

	//--window setup
	var width= 640, height= 480;
	var w= Window("a/v instrument example 2", Rect(99, 99, width, height), false);
	var u= UserView(w, Rect(0, 0, width, height));

	//--sound
	var syn= SynthDef(\track, {|amp= 0.5|
		var a, b, z;
		#a, b= Pitch.kr(SoundIn.ar, ampThreshold:0.02);
		SendTrig.kr(Impulse.kr(60), 0, a*b);
		z= BPF.ar(LFSaw.ar(a, 0, LagUD.kr(b, 0.01, 0.1)*amp), 700, 0.2);
		Out.ar(0, Pan2.ar(z));
	}).play(s);

	//--network
	var y= 0;
	var osc= OSCresponder(s.addr, \tr, {|t, r, m|
		if(m[3]>0, {
			y= m[3].clip(0, 800).linlin(0, 800, 0, height);
		}, {
			y= -1;
		});
	}).add;

	//--main loop
	u.drawFunc= {
		if(y>=0, {
			Pen.fillColor= Color.white;
			Pen.fillOval(Rect.aboutPoint(Point(width*0.5, height-y), 150, 150));
		});
	};

	//--window management
	u.background= Color.black;
	w.onClose= {syn.free};
	CmdPeriod.doOnce({if(w.isClosed.not, {w.close})});
	w.front;
	Routine({while({w.isClosed.not}, {u.refresh; (1/60).wait})}).play(AppClock);
};
)
//microphone input to control
