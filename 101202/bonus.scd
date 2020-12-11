
//--example: receive osc data from the free mrmr iphone app (http://mrmr.noisepages.com/)
//(and there are many other iphone/ipod/ipad osc controller apps (touchOSC, msa remote, remokon etc)

//this example uses the 3d accelerometer to set frequencies and amplitude of a simple sound

//first download and install mrmr on the iphone/ipod (via app store)
//then connect the computer and the iphone to the same wifi network
//then find the ip of the computer (look in system preferences under network, advanced tcp/ip settings)
//enter this ip under 'server' in mrmr preferences
//also in mrmr settings edit the 'port' to be 57120
//the 'namespace' should be /mrmr, 'bundle message style' off, 'use float values' off, 'include device id' on.
//last check that 'player' is set to something that matches the respoders below.  i have it set to redPod
//now leave mrmr preferences by pressing 'home' and then start sending with 'play'

s.boot;
a= NodeProxy.new.play;
a.source= {|amp= 0, freq1= 400, freq2= 404| SinOsc.ar([freq1, freq2], 0, amp)};

(
o= [
	OSCresponder(nil, "/mrmr/accelerometerZ/10/redPod", {|t, r, m|
		("accelerometerZ"+m).postln;
		a.set(\amp, m[1].abs.linlin(0, 1000, 0, 1).clip(0, 1));
	}).add,

	OSCresponder(nil, "/mrmr/accelerometerY/10/redPod", {|t, r, m|
		("accelerometerY"+m).postln;
		a.set(\freq1, m[1].abs.linexp(0, 1000, 400, 800));
	}).add,

	OSCresponder(nil, "/mrmr/accelerometerX/10/redPod", {|t, r, m|
		("accelerometerX"+m).postln;
		a.set(\freq2, m[1].abs.linexp(0, 1000, 400, 800));
	}).add,

	OSCresponder(nil, "/mrmr/pushbutton/0/redPod", {|t, r, m|
		("pushbutton"+m).postln;
	}).add,
]
)

//now you should be able to control the sound with the iphone.
//accelerometer x and y set frequencies and z the amplitude
//there is also a responder for a single button but it only posts

//to stop you remove all the responders like this...
o.do{|resp| resp.remove}
//and stop the sound...
a.stop


//--troubleshooting...
//if it does not work then first test if there is any incoming osc data at all...

//start test.  will post all incoming osc data (code taken from the helpfile OSC_communication.html)
(
thisProcess.recvOSCfunc= {|time, addr, msg|
	if(msg[0].asString.contains("status.reply").not, {
		("time:"+time+"sender:"+addr+"\nmessage:"+msg).postln;
	});
};
)
//shake the iphone
//stop test.
thisProcess.recvOSCfunc= nil;

//if nothing was posted then the connection between the iphone and the computer is somehow not working
//double check the ip and port number.  also turn off any firewall that is blocking incoming network traffic.
//if you did get data posted then the problem is probably that the oscresponders do not match the addresses/tags correctly
//double check that the tag "/mrmr/accelerometerZ/10/redPod" is among the data posted, else modify it to fit your data and run the code again.




