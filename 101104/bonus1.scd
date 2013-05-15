(
w= Window("rect1", Rect(100, 100, 640, 480));
u= UserView(w, Rect(0, 0, 640, 480));
u.background= Color.white;
i= 0;	//used as theta
u.drawFunc= {
	5.do{|y|
		24.do{|x|
			Pen.fillColor= Color.blue(1, 1-(y/5));
			Pen.fillOval(Rect(cos(x/24*2pi+i+y)*320+320, sin(x/24*2pi+i+y)*240+240, 6, 6));
		};
	};
	i= i+0.01;
};
w.front;
Routine({while({w.isClosed.not}, {u.refresh; (1/60).wait})}).play(AppClock);
)
