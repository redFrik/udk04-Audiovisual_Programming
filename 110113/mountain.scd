(
var peak0= 0.2, peak1= 0.1, peak2= 0.3;
var width= 500, height= 500;
var win= Window("mountain", Rect(300, 300, width, height), false);
var usr= UserView(win, Rect(0, 0, width, height));
usr.background= Color.white;
usr.drawFunc= {
	Pen.strokeColor= Color.black;
	Pen.moveTo(Point(width*0.1, height*0.5));
	Pen.quadCurveTo(Point(width*0.2, height*0.5), Point(width*0.13, height*peak0));
	Pen.quadCurveTo(Point(width*0.3, height*0.5), Point(width*0.23, height*peak1));
	Pen.quadCurveTo(Point(width*0.4, height*0.5), Point(width*0.33, height*peak2));
	Pen.stroke;
};
win.front;
)