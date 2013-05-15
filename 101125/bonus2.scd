s.boot;

//bonus2
(
var win= Window("midi bonus2", Rect(100, 100, 600, 600), false);
var usr= UserView(win, Rect(0, 0, 600, 600));
var n= 40;		//number of lines
var speedx= 0.1;	//horizontal speed
var speedy= 0.1;	//vertical speed
var positions= {Point(300, 300)}.dup(n);	//experiment with random here like 600.rand
var cntx= 0, cnty= 0, widthx= 1, widthy= 1, distancex= 0.1, distancey= 0.1;
var snd;
CCResponder.removeAll;
CCResponder({|src, chan, num, val|
	switch(num,	//change 2, 3, 4, 5, 6 and 8 to match your midi device
		2, {speedx= val.linlin(0, 127, 0, 0.1); snd.set(\fmx, val.linexp(0, 127, 1, 1000))},
		3, {speedy= val.linlin(0, 127, 0, 0.1); snd.set(\fmy, val.linexp(0, 127, 1, 1000))},
		4, {widthx= val.linlin(0, 127, 0, 6); snd.set(\ampx, val.linlin(0, 127, 0, 1))},
		5, {widthy= val.linlin(0, 127, 0, 6); snd.set(\ampy, val.linlin(0, 127, 0, 1))},
		6, {distancex= val.linlin(0, 127, 0, 1); snd.set(\dx, val.linexp(0, 127, 1, 1000))},
		8, {distancey= val.linlin(0, 127, 0, 1); snd.set(\dy, val.linexp(0, 127, 1, 1000))}
	);
});
usr.background= Color.black;
usr.drawFunc= {
	Pen.strokeColor= Color.white;
	Pen.smoothing= false;
	positions.do{|pnt, i|
		var x= sin(cntx+(i*distancex))*300+pnt.x;
		var y= cos(cnty+(i*distancey))*300+pnt.y;
		Pen.width= widthy;
		Pen.moveTo(Point(0, y));
		Pen.lineTo(Point(600, y));
		Pen.stroke;
		Pen.width= widthx;
		Pen.moveTo(Point(x, 0));
		Pen.lineTo(Point(x, 600));
		Pen.stroke;
	};
	cntx= cntx+speedx;
	cnty= cnty+speedy;
};
win.front;
win.onClose= {snd.stop};
snd= NodeProxy.new.play;
snd.source= {|fmx= 1, fmy= 1, ampx= 0, ampy= 0, dx= 0, dy= 1|
	LeakDC.ar(SinOsc.ar(0, SinOsc.ar([dx.lag(0.1), dy.lag(0.1)], 0, [fmx.lag(0.1), fmy.lag(0.1)]), [ampx.lag(0.1), ampy.lag(0.1)]));
};

usr.animate= true;
//replace the above line on linux and windows with this line...
//Routine({while({win.isClosed.not}, {usr.refresh; (1/60).wait})}).play(AppClock);
)
