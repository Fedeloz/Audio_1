function FVirtualfase;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ejercicio ilustrativo de localización con señales audio
% Asignatura: Sistemas de Audio y Vídeo
% Titulación: Grado en Ingeniería de Sistemas de Telecomunicación
% Profesor: Salvador Luna Ramírez
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Función que crea un foco virtual modificando las fases a cada oido
% - 'audio' indica el sonido origen ('0':seno ; '1': Musica).

Fs=44100;               % Frecuencia de muestreo [Hz]
Duracion=10;            % [s]
tiempo=0:1/Fs:Duracion; % vector de tiempo
frecTono=500;           % Frecuencia del tono, [Hz]

% Desfase de una onda a frecTono al recorrer la cabeza de una oreja a otra (aprox)
desfase=0.4*2*pi*frecTono/340;	
% m*...

% Generamos el desfase entre sonidos variable con el tiempo
desfaseIzq=(tiempo<=(Duracion/4)).*(desfase*tiempo*4/Duracion) +...
	     		    ((Duracion/4<tiempo)&(tiempo<=3*Duracion/4)).*(2*desfase*(1-2*tiempo/Duracion)) +...
			       (tiempo>(3*Duracion/4)).*(4*desfase*((tiempo/Duracion)-1));
desfaseDer=0; %Lo importante es la diferencia entre Izq y Der
   
% Dibujamos los perfiles de modulacion
figure(1);         
plot(tiempo,desfaseIzq,'b'); hold on; grid on;
xlabel('Segundos [s]');
ylabel('¿¿¿???');
legend('Izquierda');   

% Generamos la onda
tono_izq=0.6*sin(frecTono*2*pi*tiempo+desfaseIzq);
tono_der=0.6*sin(frecTono*2*pi*tiempo+desfaseDer);
total=[tono_izq',tono_der'];

% Reproducimos
sound(total,Fs);
audiowrite('.\SonidoModificado.wav',total,Fs);

