

//birth increase example
Routine({
	var births= 25000;	//initial value
	inf.do{
		births= births+1;	//add something
		births.postln;
		0.5.wait;
	};
}).play;


//flucutate example whole numbers
Routine({
	var temp= 25;	//initial value
	inf.do{
		temp= temp+ [-1, 0, 1].choose;
		temp.postln;
		0.5.wait;
	};
}).play;



//flucutate example float numbers
Routine({
	var temp= 25;	//initial value
	inf.do{
		temp= temp+ 0.0.gauss(1.0);
		temp.postln;
		0.5.wait;
	};
}).play;




//tigers
a= NodeProxy.new.play;
a.source= {|freq| SinOsc.ar(freq, 0, 0.1)};
Routine({
	var tigers= 4000;	//initial value
	inf.do{
		tigers= tigers-1;
		tigers.postln;
		a.set(\freq, tigers);
		0.01.wait;
	};
}).play;






//birth increase example
a= NodeProxy.new.play;
a.source= {|freq, trigger| EnvGen.ar(Env.perc, trigger)*SinOsc.ar(freq)}
Routine({
	var births= 25000;	//initial value
	inf.do{
		births= births+1;	//add something
		births.postln;
		a.set(\trigger, 1);
		a.set(\freq, births.linlin(25000, 25100, 200, 600));
		0.5.rand.wait;
		a.set(\trigger, 0);
		0.25.rand.wait;
	};
}).play;

//fake the number generator
//make connections with sound
//map numbers to audiable ranges
