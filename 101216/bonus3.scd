(
s.latency= 0.05;
s.waitForBoot{
	var width= 500, height= 500, t= 0, k= 0;
	var win= Window("bonus 3- balls", Rect(300, 300, width, height), false);
	var usr= UserView(win, Rect(0, 0, width, height));
	a= NodeProxy.new.play;
	a.source= {|amp= 0.1, freq= 100, rq= 0.1| BPF.ar(WhiteNoise.ar(amp), freq.poll, rq)!2};
	usr.background= Color.white;
	usr.clearOnRefresh= false;
	usr.drawFunc= {
		var x= sin(t)*(sin(t*0.5)*width*0.4);
		var y= cos(t)*height*0.4;
		var rad= sin(t*2pi*0.5)*50+50;	//size
		Pen.translate(width*0.5, height*0.5);//offset drawing to middle of screen
		Pen.fillColor= Color.red((rad/100), 0.2);//red colour with some alpha
		Pen.fillOval(Rect.aboutPoint(Point(x, y), rad, rad));
		t= t+0.03;
		k= k+0.02;
		a.set(\amp, rad/100, \freq, x.linexp(0, width, 500, 5000), \rq, y.linexp(0, height, 0.01, 2));
	};
	win.front;
	Routine({while({win.isClosed.not}, {usr.refresh; (1/60).wait})}).play(AppClock);
};
)
