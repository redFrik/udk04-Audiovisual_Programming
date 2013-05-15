(
s.latency= 0.05;		//recommended setting - at least don't use the default 0.2
s.waitForBoot{
	
	var width= 500, height= 500, t= 0, k= 0, speed= 0.03;
	var win= Window("bonus 3- balls", Rect(300, 300, width, height), false);
	var usr= UserView(win, Rect(0, 0, width, height));
	
	//--sound part
	a= NodeProxy.new.play;
	a.source= {|amp= 0.1, freq= 100, rq= 0.1| BPF.ar(WhiteNoise.ar(amp), freq, rq)!2};
	
	
	//--midi input part
	CCResponder.removeAll;		//clear out old responders - just for safty
	CCResponder({|src, ch, num, val|
		if(num==3, {
			speed= val.linexp(0, 127, 0.003, 3);
		});
	});
	
	//--graphics part
	usr.background= Color.white;
	usr.clearOnRefresh= false;
	usr.drawFunc= {
		var x= sin(t)*(sin(t*0.5)*width*0.4);
		var y= cos(t)*height*0.4;
		var rad= sin(t*2pi*0.5)*50+50;	//size
		Pen.translate(width*0.5, height*0.5);//offset drawing to middle of screen
		Pen.fillColor= Color.red((rad/100), 0.2);//red colour with some alpha
		Pen.fillOval(Rect.aboutPoint(Point(x, y), rad, rad));
		t= t+speed;
		k= k+0.02;
		a.set(\amp, rad/100, \freq, x.linexp(0, width, 500, 5000), \rq, y.linexp(0, height, 0.01, 2));
	};
	win.front;
	Routine({while({win.isClosed.not}, {usr.refresh; (1/60).wait})}).play(AppClock);
};
)