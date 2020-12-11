(
s.waitForBoot{

	//--window setup
	var width= 500, height= 500;
	var w= Window("a/v instrument example 1", Rect(99, 99, width, height), false);
	var u= UserView(w, Rect(0, 0, width, height));

	//--variables
	var theta= 0;		//a counter
	var num= 15;		//try also with more balls
	var syns= {
		SynthDef(\av, {|freq= 400, amp= 0, pan= 0|
			var z= SinOsc.ar(0, SinOsc.ar(freq, 0, 2pi), amp);
			Out.ar(0, Pan2.ar(z, pan));
		}, #[0.02, 0.05, 0.05]).play(s);
	}.dup(num);
	s.sync;

	//--interface
	~speed= 0.5;
	~radius= 10;
	~spread= 10;
	~distancex= 1;
	~distancey= 0.5;
	~offsetx= -0.1;
	~offsety= -0.2;
	~root= 100;

	//--main loop
	u.drawFunc= {
		Pen.fillColor= Color.red;		//set the fill color to red
		Pen.fillOval(u.bounds);			//draw a filled oval with the size of the whole window
		Pen.translate(width*0.5, height*0.5);	//offset all drawing to middle of the window
		Pen.fillColor= Color.grey(1, 0.5);	//set the fill color with 50% alpha
		num.do{|i|
			var a, x, y;
			a= i%num/num*2pi+theta;		//angle in radians
			x= sin(a+(i*~offsetx))*(~spread+(i*~distancex));
			y= cos(a+(i*~offsety))*(~spread+(i*~distancey));
			Pen.fillOval(Rect.aboutPoint(Point(x, y), ~radius, ~radius));
			if(((x.hypot(y)/1.42/~spread).min(0.5)/num).isNil, {"nil".postln});
			syns[i].set(				//update corresponding synth
				\freq, y.linexp(height.neg*0.5, height*0.5, ~root, 1000),
				\amp, (x.hypot(y)/1.42/~spread).min(0.5)/num,
				\pan, x.linlin(width.neg*0.5, width*0.5, -1, 1)
			);
		};
		theta= theta-~speed%2pi;		//our counter counts in radians
	};

	//--window management
	u.background= Color.white;
	w.onClose= {syns.do{|x| x.free}};
	CmdPeriod.doOnce({if(w.isClosed.not, {w.close})});
	w.front;
	Routine({while({w.isClosed.not}, {u.refresh; (1/60).wait})}).play(AppClock);
};
)

(	//use midi input to control the program
MIDIIn.connect(device:1);							//edit to match your own setup
MIDIIn.control= {|src, chan, num, val|
	switch(num.postln,
		1, {~speed= val.linlin(0, 127, 0, 2pi)},		//ctrl number 1 sets the ~speed
		2, {~radius= val.linlin(0, 127, 1, 100)},
		3, {~spread= val.linlin(0, 127, 0, 300)},
		4, {~distancex= val.linlin(0, 127, -10, 10)},
		5, {~distancey= val.linlin(0, 127, -10, 10)},
		6, {~offsetx= val.linlin(0, 127, -pi*0.5, pi*0.5)},
		8, {~offsety= val.linlin(0, 127, -pi*0.5, pi*0.5)},
		9, {~root= val.linexp(0, 127, 1, 1000)}
	);
};
)

//change these while the program is running
~spread= 25;
~distancey= -2.2;
~distancey= -5.7;
~distancex= -6.7;
~spread= 150;
~radius= 50;
~offsetx= 0;
~offsety= -0.6;
~radius= 8;
~spread= 60;
~speed= pi*0.99;
~distancex= -10;
~distancey= 3;
~speed= 0.5;
~speed= -0.15;
~offsety= 0.1;
~offsetx= -0.5;
~offsety= 1;
~speed= 0.02;
~speed= 0.3;
~distancex= 0.12;
~distancey= -9.2;
~speed= 0.2;
~distancex= 5.5;
~offsetx= -0.1;
~offsety= -0.21;
~spread= 100;
~spread= 800;
~spread= 2;
~offsety= 0;
~distancey= 0;
~speed= 0.1
~speed= 22;
~root= 60;
~root= 120;
//cmd+. to stop
