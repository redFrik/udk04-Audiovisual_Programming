//--noise and dots

1.0.rand		//float between 0.0 and 1.0
2.0.rand		//float between 0.0 and 2.0
2000.0.rand	//float between 0.0 and 2000.0
2000.rand		//integer between 0 and 1999
2.rand			//integer 0 or 1 - never 2

3.0.rrand(5.0)	//rangerand
4.0.rrand(8.0)	//rangerand float between 4.0 and 8.0
4.rrand(6)		//rangerand integer 4, 5 or 6

5.0.linrand				//biased towards 0
5-5.0.linrand			//biased towards 5
5.0.exprand(100.0)	//exponential distribution

see helpfile Randomness

a= {1.0.rand}.dup(100)		//create an array with 100 random floats
a.plot

a= {1.0.linrand}.dup(1000)	//1000 floats with more low numbers
a.plot

a= {0.1.exprand(0.5)}.dup(100)
a.plot

a.postcs			//use post cs to print the whole array

//random walk aka brown noise
l= 0;				//variable with last value
a= {l= l+0.25.rrand(-0.25)}.dup(100)
a.plot

l= 0;				//variable with last value
a= {l= l+0.4.rrand(-0.25)}.dup(100)	//unbalanced and it will climb upwards
a.plot

l= 0;				//variable with last value
a= {l= l+0.25.rrand(-0.4)}.dup(100)	//or climb downwards
a.plot


//gauss curve
//principle is to add random numbers and then take the average
//here the average of three -1 to 1 values.  result should be close to 0.0
1.0.rrand(-1.0) + 1.0.rrand(-1.0) + 1.0.rrand(-1.0) / 3

a= {1.0.rrand(-1.0)}.dup(100)	//array of 100 random numbers
a.mean		//get the average value of the numbers in the array

a= {1.0.rrand(-1.0)}.dup(10000)
a.mean		//the more numbers, the more close to 0.0

//there's a built in method called .gauss
10.0.gauss(0.5)		//center around 10.0 with 0.5 deviation
0.0.gauss(0.01)		//center around 0.0 with 0.01 deviation


//--draw 1000 dots at random position - upper half
(
w= Window("dot1", Rect(100, 100, 500, 500));
u= UserView(w, Rect(0, 0, 500, 500));
u.background= Color.white;
u.drawFunc= {
	Pen.smoothing_(false);
	1000.do{
		Pen.fillColor= Color.black;
		Pen.fillRect(Rect(500.rand, 250.rand, 2, 2));
	};
};
w.front;
)


//more dots in the lower right corner
(
w= Window("dot2", Rect(100, 100, 500, 500));
u= UserView(w, Rect(0, 0, 500, 500));
u.background= Color.white;
u.drawFunc= {
	Pen.smoothing_(false);
	1000.do{
		Pen.fillColor= Color.black;
		Pen.fillRect(Rect(500-500.linrand, 500-500.linrand, 2, 2));
	};
};
w.front;
)


//more dots in the middle
(
w= Window("dot3", Rect(100, 100, 500, 500));
u= UserView(w, Rect(0, 0, 500, 500));
u.background= Color.white;
u.drawFunc= {
	Pen.smoothing_(false);
	1000.do{
		Pen.fillColor= Color.black;
		Pen.fillRect(Rect(250.gauss(50).asInteger, 250.gauss(50).asInteger, 2, 2));
	};
};
w.front;
)


//have two centers
(
w= Window("dot4", Rect(100, 100, 500, 500));
u= UserView(w, Rect(0, 0, 500, 500));
u.background= Color.white;
u.drawFunc= {
	Pen.smoothing_(false);
	1000.do{
		Pen.fillColor= Color.black;
		Pen.fillRect(Rect(250.gauss(50).asInteger, 250.gauss(50).asInteger, 2, 2));
	};
	500.do{
		Pen.fillColor= Color.black;
		Pen.fillRect(Rect(55.gauss(20).asInteger, 55.gauss(20).asInteger, 2, 2));
	};
};
w.front;
)


//--
(
w= Window("dot5", Rect(100, 100, 500, 500));
u= UserView(w, Rect(0, 0, 500, 500));
u.background= Color.white;
u.drawFunc= {
	Pen.smoothing_(false);
	1000.do{|i|
		Pen.fillColor= Color.black;
		Pen.fillRect(Rect(i.linlin(0, 999, 0, 499).asInteger, i.linlin(0, 999, 0, 499).asInteger.rand, 2, 2));
	};
};
w.front;
)


//--start in the middle and spread out - version1
(
w= Window("dot6", Rect(100, 100, 500, 500));
u= UserView(w, Rect(0, 0, 500, 500));
u.background= Color.white;
u.drawFunc= {
	Pen.smoothing_(false);
	1000.do{|i|
		Pen.fillColor= Color.black;
		Pen.fillRect(Rect(i.linlin(0, 999, 0, 499).asInteger, 250+(i.rrand(0-i).linlin(-999, 999, -250, 250).asInteger), 2, 2));
	};
};
w.front;
)


//--start in the middle and spread out - version2
(
w= Window("dot7", Rect(100, 100, 500, 500));
u= UserView(w, Rect(0, 0, 500, 500));
u.background= Color.white;
u.drawFunc= {
	Pen.smoothing_(false);
	1000.do{|i|
		Pen.fillColor= Color.black;
		Pen.fillRect(Rect(i.linlin(0, 999, 0, 499).asInteger, 250.gauss(i.linlin(0, 999, 0, 50).asInteger), 2, 2));
	};
};
w.front;
)


//--
(
w= Window("grid", Rect(100, 100, 640, 480));
u= UserView(w, Rect(0, 0, 640, 480));
u.background= Color.black;
u.drawFunc= {
	Pen.fillColor= Color.white;
	Pen.smoothing_(false);		//also test with true
	160.do{|x|
		120.do{|y|
			Pen.fillRect(Rect(x.linlin(0, 160, 0, 640), y.linlin(0, 120, 0, 380), 2, 2));
		};
	};
};
w.front;
)


//--disrupt in lower right corner
(
w= Window("grid2", Rect(100, 100, 640, 480));
u= UserView(w, Rect(0, 0, 640, 480));
u.background= Color.black;
u.drawFunc= {
	Pen.fillColor= Color.white;
	Pen.smoothing= true;	//same as Pen.smoothing_(true)
	160.do{|x|
		120.do{|y|
			Pen.fillRect(Rect(x.linlin(0, 160, 0, 640)+0.gauss(x.linlin(0, 159, 0, 0.5)), y.linlin(0, 120, 0, 480)+0.gauss(y.linlin(0, 119, 0, 0.5)), 2, 2));
		};
	};
};
w.front;
)


//--also disrupt red rectangles
(
w= Window("grid3", Rect(100, 100, 640, 480));
u= UserView(w, Rect(0, 0, 640, 480));
u.background= Color.black;
u.drawFunc= {
	Pen.fillColor= Color.white;
	Pen.smoothing= true;
	160.do{|x|
		120.do{|y|
			Pen.fillRect(Rect(x.linlin(0, 159, 0, 640)+0.gauss(x.linlin(0, 159, 0, 0.5)), y.linlin(0, 119, 0, 480)+0.gauss(y.linlin(0, 119, 0, 0.5)), 2, 2));
		};
	};

	Pen.fillColor= Color.red;
	16.do{|x|
		12.do{|y|
			Pen.fillRect(Rect(
				x.linlin(0, 15, 0, 640)+0.gauss(x*0.2),
				y.linlin(0, 11, 0, 380)+0.gauss(y*0.2),
				20.gauss(x*0.2),		//red rectangle width
				20.gauss(y*0.2)		//red rectangle height
			));
		};
	};
};
w.front;
)



//--
//WhiteNoise is the same as 1.0.rrand(-1.0)

s.boot
a= NodeProxy.new.play
a.source= {WhiteNoise.ar(0.1)}
a.stop
{WhiteNoise.ar}.plot
a.play
a.source= {BrownNoise.ar(0.1)}
a.play
a.stop
{BrownNoise.ar}.plot

//WhiteNoise.ar(1)		//gives audio rate samples random values -1 to 1
//WhiteNoise.ar(0.1)	//gives audio rate samples random values -0.1 to 0.1


a.source= {PinkNoise.ar(0.1)}
a.play
a.stop
{PinkNoise.ar}.plot

a.source= {ClipNoise.ar(0.1)}
a.play
a.stop
{ClipNoise.ar}.plot

a.source= {GrayNoise.ar(0.1)}
a.play
a.stop
{GrayNoise.ar}.plot

a.source= {LFNoise0.ar(400, 0.1)}
a.play
a.stop
{LFNoise0.ar(400, 0.5)}.plot(0.1)
{LFNoise1.ar(400, 0.5)}.plot(0.1)
{LFNoise2.ar(400, 0.5)}.plot(0.1)


//ambient noise patch...
a.fadeTime= 4	//crossfade time 4sec
a.play
a.source= {WhiteNoise.ar(0.1)}
a.source= {PinkNoise.ar(0.3)}
a.source= {BrownNoise.ar(0.1)}
a.source= {GrayNoise.ar(0.1)}
a.source= {ClipNoise.ar(0.1)}
a.stop(10)		//fade out time 10sec

//using an lowfrequency noise ugen as controller
a.play
b= NodeProxy.new
b.source= {LFNoise2.ar(2)}
a.source= {WhiteNoise.ar(b*0.1)}
a.source= {PinkNoise.ar(b*0.3)}
a.source= {BrownNoise.ar(b*0.1)}
a.source= {GrayNoise.ar(b*0.1)}
a.source= {ClipNoise.ar(b*0.1)}
b.source= {LFNoise1.ar(7)}	//change controller
b.source= {LFNoise0.ar(2)}
b.source= {PinkNoise.ar(1)}	//pink noise controlling a
b.source= {WhiteNoise.ar(1)}	//white noise controlling a
a.stop

//amplitude controlled by a lowfrequency noise
a.source= {SinOsc.ar(500, 0, LFNoise2.ar(2)*0.1)}
a.play
a.source= {SinOsc.ar(500, 0, LFNoise1.ar(7)*0.1)}
a.source= {SinOsc.ar(500, 0, LFNoise0.ar(2)*0.1)}
a.source= {SinOsc.ar(500, 0, LFNoise0.ar(5)*0.1)}//faster updaterate (5hz) for lowfrequency noise
a.source= {SinOsc.ar(500, 0, LFNoise0.ar(5).clip(0, 1)*0.1)}//block negatives from lfnoise0
a.stop

//frequency controlled by a lowfrequency noise
a.source= {SinOsc.ar(500*LFNoise2.ar(2), 0, 0.1)}//frequency varies between -500 and 500 hz
a.play
a.source= {SinOsc.ar(500+LFNoise2.ar(2, 100), 0, 0.1)}//frequency varies between 400 and 600 hz
a.stop

//fast variation in frequency using the 'jumping' lfnoise0
a.source= {SinOsc.ar(500+LFNoise0.ar(10, 50), 0, 0.1)}
a.play
a.stop

//using a line to go from 0 to +-100 variation in frequency
a.fadeTime= 0
a.source= {SinOsc.ar(500+LFNoise0.ar(10, Line.ar(0, 100, 10)), 0, 0.1)}
a.play
a.stop

//using another LFNoise to control the amount of variation
a.source= {SinOsc.ar(500+LFNoise0.ar(10, LFNoise2.ar(1, 100)), 0, 0.1)}
a.play
a.stop

//low pass filtering
a.source= {WhiteNoise.ar(0.1)}//unfiltered signal
a.play
a.source= {LPF.ar(WhiteNoise.ar(0.5), 900)}//filter out frequencies above 900hz
a.source= {LPF.ar(WhiteNoise.ar(0.5), 700)}
a.source= {LPF.ar(WhiteNoise.ar(0.5), 500)}
a.source= {LPF.ar(WhiteNoise.ar(0.5), 300)}
a.stop


//high pass filtering
a.source= {WhiteNoise.ar(0.1)}
a.play
a.source= {HPF.ar(WhiteNoise.ar(0.5), 900)}//filter out frequencies below 900hz
a.source= {HPF.ar(WhiteNoise.ar(0.5), 1200)}
a.source= {HPF.ar(WhiteNoise.ar(0.5), 2000)}
a.source= {HPF.ar(WhiteNoise.ar(0.5), 7000)}
a.stop


//band pass filtering
a.source= {WhiteNoise.ar(0.1)}
a.play
a.source= {BPF.ar(WhiteNoise.ar(0.5), 900, 0.1)}//filter out everything but around 900hz, 0.1 is the spread
a.source= {BPF.ar(WhiteNoise.ar(0.5), 900, 0.9)}
a.source= {BPF.ar(WhiteNoise.ar(0.5), 900, 2)}
a.source= {BPF.ar(WhiteNoise.ar(0.5), 2000, 0.1)}
a.source= {BPF.ar(WhiteNoise.ar(0.5), 7000, 0.05)}
a.stop

//band reject filtering
a.source= {WhiteNoise.ar(0.1)}
a.play
a.source= {BRF.ar(WhiteNoise.ar(0.5), 900, 0.1)}//filter out at 900hz, 0.1 is the spread
a.source= {BRF.ar(WhiteNoise.ar(0.5), 900, 0.9)}
a.source= {BRF.ar(WhiteNoise.ar(0.5), 900, 2)}
a.source= {BRF.ar(WhiteNoise.ar(0.5), 2000, 0.1)}
a.source= {BRF.ar(WhiteNoise.ar(0.5), 7000, 0.05)}
a.stop


