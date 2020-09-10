function Enmascaramiento(audio,ftono,BWaudio,SPLtono,fruido,BWruido,SPLruido)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ejercicio ilustrativo de enmascaramiento de sonidos
% Asignatura: Sistemas de Audio y V�deo
% Titulaci�n: Grado en Ingenier�a de Sistemas de Telecomunicaci�n
% Profesor: Salvador Luna Ram�rez
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% La rutina que reproduce un tono (sonido enmascarado) y ruido paso banda.
%
% 'audio'= valdr� 0 si queremos probar con un tono � 1 si queremos con una se�al de m�sica
% 'BWaudio'= ancho de banda de la se�al de musica.
% 'ftono'= frecuencia del tono o frec. central de la m�sica
% 'SPLtono'= nivel del tono o de la m�sica (m�ximo 126 dB)
% 'fruido'= frecuencia central del ruido
% 'SPLruido= nivel total del ruido (m�ximo 126 dB)
% 'BWruido=ancho de banda del ruido en Herzios

%---- AMPLITUDES Y TIEMPOS
% Para valores SPL proporcionados, suponemos que la amplitud '1' del vector 
% se corresponde a 94dbSPL (m�ximo). 
Aruido=1/(10^((126-SPLruido)/20));
Atono=1/(10^((126-SPLtono)/20));
tmax=3;     % Tiempo que durar� el sonido

%--- GENERAMOS ONDA ENMASCARADA
if audio==1  % Onda aleatoria
   [onda,Fs]=audioread('.\handel.wav');
   onda=onda';                 % Pasamos a vector fila
   tarchivo=((length(onda)-1)/Fs);  % Duraci�n del archivo
   if tarchivo>tmax            % Si el archivo es m�s largo que tmax...
    onda=onda(1:(Fs*tmax));    % ... lo acortamos;
   else                        % si es m�s corto...
    tmax=tarchivo;             % lo dejamos tal cual
   end;
   L=length(onda);
   
   % Ahora filtramos la onda seg�n se especifica
   fi=ftono-BWaudio/2;		   % L�mite inferior y superior del ruido paso banda
   fs=ftono+BWaudio/2;
   B=fir1(500,[fi,fs]/(Fs/2));	   % Filtramos la onda sonora
   onda=filter(B,1,onda);
   maximo=max(max(onda));      % Reescalo para que despu�s de filtrarlo tenga
   onda=Atono*onda/maximo;     % el mismo SPL m�ximo.

elseif audio==0 % Onda sinusoide
   Fs=44100;            % La frecuencia de muestreo es fija y vale 44100
   tiempo=0:1/Fs:tmax;	% Vector de tiempos
   L=length(tiempo);    % Longitud del vector
   onda=Atono*sin(ftono*2*pi*tiempo);
    
end;    
    
%---  GENERAMOS RUIDO ENMASCARADOR
ruido=randn(1,length(onda));	                         
fi=fruido-BWruido/2;		% L�mite inferior y superior del ruido paso banda
fs=fruido+BWruido/2;
B=fir1(500,[fi,fs]/(Fs/2));		% Creamos filtro paso banda 
ruidofiltrado=filter(B,1,ruido);
maximo=max(max(ruidofiltrado));                 %reescalo para que despu�s de filtralo
ruidofiltrado=Aruido*ruidofiltrado/maximo;      % tenga el mismo SPL m�ximo                           

%--- CREACI�N DE ARCHIVO FINAL   
silencio=zeros(1,1*Fs);			% Momento de silencio (1seg)
ondatotal=onda+ruidofiltrado;   % Enmascarador y enmascarado

% Intercalamos los sonidos
total=[ondatotal silencio ruidofiltrado silencio onda];

% Hacemos sonar
sound(total,Fs);
audiowrite('.\NombreArchivo.wav',total,Fs);

% Calculamos y dibujamos ambos espectros
figure(1);
NFFT = 2^nextpow2(L);       % N�mero de muestras potencia de 2
Ytono=fft(onda,NFFT)/L;
Yruido=fft(ruidofiltrado,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);    % Eje de frecuencias

% Plot single-sided amplitude spectrum.
plot(f,2*abs(Ytono(1:NFFT/2+1)),'r'); hold on;
plot(f,2*abs(Yruido(1:NFFT/2+1)),'b');  
xlabel('Frequency (Hz)');
ylabel('|Y(f)|');
legend('Onda','Ruido');
