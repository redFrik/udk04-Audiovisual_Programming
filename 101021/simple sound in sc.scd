//--simple sound in sc

a= {SinOsc.ar(MouseX.kr(500, 5000), 0, 0.4)}.play
a.release(0.5)


a= {SinOsc.ar(200, 0, 0.4)}.play
a.release(2)
a= {SinOsc.ar(300, 0, 0.3)}.play
a.release(2)
a= {SinOsc.ar(400, 0, 0.2)}.play
a.release(2)
a= {SinOsc.ar(500, 0, 0.1)}.play
a.release(2)


a= {BPF.ar(WhiteNoise.ar(1), MouseX.kr(500, 5000))}.play
a.release(1)


(
t= Task({
	100.do{|index|
		a= {SinOsc.ar([400, 500, 400.rand, 300].wrapAt(index), 0, 0.4)}.play;
		0.2.wait;
		a.release(0.1);
	};
});
t.play;
)
t.stop;


//--simple drawing in sc

(
w= Window("test", Rect(100, 100, 640, 480));
w.front;
u= UserView(w, Rect(0, 0, 640, 480));
u.background= Color.white;
u.drawFunc= {
	Pen.color= Color.grey;
	Pen.moveTo(Point(320, 240));
	Pen.lineTo(Point(100, 100));
	Pen.stroke;
};
)

//replaces drawing function while test window still open
//manual refresh
(
i= 0;
u.drawFunc= {
	Pen.color= Color.grey;
	Pen.moveTo(Point(320, 240));
	Pen.lineTo(Point([100, 200, 300, 400].wrapAt(i), 100));
	Pen.moveTo(Point(320, 240));
	Pen.lineTo(Point([100, 200, 300, 400].wrapAt(i), 200));
	Pen.stroke;
	i= i+1;
};
)

//automated refresh
(
t= Task({
	100.do{|index|
		a= {SinOsc.ar([400, 500, 600, 700].wrapAt(index), 0, 0.4)}.play;
		{u.refresh}.defer;
		0.5.wait;
		a.release(0.5);
		0.125.wait;
	};
});
t.play;
)




