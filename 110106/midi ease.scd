//language side smoothing of midi input
(
var width= 500, height= 500, midix= 63, midiy= 63, posx= 0, posy= 0;
var win= Window("midi ease", Rect(300, 300, width, height), false);
var usr= UserView(win, Rect(0, 0, width, height));
usr.background= Color.white;
usr.drawFunc= {
	Pen.fillColor= Color.red;
	Pen.fillOval(Rect(posx.linlin(0, 127, 0, width), posy.linlin(0, 127, 0, height), 20, 20));
};
win.front;
CmdPeriod.doOnce({if(win.isClosed.not, {win.close})});
Routine({while({win.isClosed.not}, {usr.refresh; (1/40).wait})}).play(AppClock);

Routine({
	inf.do{
		posx= posx-(posx-midix*0.1);	//0.1 is smoothness
		posy= posy-(posy-midiy*0.04);	//0.04 is more smooth
		(1/40).wait;
	};
}).play;
CCResponder.removeAll;
CCResponder({|src, chan, num, val|
	[src, chan, num, val].postln;
	switch(num,
		2, {midix= val},	//edit to match your controller
		3, {midiy= val}	//edit to match your controller
	);
});
)