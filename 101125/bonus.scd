//bonus
(
var win= Window("midi bonus", Rect(100, 100, 600, 600), false);
var usr= UserView(win, Rect(0, 0, 600, 600));
var n= 50;		//number of balls
var speedx= 0.1;	//horizontal speed
var speedy= 0.1;	//vertical speed
var positions= {Point(300, 300)}.dup(n);	//experiment with random here like 600.rand
var cntx= 0, cnty= 0, spread= 100, distance= 1;
CCResponder.removeAll;
CCResponder({|src, chan, num, val|
	switch(num,	//change 2, 3, 4 and 5 to match your midi device
		2, {speedx= val.linlin(0, 127, 0, 1)},
		3, {speedy= val.linlin(0, 127, 0, 1)},
		4, {spread= val.linlin(0, 127, 3, 300)},
		5, {distance= val.linlin(0, 127, 0, 0.5)}
	);
});
usr.background= Color.black;
usr.drawFunc= {
	Pen.strokeColor= Color.white;
	positions.do{|pnt, i|
		var x= sin(cntx+(i*distance))*spread+pnt.x;
		var y= cos(cnty+(i*distance))*spread+pnt.y;
		Pen.strokeOval(Rect.aboutPoint(Point(x, y), i+1, i+1));
	};
	cntx= cntx+speedx;
	cnty= cnty+speedy;
};
win.front;
Routine({while({win.isClosed.not}, {usr.refresh; (1/60).wait})}).play(AppClock);
)
