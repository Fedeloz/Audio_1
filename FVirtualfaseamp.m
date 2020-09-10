function FVirtualfaseamp(Kfase,Kamplitud);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ejercicio ilustrativo de localización con señales audio
% Asignatura: Sistemas de Audio y Vídeo
% Titulación: Grado en Ingeniería de Sistemas de Telecomunicación
% Profesor: Salvador Luna Ramírez
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% - 'Kfase': influencia que tendrá la fase en la recreación de localización. 
% Valor entre 0 y 1
% - 'Kamplitud': influencia que tendrá la fase en la recreación de localización. 
% Valor entre 0 y 1

Fs=22050;               % Frecuencia de muestreo [Hz]
Duracion=16;            % [s]
tiempo=0:1/Fs:Duracion; % vector de tiempo
frecTono=300;           % Frecuencia del tono, [Hz]

% Desfase de una onda a frecTono al recorrer la cabeza de una oreja a otra (aprox)
desfase=0.4*2*pi*frecTono/340;	

% Generamos el desfase entre sonidos variable con el tiempo.
desfaseIzq=(tiempo<=(Duracion/4)).*(Kfase*tiempo*4/Duracion) +...
	     		    ((Duracion/4<tiempo)&(tiempo<=3*Duracion/4)).*(2*Kfase*(1-2*tiempo/Duracion)) +...
			       (tiempo>(3*Duracion/4)).*(4*Kfase*((tiempo/Duracion)-1));
desfaseDer=0; %Lo importante es la diferencia entre Izq y Der

%Vamos a acentuar el efecto modulando también en amplitud. Estas moduladores localizan en la mitad opuesta
% a la de fase. 
Moduladora_Der=(tiempo<=(Duracion/4)).*(((tiempo+4)/(Duracion/2))*Kamplitud)...
             +((tiempo>(Duracion/4)) & (tiempo<=(3*Duracion/4))).*(((12-tiempo)/(Duracion/2))*Kamplitud)...
             +(tiempo>(3*Duracion/4)).*(((tiempo-12)/(Duracion/2))*Kamplitud);	     
Moduladora_Izq=(tiempo<=(Duracion/4)).*(((4-tiempo)/(Duracion/2))*Kamplitud)...
             +((tiempo>(Duracion/4)) & (tiempo<=(3*Duracion/4))).*(((tiempo-4)/(Duracion/2))*Kamplitud)...
             +(tiempo>(3*Duracion/4)).*(((20-tiempo)/(Duracion/2))*Kamplitud);

% Dibujamos los perfiles de modulacion
figure(1);         
plot(tiempo,desfaseIzq,'b'); hold on; grid on;
plot(tiempo,Moduladora_Izq,'r');
plot(tiempo,Moduladora_Der,'k');
xlabel('Segundos [s]');
legend('Desfase canal izquierdo','Modulación Izquierdo','Modulación Derecho');

% Creamos y reproducimos la onda
tonoizq=Moduladora_Izq.*sin(frecTono*2*pi*tiempo+desfaseIzq);
tonoder=Moduladora_Der.*sin(frecTono*2*pi*tiempo+desfaseDer);
total=[tonoizq',tonoder'];
sound(total,Fs);
audiowrite('.\SonidoModificado.wav',total,Fs);
