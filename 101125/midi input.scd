//--midi input


//for these examples you will need some sort of midi input.  either from a hardware midi controller (keyboard, nanokontrol, etc), or you can send midi from another program on the same computer

//here is a little virtual midi keyboard if you do not have anything else
//mac osx
http://www.fredrikolofsson.com/software/vmk16osx.zip
//windows
http://www.fredrikolofsson.com/software/vmk16win.zip
//for windows you will need to install midi yoke to send midi between applications
//it sends only one midi controller - number 1.

//it is also recommended to first connect the midi device (hard or software) before you start supercollider.  recompile sc can also help if you loose midi connection




//post asdf when any midi control message arrives
(
c= CCResponder({|src, chan, num, val|
	"asdf....".postln;
})
)
CCResponder.removeAll	//remove and clear all responders


//post the number of the incomming midi control message
(
c= CCResponder({|src, chan, num, val|
	num.postln;
})
)
c.remove		//remove this responder



//with switch we can filter out or do different things depending on the control number
//you might need to adapt the controller numbers 9, 2 or 1 below to match what your midi device is sending (see testpatch below)
(
c= CCResponder({|src, chan, num, val|
	switch(num,
		9, {"this is controller number 9"},
		2, {"num 2 posts something else".postln},
		1, {"asdf".postln}
	);
})
)
c.remove



//--a midi input test patch
//test 3 different things: controllers, note-on and pitch-bend inputs
(
CCResponder.removeAll;
CCResponder({|src, chan, num, val|
	"controller".post;
	[num, val].postln;
});

NoteOnResponder.removeAll;
NoteOnResponder({|src, chan, num, val|
	"noteOn".post;
	[num, val].postln;
});

BendResponder.removeAll;
BendResponder({|src, chan, num|
	"bend".post;
	[num].postln;
});
)


//--
s.boot
CCResponder.removeAll;
a= NodeProxy.new.play
a.source= {|amp= 0.1| SinOsc.ar([400, 404], 0, amp)}
a.set(\amp, 0)	//turns down the amplitude

//use controller number 1 to set amplitude
//use the midi test patch above to see which controller number and change the 1 below to some controller that you have
(
CCResponder({|src, chan, num, val|
	switch(num,
		1, {a.set(\amp, val.linlin(0, 127, 0, 1))}
	);
})
)
CCResponder.removeAll;
a.stop



//adding more control over the sound
a= NodeProxy.new.play
a.source= {|amp= 0.1, freq= 400| SinOsc.ar([freq, freq+4], 0, amp)}
//now we can also set the freq
a.set(\freq, 600)
a.set(\amp, 0)
CCResponder.removeAll;
(
CCResponder({|src, chan, num, val|
	switch(num,
		1, {a.set(\amp, val.linlin(0, 127, 0, 1))},
		2, {a.set(\freq, val.linexp(0, 127, 100, 4000))}
	);
})
)



//if you listen carefully as you turn the freq controller (slow), you might hear that it is not continuous but moves in steps.  we are mapping 128 values to the range 200-4000.  and generally this is a problem with midi - the resolution is bad - only 7 bits for controllers and noteOns.
//so midi sometimes needs to be smoothed out.  here we do it using .lag
a.source= {|amp= 0.1, freq= 400| SinOsc.ar([freq.lag(0.2), freq.lag(0.2)+4], 0, amp.lag(0.1))}

//lag will make the midi input smoother but also add latency (reacting slower)

CCResponder.removeAll;
a.stop



//--
a= NodeProxy.new.play
a.source= {|amp= 0.1, freq= 400| SinOsc.ar([freq.lag(0.2), freq.lag(0.2)+4], 0, amp.lag(0.1))}
NoteOnResponder.removeAll;
(
NoteOnResponder({|src, chan, num, val|
	[num, val].postln;
	//a.set(\freq, num.linexp(0, 127, 200, 2000));
	a.set(\freq, num.midicps, \amp, 0.5);
})
)

//adding a note off responder that turns down amp as the note is released
NoteOffResponder.removeAll;
(
NoteOffResponder({|src, chan, num, val|
	[num, val].postln;
	//a.set(\freq, num.linexp(0, 127, 200, 2000));
	a.set(\amp, 0);
})
)

a.stop;
NoteOffResponder.removeAll;
NoteOnResponder.removeAll;





//--
(
var win= Window("midi test1", Rect(100, 100, 600, 600));
var usr= UserView(win, Rect(0, 0, 600, 600));
var x= 100, y= 100;
CCResponder.removeAll;
CCResponder({|src, chan, num, val|
	switch(num,	//change 2 and 3 to match your midi device
		2, {x= val.linlin(0, 127, 0, 600)},
		3, {y= val.linlin(0, 127, 0, 600)}
	);
});
usr.background= Color.white;
usr.drawFunc= {
	Pen.fillColor= Color.grey;
	Pen.fillOval(Rect(x, y, 30, 30));
};
win.front;
Routine({while({win.isClosed.not}, {usr.refresh; (1/30).wait})}).play(AppClock);
)




(
var win= Window("midi test2", Rect(100, 100, 600, 600));
var usr= UserView(win, Rect(0, 0, 600, 600));
var x= 100, y= 100, r= 30;
CCResponder.removeAll;
CCResponder({|src, chan, num, val|
	switch(num,	//change 2, 3 and 4 to match your midi device
		2, {x= val.linlin(0, 127, 0, 600)},
		3, {y= val.linlin(0, 127, 0, 600)},
		4, {r= val.linlin(0, 127, 0, 100)}
	);
});
usr.background= Color.white;
usr.drawFunc= {
	Pen.fillColor= Color.grey;
	Pen.fillOval(Rect(x, y, r, r));
};
win.front;
Routine({while({win.isClosed.not}, {usr.refresh; (1/30).wait})}).play(AppClock);
)



//more advanced mappping
(
var win= Window("midi test3", Rect(100, 100, 600, 600));
var usr= UserView(win, Rect(0, 0, 600, 600));
var speed= 0.01, cnt= 0;
CCResponder.removeAll;
CCResponder({|src, chan, num, val|
	switch(num,	//change 2 to match your midi device
		2, {speed= val.linlin(0, 127, 0, 0.1)}
	);
});
usr.background= Color.white;
usr.drawFunc= {
	var x;
	cnt= cnt+speed;
	x= sin(cnt*2pi).linlin(-1, 1, 0, 600);
	Pen.fillColor= Color.grey;
	Pen.fillOval(Rect(x, 300, 30, 30));
};
win.front;
Routine({while({win.isClosed.not}, {usr.refresh; (1/30).wait})}).play(AppClock);
)





//even more advanced mappping - zigzag
(
var win= Window("midi test4", Rect(100, 100, 600, 600));
var usr= UserView(win, Rect(0, 0, 600, 600));
var srcx= 100, srcy= 100, r= 30, dstx= 100, dsty= 100;
var i= 0.5, j= 0.5;		//current interpolation
CCResponder.removeAll;
CCResponder({|src, chan, num, val|
	switch(num,	//change 2 and 3 to match your midi device
		2, {
			if(val==0, {dstx= 600.rand});
			if(val==127, {srcx= 600.rand});
			i= val.linlin(0, 127, 0, 1);
			if(val==0, {dsty= 600.rand});
			if(val==127, {srcy= 600.rand});
			j= val.linlin(0, 127, 0, 1);
		},
		3, {r= val.linlin(0, 127, 0, 100)}
	);
});
usr.background= Color.white;
usr.drawFunc= {
	Pen.fillColor= Color.grey;
	Pen.fillOval(Rect(i.linlin(0, 1, srcx, dstx), j.linlin(0, 1, srcy, dsty), r, r));
};
win.front;
Routine({while({win.isClosed.not}, {usr.refresh; (1/30).wait})}).play(AppClock);
)





