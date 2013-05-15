/*RUN*/				//this makes a document autostart


//good to have some comments at the top.  example...
//version for my gig at nk 28-30jan
//projector settings should be: 1920x1080, 60hz, adobe color profile
//sound is stereo


s.waitForBoot{		//first thing is to wrap code into a waitForBoot

//--here is my sound part
a= NodeProxy.new.play;
a.source= {PinkNoise.ar(LFNoise2.kr([0.2, 0.2], 0.5))};



//--here is my graphics
w= Window("test", Rect(101, 102, 1024, 768), false, false);	//here replace 101 and 102 with xy screen position
	//false false means make window not resizable and borderless
u= UserView(w, Rect(0, 0, w.bounds.width, w.bounds.height));
u.background= Color.black;
u.clearOnRefresh= false;
u.drawFunc= {
	x= w.bounds.width.rand;			//random x position
	y= w.bounds.height.rand;		//random y position
	z= 30.rand;				//random spread
	Pen.smoothing= true;	//use Pen.setSmoothing(true) if old sc
	Pen.fillColor= Color.hsv(x/499, y/499, 1, 1-(z/29));
	(z*50).do{
		Pen.fillRect(Rect(x.gauss(z).asInteger, y.gauss(z).asInteger, 1, 1));
	};
};
w.front;
Routine({while({w.isClosed.not}, {u.refresh; (1/60).wait})}).play(AppClock);

CmdPeriod.doOnce{if(w.isClosed.not, {w.close})};//close the window when cmd+.
w.onClose= {a.stop};	//stops the sound when i close the window
}

//remember to check:
//* energy savings / not letting the computer going to rest
//* screensaver off
//* keep wireless network off if unneeded (so no automatic updates / popups etc)
//* turn off file sharing
//* quit backgroud programs (also apps like dropbox, little snitch etc)
//* temporarily turn off spotlight search indexing and similar disk scanning apps
//* [advanced] disable cron jobs temporarily.  default they run 3:15 at night and sometimes you maybe are playing that late