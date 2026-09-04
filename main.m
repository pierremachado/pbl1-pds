pkg load signal

addpath(genpath('src'));

clear all; clc;

f = 2;
phi = 0;
Fs = 8;

x = @(t) sin(2*pi*f*t + phi);
%x = @(t) sawtooth(2*pi*f*t, 1/2);

Ti = 0;
Ts = 1/Fs;
Tf = 1;

% Sinal "contínuo" numericamente
t = Ti:1/1000:Tf;
xc = x(t);

% Amostragem ideal
[xsi, tsi] = amostragem_ideal(x, Fs, Ti, Tf);

% Amostragem natural
wn = Ts/2;
[xsn, tsn] = amostragem_natural(x, Fs, wn, Ti, Tf);

% Amostragem flat-top
wft = Ts + 1e-6;
[xsft, tsft] = amostragem_flattop(x, Fs, wft, Ti, Tf);

% Plot
figure(1);

subplot(4,1,1);
plot(t, xc);
title('Sinal original x(t)');
xlabel('Tempo (s)');
ylabel('Amplitude');
grid on;

subplot(4,1,2);
stem(tsi, xsi);
title('Sinal amostrado idealmente');
xlabel('Tempo (s)');
ylabel('Amplitude');
grid on;

subplot(4,1,3);
plot(tsn, xsn);
title('Sinal amostrado naturalmente');
xlabel('Tempo (s)');
ylabel('Amplitude');
grid on;

subplot(4,1,4);
plot(tsft, xsft);
title('Sinal amostrado topo-plano');
xlabel('Tempo (s)');
ylabel('Amplitude');
grid on;

%% FFT bilateral

% Número de pontos
Nc  = length(xc);
Nsi = length(xsi);
Nsn = length(xsn);
Nft = length(xsft);

% Taxas efetivas de amostragem dos vetores
Fc  = 1000;
Fsi = Fs;
Fsn = 10000;
Fft = 10000;

% FFT
% TODO: Implementar as funções de FT de forma analítica
Xc  = fftshift(fft(xc));
Xsi = fftshift(fft(xsi));
Xsn = fftshift(fft(xsn));
Xft = fftshift(fft(xsft));

% Magnitude normalizada
Pc  = abs(Xc/Nc);
Psi = abs(Xsi/Nsi);
Psn = abs(Xsn/Nsn);
Pft = abs(Xft/Nft);

% Eixos de frequência
fc  = (-floor(Nc/2):ceil(Nc/2)-1)*Fc/Nc;
fsi = (-floor(Nsi/2):ceil(Nsi/2)-1)*Fsi/Nsi;
fsn = (-floor(Nsn/2):ceil(Nsn/2)-1)*Fsn/Nsn;
fft_freq = (-floor(Nft/2):ceil(Nft/2)-1)*Fft/Nft;

% Plot
fmax = 100;

figure(2);

subplot(4,1,1);
plot(fc, Pc, 'Color', [1 0.5 0]);
title('FFT bilateral do sinal original x(t)');
xlabel('Frequência (Hz)');
ylabel('|X(f)|');
grid on;
xlim([-fmax fmax]);

subplot(4,1,2);
plot(fsi, Psi, 'Color', [1 0.5 0]);
title('FFT bilateral da amostragem ideal');
xlabel('Frequência (Hz)');
ylabel('|X(f)|');
grid on;
xlim([-fmax fmax]);

subplot(4,1,3);
plot(fsn, Psn, 'Color', [1 0.5 0]);
title('FFT bilateral da amostragem natural');
xlabel('Frequência (Hz)');
ylabel('|X(f)|');
grid on;
xlim([-fmax fmax]);

subplot(4,1,4);
plot(fft_freq, Pft, 'Color', [1 0.5 0]);
title('FFT bilateral da amostragem topo-plano');
xlabel('Frequência (Hz)');
ylabel('|X(f)|');
grid on;
xlim([-fmax fmax]);

% Save
set(1, 'paperunits', 'inches');
set(1, 'papersize', [19.2 10.8]);
set(1, 'paperposition', [0 0 19.2 10.8]);

set(2, 'paperunits', 'inches');
set(2, 'papersize', [19.2 10.8]);
set(2, 'paperposition', [0 0 19.2 10.8]);

% 1. Define o caminho absoluto da pasta de saída primeiro
root_dir = fileparts(mfilename('fullpath'));
output_path = fullfile(root_dir, 'output');

% 2. Cria a pasta no local correto (se não existir)
if ~exist(output_path, 'dir')
    mkdir(output_path);
end

% 3. Salva os arquivos com o caminho absoluto
print(1, fullfile(output_path, 'sinais_amostragem.jpg'), '-dpng', '-r100');
print(2, fullfile(output_path, 'fft_amostragem.jpg'), '-dpng', '-r100');