(
w= Window("animation1", Rect(100, 100, 500, 500));
u= UserView(w, Rect(0, 0, 500, 500));
u.background= Color.white;
i= 0;		//counter
u.clearOnRefresh= false;		//don't erase previous frame when refreshing
u.drawFunc= {
	if(i<500, {					//only draw within the window
		Pen.smoothing= false;	//use Pen.setSmoothing(false) if old sc
		Pen.fillColor= Color.black;
		Pen.fillRect(Rect(i, 250.gauss(10).asInteger, 2, 2));
		i= i+1;
	});
};
w.front;
Routine({while({w.isClosed.not}, {u.refresh; (1/25).wait})}).play(AppClock);
)


(
w= Window("animation2", Rect(100, 100, 500, 500));
u= UserView(w, Rect(0, 0, 500, 500));
u.background= Color.white;
i= 0;		//counter
l= 0;		//last value
u.clearOnRefresh= false;		//don't erase previous frame when refreshing
u.drawFunc= {
	if(i<500, {					//only draw within the window
		Pen.smoothing= false;	//use Pen.setSmoothing(false) if old sc
		Pen.fillColor= Color.black;
		Pen.fillRect(Rect(i, 250, 1, l));
		i= i+1;
		l= l+1.rrand(-1);
	});
};
w.front;
Routine({while({w.isClosed.not}, {u.refresh; (1/60).wait})}).play(AppClock);
)



(
//let run for a little while
w= Window("animation3", Rect(100, 100, 500, 500));
u= UserView(w, Rect(0, 0, 500, 500));
u.background= Color.white;
u.clearOnRefresh= false;		//don't erase previous frame when refreshing
u.drawFunc= {
	x= 500.rand;			//random x position
	y= 500.rand;			//random y position
	z= 30.rand;				//random spread
	Pen.smoothing= true;	//use Pen.setSmoothing(true) if old sc
	Pen.fillColor= Color.hsv(x/499, y/499, 1, 1-(z/29));//pick colour depending on position and set alpha depending on spread
	200.do{
		Pen.fillRect(Rect(x.gauss(z).asInteger, y.gauss(z).asInteger, 1, 1));
	};
};
w.front;
Routine({while({w.isClosed.not}, {u.refresh; (1/60).wait})}).play(AppClock);
)
