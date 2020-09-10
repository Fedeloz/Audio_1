%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ejercicio ilustrativo del efecto aliasing en señales audio
% Asignatura: Sistemas de Audio y Vídeo
% Titulación: Grado en Ingeniería de Sistemas de Telecomunicación
% Profesor: Salvador Luna Ramírez
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script que crea una onda sinoidal con barrido en frecuencias, para distintas
% duraciones y con diversos muestreos. 

% Datos
Duracion=1;     % Lo que va a durar cada tono individual [s]
Fs=15000;       % Frecuencia de muestreo [Hz]
NumMuestras=Duracion*Fs;  % Longitud de los vectores de muestras
tiempo=(1:NumMuestras)/Fs; % Vector con valores de tiempo [s]
fini=50;        % Frecuencia inicial de barrido [Hz]
ffin=13000;     % Frecuencia final de barrido [Hz]
IncreFrec=1000; % Incrementos de frecuencia para recorrer el rango frencuencial
Vector_frec=fini:IncreFrec:ffin; % Vector de frecuencias crecientes
Nbits=16;       % Número de bits por muestra

% Preparo el dibujo
close all; figure(1);
subplot(2,1,1); grid on;
subplot(2,1,2); hold on; grid on;
xlabel('Frecuencia [Hz]'); 
axis([0 Fs 0 2]);

N=length(Vector_frec);
for ind=1:N 
    % Genero el vector onda.
    Onda=0.4*sin(2*pi*Vector_frec(ind).*tiempo);
    % Lo reproduzco (¡cuidado con el volumen!)
    sound(Onda,Fs,Nbits);
    
    % Lo dibujo
    subplot(2,1,1); plot(tiempo, Onda);
    xlabel('Tiempo [s]');
    ylabel('Valor digital de la onda');
    subplot(2,1,2); stem(Vector_frec(ind),1); hold on;
    pause;
end;
