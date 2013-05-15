//--bonus
(
s.latency= 0.05;
s.waitForBoot{
	var width= 640, height= 480, theta= 0;
	var win= Window("waveform", Rect(100, 100, width, height), false);
	var usr= UserView(win, Rect(0, 0, width, height));
	var buf, arr, osc, trk;
	
	//--reading samples
	buf= Buffer.alloc(s, 640, 1);
	SynthDef(\reader, {|bus= 0, bufnum, fps= 60, sample= 1|
		var snd= InFeedback.ar(bus, 1);
		var trig= Impulse.ar(fps);
		var index= Phasor.ar(trig, sample, 0, BufFrames.kr(bufnum)-1);
		BufWr.ar(snd, bufnum, index, 0);
		SendTrig.ar(trig, 0, bufnum);
	}).add;
	s.sync;
	
	arr= Array.fill(buf.numFrames, 0);
	osc= OSCresponder(s.addr, '/tr', {|t, r, m|
		if(m[2]==0, {
			buf.getn(0, buf.numFrames-1, {|data| arr= data});
		});
	}).add;
	trk= Synth(\reader, [\in, 0, \bufnum, buf, \fps, 60]).play;
	s.sync;
	
	//--interface
	~sample= 1;
	~speed= 0;
	~trails= 1;
	~version= 0;
	
	//--main loop
	usr.drawFunc= {
		trk.set(\sample, ~sample);
		Pen.fillColor= Color.grey(0, ~trails);
		Pen.fillRect(usr.bounds);			//manually clear with alpha
		
		Pen.strokeColor= Color.white;
		switch(~version,
			0, {									//line
				Pen.rotate(theta, width*0.5, height*0.5);
				Pen.translate(0, height*0.5);
				arr.do{|y, x|
					var p= Point(x, y*height);
					if(x==0, {Pen.moveTo(p)}, {Pen.lineTo(p)});
				};
				Pen.stroke;
			},
			1, {									//warp
				Pen.rotate(theta, width*0.5, height*0.5);
				Pen.translate(width*0.5, height*0.5);
				arr.do{|y, x|
					var p= Point(x, y).rotate(y*2pi);
					if(x==0, {Pen.moveTo(p)}, {Pen.lineTo(p)});
				};
				Pen.stroke;
			},
			2, {									//flower
				Pen.translate(width*0.5, height*0.5);
				Pen.moveTo(Point(arr[0], 0)*arr[0]);
				arr.do{|y, x|
					var p= Point(y, x)*y;
					var a= x%width/width*2pi+theta;
					Pen.lineTo(p.rotate(a));
				};
				Pen.stroke;
			}
		);
		theta= theta+~speed;
	};
	
	//--window management
	usr.animate= true;	//on linux replace with: Routine({while({win.isClosed.not}, {usr.refresh; (1/60).wait})}).play(AppClock);
	usr.clearOnRefresh= false;		//do not erase - just draw on top of
	usr.background= Color.black;
	win.front;
	CmdPeriod.doOnce({
		if(win.isClosed.not, {win.close});
		buf.free;
		osc.remove;
	});
	
	//--testsound
	s.sync;
	Ndef(\snd).play;
	Ndef(\snd, {Mix(SinOsc.ar([400, 404], SinOsc.ar(SinOsc.ar(SinOsc.ar(SinOsc.ar([0.1, 0.11], 0, SinOsc.ar(SinOsc.ar([0.05, 0.06], 0, 12), 0, 5)), 0, 2), 0, SinOsc.ar(3, 0, 200)), 0, 2pi), 0.2)*SinOsc.ar([0.25, 0.26], 0, 0.5)+SinOsc.ar([8000, 8001], 0, SinOsc.ar(0.1, SinOsc.ar([0.4, 0.3], 0, 2pi), 0.01))!2)});

};
)

//change these while the program is running
~sample= 2;
~sample= 10;
~sample= 1;
~trails= 0.2;
~speed= 0.1;
~speed= -0.05;
~trails= 0.01;
~speed= pi*0.25;
~sample= 2;
~sample= 1.2;
~version= 1;
~trails= 0.1;
~sample= 1;
~sample= 5;
~speed= 0.01;
~version= 2;
~sample= 1;
~speed= 1;
~version= 1;
~speed= 2pi*1.001;
~trails= 0.01
