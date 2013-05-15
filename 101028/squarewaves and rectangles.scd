//--101028 squarewaves and rectangles


s.boot

a= {LFPulse.ar(3000, 0, 0.5)}.play
a.release

{LFPulse.ar(3000, 0, 0.5)}.plot
{LFPulse.ar(300, 0.25, 0.5)}.plot

{LFPulse.ar(300, 0, 0.1)}.plot
{LFPulse.ar(300, 0, 0.9)}.plot


a= {LFPulse.ar(300, 0, MouseX.kr(0, 1))}.play
a.release

a= {LFPulse.ar(MouseY.kr(3, 3000), 0, MouseX.kr(0, 1))}.play
a.release



//--multiplying squarewaves

a= {LFPulse.ar(3000, 0, 0.2)*LFPulse.ar(2, 0, 0.1)}.play
a.release

a= {LFPulse.ar(4000, 0, 0.4)*LFPulse.ar(2, 0, 0.7)*LFPulse.ar(1.4, 0, 0.3)}.play
a.release


//--adding squarewaves

{LFPulse.ar(300, 0, 0.4)+LFPulse.ar(220, 0, 0.8)/2}.plot

a= {LFPulse.ar(300, 0, 0.4)+LFPulse.ar(220, 0, 0.8)/2}.play
a.release

a= {LFPulse.ar(4000, 0, 0.7)+LFPulse.ar(200, 0, 0.4)+LFPulse.ar(80, 0, 0.1)/3}.play
a.release


//--looking at the waveform
//first quit server localhost by clicking 'quit'
//then click 'boot' on the internal server
//last click 'default' also on the internal server
s.scope
s.freqscope



//--stereo

a= {Pan2.ar(LFPulse.ar(4000, 0, 0.7), -1) + Pan2.ar(LFPulse.ar(200, 0, 0.4), 0) + Pan2.ar(LFPulse.ar(80, 0, 0.1), 1)/3}.play
a.release


//--using a squarewave as panning position

a= {Pan2.ar(LFPulse.ar(400, 0, 0.2), LFPulse.ar(4, 0, 0.3).range(-1, 1))}.play
a.release


//--using squarewaves modulating many arguments

a= {Pan2.ar(LFPulse.ar( LFPulse.ar(MouseX.kr(0, 10), 0, 0.1).range(400, 800), 0, 0.2), 0)}.play
a.release

a= {Pan2.ar(LFPulse.ar( LFPulse.ar(MouseX.kr(0, 30), 0, 0.4).range(300, 400), 0, LFPulse.ar(0.4, 0, 0.2)), LFPulse.ar(4, 0, 0.5).range(-1, 1))}.play
a.release



//--using arguments for external control

a= {|tempo= 2, hello= 3| Pan2.ar(LFPulse.ar( LFPulse.ar(tempo, 0, 0.4).range(300, 400), 0, LFPulse.ar(hello, 0, 0.2)), LFPulse.ar(4, 0, 0.5).range(-1, 1))}.play

a.set(\tempo, 6)
a.set(\hello, 17)
a.set(\tempo, 1.3)
a.release


//--

(
w= Window("rect1", Rect(100, 100, 640, 480));
w.front;
u= UserView(w, Rect(0, 0, 640, 480));
u.background= Color.white;

u.drawFunc= {
	Pen.strokeColor= Color.blue(1, 0.5);
	Pen.addRect(Rect(20, 30, 40, 50));
	Pen.stroke;
};
)


(
u.drawFunc= {
	Pen.strokeColor= Color.blue(1, 0.5);
	100.do{|x|		//x becomes a counter 0-9
		Pen.addRect(Rect(x*5, x*4, 30, 15));//posx, posy, width, height
	};
	Pen.stroke;
};
u.refresh;
)


(
u.drawFunc= {
	Pen.strokeColor= Color.red(1, 0.5);
	Pen.width= 2;
	30.do{|x|
		Pen.addRect(Rect(x*10, x*9, 100, 100));
	};
	Pen.stroke;
};
u.refresh;
)

	
(
u.drawFunc= {
	Pen.fillColor= Color.green(0.5, 0.3);
	50.do{|x|
		Pen.addRect(Rect(x*14, x*12, x*1, x*2));
	};
	//Pen.fill;
	Pen.draw(1);	//0-4, default is 0, see SCPen helpfile
};
u.refresh;
)


//--audio+visual


(
a= {|tempo= 2, freq= 500, nada= 10| Pan2.ar(LFPulse.ar( LFPulse.ar(nada, 0, 0.2).range(freq, freq*2))*LFPulse.ar(tempo, 0, 0.2), LFPulse.ar(4.3, 0, 0.2).range(-1, 1))}.play
)

(
var tempo= 4, freq= 120, nada= 40;//repeatedly change these and run again
a.set(\tempo, tempo, \freq, freq, \nada, nada);
u.drawFunc= {
	Pen.fillColor= Color.grey(0.2, 0.6);
	Pen.width= 1;
	freq.do{|x|
		Pen.addRect(Rect(x*tempo%640, x*nada%480, nada, nada*x));
	};
	Pen.draw(4);
};
u.refresh;
)


(
var tempo= 14, freq= 120, nada= 40;//repeatedly change these and run again
a.set(\tempo, tempo, \freq, freq, \nada, nada);
u.drawFunc= {
	Pen.fillColor= Color.grey(0.2, 0.6);
	Pen.width= 1;
	freq.do{|x|
		Pen.addRect(Rect(x*tempo%640, x*nada%480, nada, nada*x));
	};
	Pen.draw(4);
};
u.refresh;
)

(
var tempo= 14, freq= 1200, nada= 40;//repeatedly change these and run again
a.set(\tempo, tempo, \freq, freq, \nada, nada);
u.drawFunc= {
	Pen.fillColor= Color.grey(0.2, 0.6);
	Pen.width= 1;
	freq.do{|x|
		Pen.addRect(Rect(x*tempo%640, x*nada%480, nada, nada*x));
	};
	Pen.draw(4);
};
u.refresh;
)

(
var tempo= 100, freq= 100, nada= 500;//repeatedly change these and run again
a.set(\tempo, tempo, \freq, freq, \nada, nada);
u.drawFunc= {
	Pen.fillColor= Color.grey(0.2, 0.6);
	Pen.width= 1;
	freq.do{|x|
		Pen.addRect(Rect(x*tempo%640, x*nada%480, nada, nada*x));
	};
	Pen.draw(4);
};
u.refresh;
)

(
var tempo= 1001, freq= 3.2, nada= 40;//repeatedly change these and run again
a.set(\tempo, tempo, \freq, freq, \nada, nada);
u.drawFunc= {
	Pen.fillColor= Color.grey(0.2, 0.6);
	Pen.width= 1;
	freq.do{|x|
		Pen.addRect(Rect(x*tempo%640, x*nada%480, nada, nada*x));
	};
	Pen.draw(4);
};
u.refresh;
)

(
var tempo= 66, freq= 66, nada= 66;//repeatedly change these and run again
a.set(\tempo, tempo, \freq, freq, \nada, nada);
u.drawFunc= {
	Pen.fillColor= Color.grey(0.2, 0.6);
	Pen.width= 1;
	freq.do{|x|
		Pen.addRect(Rect(x*tempo%640, x*nada%480, nada, nada*x));
	};
	Pen.draw(4);
};
u.refresh;
)

(
var tempo= 88, freq= 77, nada= 66;//repeatedly change these and run again
a.set(\tempo, tempo, \freq, freq, \nada, nada);
u.drawFunc= {
	Pen.fillColor= Color.grey(0.2, 0.6);
	Pen.width= 1;
	freq.do{|x|
		Pen.addRect(Rect(x*tempo%640, x*nada%480, nada, nada*x));
	};
	Pen.draw(4);
};
u.refresh;
)

a.release
w.close
