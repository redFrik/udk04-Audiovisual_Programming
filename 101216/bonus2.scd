(
var width= 500, height= 500, t= 0;
var win= Window("bonus 2- balls", Rect(300, 300, width, height), false);
var usr= UserView(win, Rect(0, 0, width, height));
usr.background= Color.white;
usr.drawFunc= {
	Pen.fillColor= Color.black;
	100.do{|i|
		var rad= sin(t*0.2)*50+50;
		Pen.fillOval(Rect(sin(i*0.1+t)*(sin(t*0.1)*100+200)+200, cos(i*0.06+t)*200+200, rad, rad));
	};
	
	Pen.fillColor= Color.blue;
	40.do{|i|
		var rad= sin(t*0.2)*50+50;
		Pen.fillOval(Rect(sin(i*0.04+t)*(sin(t*0.21)*100+200)+400, cos(i*0.06+t)*200+200, 50-rad, rad));
	};
	
	t= t+0.1;
};
win.front;
Routine({while({win.isClosed.not}, {usr.refresh; (1/60).wait})}).play(AppClock);
)