//--modulations

projects presentations



s.boot
a= NodeProxy.new.play

//modulating the amplitude (ring modulation)
a.source= {SinOsc.ar(700, 0, 0.5)}
a.source= {SinOsc.ar(700, 0, SinOsc.ar(0.3, 0, 0.5))}

//modulating the frequency
a.source= {SinOsc.ar(700, 0, 0.5)}
a.source= {SinOsc.ar(SinOsc.ar(0.3, 0, 600, 1700), 0, 0.5)}

//nesting modulators
a.source= {SinOsc.ar(SinOsc.ar(SinOsc.ar(3, 0, 200, 500), 0, 600, 1700), 0, 0.5)}

//replacing static values with mousex
a.source= {SinOsc.ar(SinOsc.ar(SinOsc.ar(SinOsc.ar(2, 0, 3, 13), 0, 200, 1500), 0, 1600, 2700), 0, 0.2)}
a.source= {SinOsc.ar(SinOsc.ar(SinOsc.ar(SinOsc.ar(2, 0, 3, 13), 0, MouseX.kr(4, 2000), 1500), 0, 1600, 2700), 0, 0.2)}

//also mousey possible
a.source= {SinOsc.ar(SinOsc.ar(SinOsc.ar(SinOsc.ar(2, 0, 3, MouseY.kr(1, 10)), 0, MouseX.kr(4, 2000), 1500), 0, 1600, 2700), 0, 0.2)}
a.stop


//--my little sine sound scape - playing single sound with three variations
a= NodeProxy.new.play
a.fadeTime= 3
a.play

a.source= {SinOsc.ar(SinOsc.ar(SinOsc.ar(3, 0, 200, 500), 0, 600, 1700), 0, 0.5)};
a.source= {SinOsc.ar(SinOsc.ar(SinOsc.ar(4, 0, 400, 1500), 0, 600, 1700), 0, 0.5)};
a.source= {SinOsc.ar(SinOsc.ar(SinOsc.ar(5, 0, 600, 3000), 0, 600, 1700), 0, 0.5)};

a.stop(10)	//stop in 10 seconds


//--my little sine sound scape - playing the three at the same time
a= NodeProxy.new.play
b= NodeProxy.new.play
c= NodeProxy.new.play
a.fadeTime= 6
b.fadeTime= 6
c.fadeTime= 6
a.play
b.play
c.play

(
a.source= {SinOsc.ar(SinOsc.ar(SinOsc.ar(3, 0, 200, 500), 0, 600, 1700), 0, 0.5)};
b.source= {SinOsc.ar(SinOsc.ar(SinOsc.ar(4, 0, 400, 1500), 0, 600, 1700), 0, 0.5)};
c.source= {SinOsc.ar(SinOsc.ar(SinOsc.ar(5, 0, 600, 3000), 0, 600, 1700), 0, 0.5)};
)

a.stop(10)	//stop in 10 seconds
b.stop(5)		//stop in 5 seconds
c.stop(1)		//stop in 1 seconds


