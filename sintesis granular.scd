s.boot;
/*
Los granuladores funcionan con audios de un solo canal.
Se puede leer un solo canal utilizando Buffer.readChannel,
este método usa el argumento channels:0
para decidir qué canal del archivo de audio va a leer.
Si el Buffer no es mono el sinte no va a sonar, pero tampoco
dará un error.
*/

// Sintesis de sonido granular

Para la sintesis granular SuperCollider integra varios UGens.

GrainSin
GrainFM
GrainBuf
GrainIn
TGrains

/* Vamos a ver GrainBuf para hacer síntesis granular con cualquier
 audio que queramos */
//---------------------------------------------------------------
GrainBuf genera granos con audios, sus argumentos son:

 -> numChannels: número de canales de salida
 -> trigger: disparador de granos,
 -> dur: duración de cada grano,
 -> sndbuf: define el buffer de audio de donde se generarán los granos
 -> rate: la velocidad a la cual se reproducirá cada grano, si es
	 igual a 2 el grano sonará una octava mas agudo, si es 0.5 sonará una
	 octaava más grave.
 -> pos: posición en el buffer de audio de la cual se producirá el grano.
 -> interp:  interpolación entre samples para implementar el cambio
	 de velocidad de reproducción de los granos.
 -> pan: posición del grano en las bocinas (Izquierda - Derecha),
 -> envbufnum: bufer con la forma de la envolvente para cada grano,
 -> maxGrains: cantidad máxima de granos,
 -> mul: amplitud,
 -> add: 0;

// Carga un Buffer
	// ------------------------------------------------------------------------

	// Buffer.read(server, path, startFrame: 0, numFrames: -1, action, bufnum)

~buf = Buffer.read(s, Platform.resourceDir +/+ "NombreDelAudio.wav", bufnum:0)

Platform.resourceDir
/*---usamos esta instrucción para audios
que estén en la misma dirección que este programa, sino, escribimos la ruta del
audio -----*/
~buf = Buffer.read(s, "C:" +/+ "Users" +/+ "Public" +/+ "piano-preparado-114bpm.wav",
	bufnum:0)
// Carga un solo canal del Buffer
	// ------------------------------------------------------------------------
~bufM = Buffer.readChannel(s, "C:" +/+ "Users" +/+ "Public" +/+ "piano-loop.wav",
	channels: 0,bufnum:1)

 //------creamos el sintetizador--------------
 //Se dejan comentadas otras posibilidades en cada variable


(
	SynthDef(\gran2, {|amp 0.1, gate 1, buf 1|
		var env, gr, trig;

		env = EnvGen.kr(Env.asr(2, 0.9, 3), gate, doneAction:2);
	   // El trigger puede ser un Impulse o un Dust, cada uno tiene implicaciones
			// diferentes
		trig = Dust.ar(500);
	        //trig = Impulse.ar(500);

	// Para el granulador vamos a controlar la duración del grano con un MouseY
			// con un rango definido entre 0.001s y 0.5 segundos.
			// El buffer lo va a determinar el argumento "buf", rate lo vamos a mantener
			// en 1 y la posición en el Buffer de dónde se va a producir el grano la vamos
			// a determinar con un MouseX con un rango definido entre 0 y 1.


	gr = GrainBuf.ar(2, trig, MouseY.kr(0.001, 0.5), buf, 1, MouseX.kr(0.0,                1.0));
	                     //otras posibilidades:
	//gr = GrainBuf.ar(2, trig, MouseY.kr(0.001, 0.5), buf, 1, MouseX.kr(0.0, 1.0)+SinOsc.ar(3, 0, 0.01));
	//gr = GrainBuf.ar(2, trig, MouseY.kr(0.001, 0.5), buf, 1, TRand.ar(0.0, 1.0, trig));
     //gr = Mix(GrainBuf.ar(2, trig, MouseY.kr(0.001, 0.5), buf, [0,4,-5, -12].midiratio, MouseX.kr(0.0, 1.0)));
		Out.ar(0, gr*amp*env);

	}).add
	)
/* sobre las otras posibilidades de control del UGen:

         Esta linea agrega un SinOsc a la posición del grano en el buffer para
		 generar un tipo de vibrato en el sonido.
gr = GrainBuf.ar(2, trig, MouseY.kr(0.001, 0.5), buf, 1, MouseX.kr(0.              0, 1.0)+SinOsc.ar(3, 0, 0.01));

		En esta linea la posición del grano se toma de una posición aleatoria
		utilizando un TRand.
 gr = GrainBuf.ar(2, trig, MouseY.kr(0.001, 0.5), buf, 1, TRand.ar(0.0, 1.0, trig));

	   En esta linea utilizamos la posibilidad de expandir canales mediante
	   el uso de arreglos para producir 4 señales con diferentes velocidades
	   de reproducción.
	   La velocidad de reproducción es controlada por valores producidos
	   utilizando midiratio, lo que nos permite producir sonido afinados
	   por semitonos a partir del sonido original del audio.
gr = Mix(GrainBuf.ar(2, trig, MouseY.kr(0.001, 0.5), buf, [0,4,-5, -12].midiratio, MouseX.kr(0.0, 1.0)));     */


	//¡¡El buffer debe contener un solo canal!!
    //ejecutamos el sintetizador
	~gran2 = Synth(\gran2)

	~gran2.set(\amp, 0.1)

	~bufM1 = Buffer.readChannel(s, "C:" +/+ "Users" +/+ "Public" +/+ "pajaros.wav", channels: 0, bufnum:2)
	~bufM2 = Buffer.readChannel(s, "C:" +/+ "Users" +/+ "Public" +/+ "gente-hablando.wav", bufnum:3)
	~bufM3 = Buffer.readChannel(s, "C:" +/+ "Users" +/+ "Public" +/+ "bell.wav", channels: 0, bufnum:4)
//Si tienen varios buffers declarados pueden utilizar esta linea para
	//alternar.
    ~gran2.set(\buf, 4)

	//Apagamos el Sintetizador
	~gran2.set(\gate,0)


