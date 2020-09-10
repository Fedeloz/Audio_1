function FVirtualamp(audio);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ejercicio ilustrativo de localización con señales audio
% Asignatura: Sistemas de Audio y Vídeo
% Titulación: Grado en Ingeniería de Sistemas de Telecomunicación
% Profesor: Salvador Luna Ramírez
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Función que crea un foco virtual modificando las amplitudes a cada oido
% - 'audio' indica el sonido origen ('0':seno ; '1': Musica).


% Generamos la onda
if audio==0
   frecTono=500;           % Frecuencia del tono, [Hz]
   Fs=44100;               % Frecuencia de muestreo [Hz]
   Duracion=8;             % Duracion del tono [s]
   tiempo=0:1/Fs:Duracion; % vector de tiempo
   onda=0.5*sin(frecTono*2*pi*tiempo);	%1 kHz
elseif audio==1 % 
   % El archivo debe durar al menos 'Duracion' segundos 
   Duracion=8;             % Duracion del trozo de archivo [s]
   [onda,Fs]=audioread('.\Prueba_audio.wav'); 
   tiempo=0:1/Fs:Duracion; % vector de tiempo
   onda=onda(1:(Fs*Duracion)+1,1)';
end   

% Creamos los dos canales izq y der según la curva de modulacion
%Triángulo ascendente-descendente
Moduladora_Izq=(tiempo<=(Duracion/2)).*(tiempo/(Duracion/2))...
				     +(tiempo>(Duracion/2)).*(2-tiempo/(Duracion/2));	
%Triángulo descendente-ascendente              
Moduladora_Der=1-Moduladora_Izq;	

% Generamos la onda de salida
TonoModuladoIzq=Moduladora_Izq.*onda;
TonoModuladoDer=Moduladora_Der.*onda;

% Dibujamos los perfiles de modulacion
figure(1);
plot(tiempo,Moduladora_Izq,'b'); hold on; grid on;
plot(tiempo,Moduladora_Der,'r');
xlabel('Segundos [s]');
ylabel('Coeficiente modulador');
legend('Izquierda','Derecha');

% Reproducimos la señal generada
total=[TonoModuladoIzq',TonoModuladoDer'];
sound(total,Fs);
audiowrite('.\SonidoModificado.wav',total,Fs);

