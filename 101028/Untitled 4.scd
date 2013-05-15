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
a= {|tempo= 2, freq= 500, nada= 10| Pan2.ar(LFPulse.ar( LFPulse.ar(nada, 0, 0.2).range(freq, freq*2))*LFPulse.ar(tempo, 0, 0.2), LFPulse.ar(4.3, 0, 0.2).range(-1, 1))}.play
)

(
~tempo= 4;
~freq= 120;
~nada= 40;
u.drawFunc= {
	Pen.fillColor= Color.grey(0.2, 0.6);
	Pen.width= 1;
	~freq.do{|x|
		Pen.addRect(Rect(x*~tempo%640, x*~nada%480, ~nada, ~nada*x));
	};
	Pen.draw(4);
	a.set(\tempo, ~tempo, \freq, ~freq, \nada, ~nada);
};
u.refresh;
)

c.remove;
c= CCResponder({|src, chan, num, val|
	switch(num.postln,
		2, {~tempo= val.linlin(0, 127, 0, 4)},
		3, {~freq= val.linexp(0, 127, 1, 1000)},
		4, {~nada= val.linlin(0, 127, 0, 45)}
	);
	{u.refresh}.defer;
});