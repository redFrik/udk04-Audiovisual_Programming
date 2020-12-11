//--sinewaves and circles

sin(3340.9)		//any number will give a value between -1 and 1

//radians 0-2pi.  2pi is almost 6.3

//for one full cycle or sinewave, set values from 0 to 2pi (≈6.3)

cos(123)			//same true for cos.  any number will give a value between -1 and 1.  only the start is shifted 25% or 1/4th of the cycle compared to the sin()
cos(0)				//gives 1.  -1 to 1 cycle begins at the top
sin(0)				//gives 0.  -1 to 1 cycle begins midway

//plot one cycle of a sinewave
(
w= Window("sine test1-1", Rect(100, 100, 640, 480));
u= UserView(w, Rect(0, 0, 640, 480));
u.background= Color.white;
u.drawFunc= {
	50.do{|x|
		Pen.fillColor= Color.red;
		Pen.fillOval(Rect(x/50*640, sin(x/50*2pi)*240+240, 5, 5));
	};
};
w.front;
)
//note: the y coordinates of supercollider is flipped so this is why the cycle begin downwards on the screen



//also change the width and height of the ovals using cos or sin functions
(
w= Window("sine test1-2", Rect(100, 100, 640, 480));
u= UserView(w, Rect(0, 0, 640, 480));
u.background= Color.white;
u.drawFunc= {
	50.do{|x|
		Pen.fillColor= Color.red(1, 0.5);
		Pen.fillOval(Rect(x/50*640, sin(x/50*2pi)*240+240, cos(x/50*2pi)*15+30, cos(x/50*2pi)*15+30));
	};
};
w.front;
)


//change rgb colour as well as x position.  using cos for x and sin for y will give you a circle
(
w= Window("sine test1-3", Rect(100, 100, 640, 480));
u= UserView(w, Rect(0, 0, 640, 480));
u.background= Color.white;
u.drawFunc= {
	50.do{|x|
		Pen.fillColor= Color(sin(x/50*2pi*1)*0.5+0.5, sin(x/50*2pi*2)*0.5+0.5, sin(x/50*2pi*3)*0.5+0.5);
		Pen.fillOval(Rect(cos(x/50*2pi)*320+320, sin(x/50*2pi)*240+240, cos(x/50*2pi)*15+30, cos(x/50*2pi)*15+30));
	};
};
w.front;
)



//--animation!
//only change colour - not position
(
var theta= 0;
w= Window("sine test2-1", Rect(100, 100, 800, 600));
u= UserView(w, Rect(0, 0, 800, 600));
u.background= Color.black;
u.drawFunc= {
	100.do{|x|
		Pen.fillColor= Color.grey(1, sin(x/100+theta*2pi*1)*0.5+0.5);
		Pen.fillOval(Rect(x/100*800, 300, 30, 30));
	};
};
w.front;
Routine({while({w.isClosed.not}, {u.refresh; (1/60).wait; theta= theta+0.01})}).play(AppClock);	//0.01 is the speed
)




(
var freqScale= 1;		//try changing this
var theta= 0;
w= Window("sine test2-2", Rect(100, 100, 800, 600));
u= UserView(w, Rect(0, 0, 800, 600));
u.background= Color.black;
u.drawFunc= {
	6.do{|y|				//nested loops
		50.do{|x|
			Pen.fillColor= Color.grey(1, sin(x/50*2pi+(y/6*2pi))*0.5+0.5);
			Pen.fillOval(Rect(x/50*800, sin(x/50*2pi+(y/6*2pi)*freqScale+theta)*100+300, 30, 30));
		};
	};
};
w.front;
Routine({while({w.isClosed.not}, {u.refresh; (1/60).wait; theta= theta+0.02})}).play(AppClock);
)



//--sound!

s.boot
a= NodeProxy.new.play
a.source= {SinOsc.ar(400, 0, 0.1)}
a.stop
a.play
a.source= {SinOsc.ar(400, 0, SinOsc.ar(0.5, 0, 0.5, 0.5).poll)}
a.source= {SinOsc.ar(SinOsc.ar(1, 0, 100, 400), 0, SinOsc.ar(0.5, 0, 0.5, 0.5))}
a.source= {SinOsc.ar(SinOsc.ar(1, 0, 100, 400), SinOsc.ar(120, 0, 2pi), SinOsc.ar(0.5, 0, 0.5, 0.5))}
a.stop

//variation #1 replacing the static 400 with another SinOsc at 4hz
a.source= {SinOsc.ar(SinOsc.ar(1, 0, 100, SinOsc.ar(4, 0, 100, 400)), SinOsc.ar(120, 0, 2pi), SinOsc.ar(0.5, 0, 0.5, 0.5))}
a.play
a.stop

//variation #2 replacing the static 1 with another SinOsc at 0.4hz
a.source= {SinOsc.ar(SinOsc.ar(SinOsc.ar(0.4, 0, 0.5, 10), 0, 100, SinOsc.ar(4, 0, 100, 400)), SinOsc.ar(120, 0, 2pi), SinOsc.ar(0.5, 0, 0.5, 0.5))}
a.play
a.stop

//variaton #3 replacing the static 100 with another SinOsc at 0.1hz
a.source= {SinOsc.ar(SinOsc.ar(SinOsc.ar(0.4, 0, 0.5, 10), 0, SinOsc.ar(0.1, 0, 250, 500), SinOsc.ar(4, 0, 100, 400)), SinOsc.ar(120, 0, 2pi), SinOsc.ar(0.5, 0, 0.5, 0.5))}
a.play
a.stop

//variaton #4 replacing static values with arrays of 2 values - expands to stereo
a.source= {SinOsc.ar(SinOsc.ar(SinOsc.ar([0.4, 0.3], 0, 0.5, 10), 0, SinOsc.ar([0.11, 0.1], 0, 250, [500, 450]), SinOsc.ar(4, 0, 100, [400, 700])), SinOsc.ar(120, 0, 2pi), SinOsc.ar([0.5, 0.4], 0, 0.5, 0.5))}
a.play
a.stop



//--better example
a.source= {SinOsc.ar([400, 404], SinOsc.ar(SinOsc.ar(SinOsc.ar(SinOsc.ar([1, 1.1], 0, SinOsc.ar(0.5, 0, 5)), 0, 4), 0, SinOsc.ar(13, 0, 200)), 0, 2pi), 0.2)}
a.play
a.stop


//often easier to understand what is happening if you write your code on separate lines
(
a.source= {SinOsc.ar(			//main oscillator - the one we are modulating
	SinOsc.ar(1, 0, 100, 500),	//freq - between 400 and 600 hz, spinning at 1hz
	SinOsc.ar(2, 0, 2pi),		//phase - between -2pi and 2pi, 2hz
	SinOsc.ar(3, 0, 0.5, 0.5)	//mul - (amp) between 0 and 1, 3hz
);
};
)
a.play
a.stop

//faster and higher
(
a.source= {SinOsc.ar(
	SinOsc.ar(10, 0, 100, 900),	//freq - between 800 and 1000 hz, spinning at 10hz
	SinOsc.ar(2, 0, 2pi),		//phase - between -2pi and 2pi, 2hz
	SinOsc.ar(3, 0, 0.5, 0.5)	//mul - (amp) between 0 and 1, 3hz
)
}
)
a.play
a.stop

//lower and slower
(
a.source= {SinOsc.ar(
	SinOsc.ar(0.3, 0, 20, 200),	//freq - between 180 and 220 hz, spinning at 0.3hz
	SinOsc.ar(3, 0, 2pi),		//phase - between -2pi and 2pi, 3hz
	SinOsc.ar(3, 0, 0.5, 0.5)	//mul - (amp) between 0 and 1, 3hz
)
}
)
a.play
a.stop

//phase modulation - we only changed from 3 to 30 for the freq of the phase sinosc
(
a.source= {SinOsc.ar(
	SinOsc.ar(0.3, 0, 20, 200),	//freq - between 180 and 220 hz, spinning at 0.3hz
	SinOsc.ar(30, 0, 2pi),		//phase - between -2pi and 2pi, 30hz
	SinOsc.ar(3, 0, 0.5, 0.5)	//mul - (amp) between 0 and 1, 3hz
)
}
)
a.play
a.stop

a.clear



//--audio+visual
(
w= Window("av", Rect(100, 100, 640, 480));
u= UserView(w, Rect(0, 0, 640, 480));
u.background= Color.black;
u.drawFunc= {
	80.do{|x|
		Pen.fillColor= Color.green(1, 0.5);
		Pen.fillOval(Rect(sin(x/80*2pi*f)*320+320, x/80*480, 12, 12));
	};
};
f= 1;
w.front;
)
//keep the window open


//run multiple times - each time a new random value for f (= freq)
(
a.play;
f= 10.rand;		//random integer between 0 and 9
a.source= {SinOsc.ar(f*200+400, 0, 0.1)};
u.refresh;
)

(
Routine({
	a.play;
	100.do{|x|
		f= x*0.04;
		a.source= {SinOsc.ar(f*200+400, 0, 0.1)};
		u.refresh;
		0.1.wait;
	};
}).play(AppClock);
)
a.stop


//better way to do it using a freq argument to the synth
(
a.source= {|freq| SinOsc.ar(freq*200+400, 0, 0.1)};
Routine({
	a.play;
	1000.do{|x|
		f= sin(x/100*2pi)*0.25;
		a.set(\freq, f);
		u.refresh;
		0.05.wait;
	};
}).play(AppClock);
)
a.stop
a.clear
w.close
