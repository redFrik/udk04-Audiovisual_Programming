//--waveform

//run this once before starting the graphics below
//it creates a buffer and a synthdef for writing samples into a buffer
(
s.latency= 0.05;
s.boot;

b= Buffer.alloc(s, 400, 1);	//400 samples, mono

SynthDef(\reader, {|bus= 0, bufnum, fps= 60, sample= 1|
	var snd= InFeedback.ar(bus, 1);//listen for sound on any bus
	var trig= Impulse.ar(fps);		//speed of index phasor
	var index= Phasor.ar(trig, sample, 0, BufFrames.kr(bufnum)-1);//write position in buffer
	BufWr.ar(snd, bufnum, index, 0);//write snd into buffer
	SendTrig.ar(trig, 0, bufnum);	//send data to oscreponder
}).add;
)

//the above synthdef will 60 times a second send back a buffer number so that we can read 400 values


//--
(
var width= 640, height= 480, theta= 0;
var win= Window("waveform", Rect(100, 100, width, height));
var usr= UserView(win, Rect(0, 0, width, height));

//--read sample data back from scserver and store in arr
var arr= Array.fill(b.numFrames, 0); //data array containing samples
var osc= OSCresponder(s.addr, '/tr', {|t, r, m| //read back bufnum from sendtrig
	if(m[2]==0, {
		b.getn(0, b.numFrames-1, {|data| arr= data}); //read the data from buffer
	});
}).add;
var readSyn= Synth(\reader, [\bus, 0, \bufnum, b, \fps, 60]);

~sample= 1;		//to change later

//--main drawing loop
usr.drawFunc= {
	Pen.translate(50, height*0.5);
	readSyn.set(\sample, ~sample);
	Pen.strokeColor= Color.white;
	arr.do{|y, x|				//iterate over array
		var p= Point(x, y*height*0.5);
		if(x==0, {				//if first sample
			Pen.moveTo(p);	//move to point p
		}, {
			Pen.lineTo(p);	//else draw to point p
		});
	};
	Pen.stroke;
};
usr.animate= true;	//on linux replace with: Routine({while({win.isClosed.not}, {usr.refresh; (1/60).wait})}).play(AppClock);
usr.background= Color.black;
win.front;
CmdPeriod.doOnce({if(win.isClosed.not, {win.close})});
)

//now play some sounds on bus 0.  simple sounds work best.  experiment.  try your old sounds
//find sounds that look good!

Ndef(\test).play
Ndef(\test, {SinOsc.ar(MouseX.kr(3, 3000), 0, MouseY.kr(0, 1))})
Ndef(\test, {WhiteNoise.ar(1)})
Ndef(\test, {BrownNoise.ar(1)})
Ndef(\test, {SinOsc.ar(0.3)})
Ndef(\test, {SinOsc.ar(0.3)+SinOsc.ar(9000, 0, 0.1)})
Ndef(\test, {SinOsc.ar(0.3)+SinOsc.ar(15000, 0, 0.2)})
Ndef(\test, {SinOsc.ar(0.8, SinOsc.ar(15000, 0, 2pi))})

Ndef(\test, {SinOsc.ar(0.2)+Pulse.ar(1100)})
Ndef(\test, {SinOsc.ar(400+SinOsc.ar(0.2, 0, 100), 0, Decay2.ar(Impulse.ar(1), 0, 0.3))})
Ndef(\test, {LFSaw.ar(SinOsc.ar(0.1, 0, 200, 2000), 0, 1, 0.8))})
Ndef(\test).stop

//also play with this downsample parameter

~sample= 2
~sample= 1.234
~sample= 3
~sample= 1


//--
(
var width= 640, height= 480, theta= 0;
var win= Window("waveform2", Rect(100, 100, width, height));
var usr= UserView(win, Rect(0, 0, width, height));

//--read sample data back from scserver and store in arr
var arr= Array.fill(b.numFrames, 0); //data array containing samples
var osc= OSCresponder(s.addr, '/tr', {|t, r, m| //read back bufnum from sendtrig
	if(m[2]==0, {
		b.getn(0, b.numFrames-1, {|data| arr= data}); //read the data from buffer
	});
}).add;
var readSyn= Synth(\reader, [\bus, 0, \bufnum, b, \fps, 60]);

~sample= 1;		//to change later
~speed= 0;			//for spinning

//--main drawing loop
usr.drawFunc= {
	Pen.rotate(theta, width*0.5, height*0.5); //for spinning
	Pen.translate(50, height*0.5);
	readSyn.set(\sample, ~sample);
	Pen.strokeColor= Color.white;
	arr.do{|y, x|				//iterate over array
		var p= Point(x, y*height*0.5);
		if(x==0, {				//if first sample
			Pen.moveTo(p);	//move to point p
		}, {
			Pen.lineTo(p);	//else draw to point p
		});
	};
	Pen.stroke;
	theta= theta+~speed;	//for spinning
};
usr.animate= true;	//on linux replace with: Routine({while({win.isClosed.not}, {usr.refresh; (1/60).wait})}).play(AppClock);
usr.background= Color.black;
win.front;
CmdPeriod.doOnce({if(win.isClosed.not, {win.close})});
)
~speed= 0.01
~sample= 2
~sample= 1.234
~sample= 3
~sample= 1
~speed= 0.4
~speed= -1
~speed= pi-0.005
~sample= 2.125


//--
(
var width= 640, height= 480, theta= 0;
var win= Window("waveform3", Rect(100, 100, width, height));
var usr= UserView(win, Rect(0, 0, width, height));

//--read sample data back from scserver and store in arr
var arr= Array.fill(b.numFrames, 0); //data array containing samples
var osc= OSCresponder(s.addr, '/tr', {|t, r, m| //read back bufnum from sendtrig
	if(m[2]==0, {
		b.getn(0, b.numFrames-1, {|data| arr= data}); //read the data from buffer
	});
}).add;
var readSyn= Synth(\reader, [\bus, 0, \bufnum, b, \fps, 60]);

~sample= 1;		//to change later
~speed= 0;			//for spinning
~trail= 0.1;		//for trails
//--main drawing loop
usr.drawFunc= {
	Pen.fillColor= Color.grey(0.5, ~trail); //for trails
	Pen.fillRect(Rect(0, 0, width, height)); //for trails

	Pen.rotate(theta, width*0.5, height*0.5); //for spinning
	Pen.translate(50, height*0.5);
	readSyn.set(\sample, ~sample);
	Pen.strokeColor= Color.white;
	arr.do{|y, x|				//iterate over array
		var p= Point(x, y*height*0.5);
		if(x==0, {				//if first sample
			Pen.moveTo(p);	//move to point p
		}, {
			Pen.lineTo(p);	//else draw to point p
		});
	};
	Pen.stroke;
	theta= theta+~speed;	//for spinning
};
usr.animate= true;	//on linux replace with: Routine({while({win.isClosed.not}, {usr.refresh; (1/60).wait})}).play(AppClock);
usr.clearOnRefresh= false;	//for trails
usr.background= Color.black;
win.front;
CmdPeriod.doOnce({if(win.isClosed.not, {win.close})});
)
~speed= 0.1
~sample= 2
~sample= 1.234
~sample= 3
~sample= 1
~speed= pi-0.005
~trail= 0.05
~trail= 0.2
~speed= -1
~speed= pi+0.05
~sample= 2


//--
(
var width= 640, height= 480, theta= 0;
var win= Window("waveform4", Rect(100, 100, width, height));
var usr= UserView(win, Rect(0, 0, width, height));

//--read sample data back from scserver and store in arr
var arr= Array.fill(b.numFrames, 0); //data array containing samples
var osc= OSCresponder(s.addr, '/tr', {|t, r, m| //read back bufnum from sendtrig
	if(m[2]==0, {
		b.getn(0, b.numFrames-1, {|data| arr= data}); //read the data from buffer
	});
}).add;
var readSyn= Synth(\reader, [\bus, 0, \bufnum, b, \fps, 60]);

~sample= 1;		//to change later
~speed= 0;			//for spinning
~trail= 0.1;		//for trails
//--main drawing loop
usr.drawFunc= {
	Pen.smoothing= false;
	Pen.fillColor= Color.grey(0.1, ~trail); //for trails
	Pen.fillRect(Rect(0, 0, width, height)); //for trails

	Pen.rotate(theta, width*0.5, height*0.5); //for spinning
	Pen.translate(50, height*0.5);
	readSyn.set(\sample, ~sample);
	Pen.strokeColor= Color.white;
	arr.do{|y, x|				//iterate over array
		var p= Point(x, y*height*0.5);
		Pen.addRect(Rect(p.x, p.y, x.linlin(0, b.numFrames-1, 0, 50), y.linlin(0, b.numFrames-1, 0, 50)));
	};
	Pen.stroke;
	theta= theta+~speed;	//for spinning
};
usr.animate= true;	//on linux replace with: Routine({while({win.isClosed.not}, {usr.refresh; (1/60).wait})}).play(AppClock);
usr.clearOnRefresh= false;	//for trails
usr.background= Color.black;
win.front;
CmdPeriod.doOnce({if(win.isClosed.not, {win.close})});
)
~speed= 0
~sample= 2
~sample= 1.234
~sample= 3
~sample= 1
~speed= pi-0.005
~trail= 0.003
~speed= 2pi*0.09



//--
(
var width= 640, height= 480, theta= 0;
var win= Window("waveform5", Rect(100, 100, width, height));
var usr= UserView(win, Rect(0, 0, width, height));

//--read sample data back from scserver and store in arr
var arr= Array.fill(b.numFrames, 0); //data array containing samples
var osc= OSCresponder(s.addr, '/tr', {|t, r, m| //read back bufnum from sendtrig
	if(m[2]==0, {
		b.getn(0, b.numFrames-1, {|data| arr= data}); //read the data from buffer
	});
}).add;
var readSyn= Synth(\reader, [\bus, 0, \bufnum, b, \fps, 60]);

~sample= 1;		//to change later
~speed= 0;			//for spinning
~trail= 0.1;		//for trails
//--main drawing loop
usr.drawFunc= {
	Pen.fillColor= Color.grey(0.1, ~trail); //for trails
	Pen.fillRect(Rect(0, 0, width, height)); //for trails
	Pen.rotate(theta, width*0.5, height*0.5); //for spinning
	readSyn.set(\sample, ~sample);
	Pen.strokeColor= Color.green;
	arr.do{|y, x|				//iterate over array
		var p;
		Pen.push;
		Pen.rotate(x/b.numFrames*2pi, width*0.5, height*0.5);
		p= Point(x, y*height*0.5);
		Pen.addRect(Rect(p.x, p.y, 8, 8));
		Pen.pop;
	};
	Pen.stroke;
	theta= theta+~speed;	//for spinning
};
usr.animate= true;	//on linux replace with: Routine({while({win.isClosed.not}, {usr.refresh; (1/60).wait})}).play(AppClock);
usr.clearOnRefresh= false;	//for trails
usr.background= Color.black;
win.front;
CmdPeriod.doOnce({if(win.isClosed.not, {win.close})});
)
~speed= 0.001
~sample= 2
~sample= 1.234
~sample= 3
~sample= 1.5
~speed= 2pi+0.001
~trail= 1
~speed= pi+0.001
