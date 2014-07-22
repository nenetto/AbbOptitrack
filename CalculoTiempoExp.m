% Calculo de tiempo

% 70 puntos - 15 min

dist = 50;


factor = 70/0.25; % en horas

volumen = [400,300,500];

nPuntos = ceil(volumen/dist);
nPuntos = prod(nPuntos);

nPuntos
tiempo = nPuntos / factor