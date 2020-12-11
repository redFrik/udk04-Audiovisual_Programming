//--osc input


//basically there are 4 ways to get data into supercollider...
//MIDI, UDP, SERIAL, HID

CCResponder					//midi controller input (also NoteOnResponder etc)
OSCresponder				//udp (wifi network) input
SerialPort					//serial data from sensors (arduino)
HIDDeviceService/GeneralHID //hid gamepad/joystick via usb connection


//--recap from last week - midi control input
(
CCResponder({|src, chan, num, val|
	//if(chan==1, {		//optional filter that only listens to channel 1
		("hello i'm controller number"+num+"with value"+val).postln;
	//});
});
)
CCResponder.removeAll


//--new this week - opensound control input
(
OSCresponder(nil, \thursday, {|t, r, msg|
	("hello"+msg).postln;
}).add;
)

n= NetAddr("169.254.197.220", 57120); //ip and port number
n.sendMsg(\thursday, 1, 2, 3, 4, 5);  //send the message to the responder above
n.sendMsg(\thursday, 500.rand, "fffff");
//replace "169.254.197.220" with your current ip number
//on mac osx.5.8 you can find this number in system preferences->network->advanced->tcp/ip settings.
//optionally another way to send to yourself (and also between different applications on the same computer) is to use the loopback ip address "127.0.0.1".
//to send to another computer you need to have the computers connected to the same network and enter that computer's ip in the NetAddr above.



//--big system sketch...

// big system= computer with soundcard (8channel sound) and big projection

// clients= laptop+midicontoller

//clients can connect to big system via oscresponder/netaddr and send midi-like data


//first the client code...
n= NetAddr("169.254.197.220", 57120);//ip here should be the ip of the big system (use your own ip if you want to test locally)
(
CCResponder({|src, chan, num, val|
	n.sendMsg(\midi, \fred, num, val).postln;
})
)
//this responder just takes any midi controller and sends out its number and value as osc data.  replace \fred with your own name


//big system code (projection+speakers)...
a= NodeProxy.new.play;
(
a.source= {|freq1, freq2, freq3, freq4, amp= 0.3|
	Splay.ar(SinOsc.ar([freq1,freq2, freq3, freq4], 0, amp));
};
)
(
o= OSCresponder(nil, \midi, {|t, r, msg|
	msg.postln;
	if(msg[1]==\nat, {a.set(\freq1, msg[3].midicps)}); //here only \nat can control freq1
	if(msg[1]==\flo, {a.set(\freq2, msg[3].midicps)});
	if(msg[1]==\annie, {a.set(\freq3, msg[3].midicps)});
	if(msg[1]==\fred, {a.set(\freq4, msg[3].midicps)}); //and \fred freq4
}).add;
)
//different people are set to control different frequencies




//--collecting some ip numbers in class...
//olga - 194.95.203.236
//flo - 194.95.203.200
//nat - 194.95.203.177
m= NetAddr("194.95.203.236", 57120)
m.sendMsg(\midi, \fred, 1, 127.rand)
f= NetAddr("194.95.203.200", 57120)
f.sendMsg(\midi, \fred, 1, 127.rand)
n= NetAddr("194.95.203.177", 57120)
n.sendMsg(\midi, \fred, 1, 127.rand)




//--another big system...
(
//expected message (protocol) is: \talk, name, dataseq
o= OSCresponder(nil, \talk, {|t, r, msg|
	msg.postln;
	if(msg[1]==\anonym_but_me, {
		Pbind(\instrument, \i1, \midinote, Pseq(msg[2].asString.ascii), \dur, 0.1, \pan, -1).play;

	}, {
		if(msg[1]==\annie, {
			Pbind(\instrument, \i2, \midinote, Pseq(msg[2].asString.ascii), \dur, 0.1, \pan, 1).play;
		}, {
			if(msg[1]==\flo, {
				Pbind(\instrument, \i3, \midinote, Pseq(msg[2].asString.ascii), \dur, 0.1, \pan, 1).play;
			}, {
			Pbind(\instrument, \default, \midinote, Pseq(msg[2].asString.ascii), \dur, 0.1).play;
			});
		});
	});
}).add
)

//and the client code...
CCResponder.removeAll;	//delete previous
(
CCResponder({|src, chan, val, num|
	n.sendMsg(\talk, \name, num, val);
});
)

(
SynthDef(\i1, {|freq= 400, amp= 0.1, atk= 0.01, rel= 0.1|
	var env= EnvGen.kr(Env.perc(atk, rel), doneAction:2);
	var src= SinOsc.ar(0, SinOsc.ar(freq, 0, 2pi), amp);
	Out.ar(0, Pan2.ar(src*env, 0));
}).add;
SynthDef(\i2, {|freq= 400, amp= 0.1, atk= 0.01, rel= 0.1|
	var env= EnvGen.kr(Env.perc(atk, rel), doneAction:2);
	var src= Saw.ar(freq, amp);
	Out.ar(0, Pan2.ar(src*env, 0));
}).add;
SynthDef(\i3, {|freq= 400, amp= 0.1, atk= 0.01, rel= 0.1|
	var env= EnvGen.kr(Env.perc(atk, rel), doneAction:2);
	var src= BPF.ar(WhiteNoise.ar(amp*4), freq);
	Out.ar(0, Pan2.ar(src*env, 0));
}).add;
)



//--graphics
d= ();		//create new empty dictionary (key, val)
(
o= OSCresponder(nil, \graf, {|t, r, msg|
	msg.postln;
	d.put(msg[1], msg[2]);
}).add;
)

n.sendMsg(\graf, \fred, 1)

d		//if the message was received the name \fred and value 1 will now be in dictionary d.
d[\fred]	//and this is how you ask for the value at key \fred


//this example will simply show what is in d
(
var win= Window("osc test1", Rect(100, 100, 640, 480));
var usr= UserView(win, Rect(0, 0, 640, 480));
usr.background= Color.blue;
usr.drawFunc= {
	d.keysValuesDo{|key, val, i|
		var x= i.linlin(0, d.size, 0, 640);
		var y= val.clip(0, 127).linlin(0, 127, 0, 480);
		Pen.fillColor= Color.white;
		Pen.fillOval(Rect(x, y, 40, 40));
		Pen.fillColor= Color.black;
		Pen.stringAtPoint(key.asString, Point(x, y));
	};
};
win.front;
Routine({while({win.isClosed.not}, {usr.refresh; (1/25).wait})}).play(AppClock);
)





//and last let us add some more data
e= ();	//create a new dictionary
CCResponder.removeAll;
(
c= CCResponder({|src, chan, num, val|
	n.sendMsg(\graf, \fred, val);//convert from midi to osc
});
)

//rewrite the osc responder to also add time (t) to the dictionary
(
o= OSCresponder(nil, \graf, {|t, r, msg|
	msg.postln;
	e.put(msg[1], [msg[2], t]);
}).add;
)

(
var win= Window("osc test", Rect(100, 100, 640, 480));
var usr= UserView(win, Rect(0, 0, 640, 480));
usr.background= Color.blue;
usr.drawFunc= {
	e.keysValuesDo{|key, val, i|
		var x= i.linlin(0, d.size, 0, 640);
		var y= val[0].clip(0, 127).linlin(0, 127, 0, 480);
		Pen.fillColor= Color.white;
		Pen.fillOval(Rect(x, y, 40, 40));
		Pen.fillColor= Color.black;
		Pen.stringAtPoint(key.asString, Point(x, y));
		Pen.stringAtPoint(val[0].asString, Point(x, y)+20);
		Pen.stringAtPoint(val[1].asString, Point(x, y)+40);
	};
};
win.front;
Routine({while({win.isClosed.not}, {usr.refresh; (1/25).wait})}).play(AppClock);
)

