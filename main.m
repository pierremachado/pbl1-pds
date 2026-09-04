clear all; clc;

addpath(genpath('src'));

f = 2;
phi = 0;
Fs = 20;

x = @(t) sin(2*pi*f*t + phi);
%x = @(t) sawtooth(2*pi*f*t, 1/2);

Ti = 0;
Ts = 1/Fs;
Tf = 1;

% Sinal "contínuo" numericamente
t_continuo = Ti:1/1000:Tf;
x_continuo = x(t_continuo);

% Amostragem ideal
[xs_ideal, ts_ideal] = amostragem_ideal(x, Fs, Ti, Tf);
[xs_ideal_continuo, ts_ideal_continuo] = discreto_para_impulsos(xs_ideal, ts_ideal, Ti, Tf, Ts/1000);

% Amostragem natural
wn = Ts/2;
[xs_natural, ts_natural] = amostragem_natural(x, Fs, wn, Ti, Tf);

% Amostragem flat-top
wft = Ts + 1e-6;
[xs_flat_top, ts_flat_top] = amostragem_flattop(x, Fs, wft, Ti, Tf);

% Plot
figure(1);

subplot(4,1,1);
plot(t_continuo, x_continuo);
title('Sinal original x(t)');
xlabel('Tempo (s)');
ylabel('Amplitude');
grid on;

subplot(4,1,2);
stem(ts_ideal, xs_ideal);
title('Sinal amostrado idealmente');
xlabel('Tempo (s)');
ylabel('Amplitude');
grid on;

subplot(4,1,3);
plot(ts_natural, xs_natural);
title('Sinal amostrado naturalmente');
xlabel('Tempo (s)');
ylabel('Amplitude');
grid on;

subplot(4,1,4);
plot(ts_flat_top, xs_flat_top);
title('Sinal amostrado topo-plano');
xlabel('Tempo (s)');
ylabel('Amplitude');
grid on;

%% FFT bilateral
% Número de pontos
Nc  = length(x_continuo);
Nsi = length(xs_ideal_continuo);
Nsn = length(xs_natural);
Nft = length(xs_flat_top);

% Taxas efetivas de amostragem dos vetores
Fc  = 1000;
Fsi = 1/(Ts/1000);
Fsn = 10000;
Fft = 10000;

% FFT
% TODO: Implementar as funções de FT de forma analítica
Xc  = fftshift(fft(x_continuo));
Xi = fftshift(fft(xs_ideal_continuo));
Xn = fftshift(fft(xs_natural));
Xft = fftshift(fft(xs_flat_top));

% Magnitude normalizada
Pc  = abs(Xc/Nc);
Psi = abs(Xi/Nsi);
Psn = abs(Xn/Nsn);
Pft = abs(Xft/Nft);

% Fase
Argft = arg(Xft/Nft);

% Eixos de frequência
fc  = (-floor(Nc/2):ceil(Nc/2)-1)*Fc/Nc;
fsi = (-floor(Nsi/2):ceil(Nsi/2)-1)*Fsi/Nsi;
fsn = (-floor(Nsn/2):ceil(Nsn/2)-1)*Fsn/Nsn;
fft_freq = (-floor(Nft/2):ceil(Nft/2)-1)*Fft/Nft;

% Plot
fmax = 100;

figure(2);

subplot(5,1,1);
plot(fc, Pc, 'Color', [1 0.5 0]);
title('FFT bilateral do sinal original x(t)');
xlabel('Frequência (Hz)');
ylabel('|X(f)|');
grid on;
xlim([-fmax fmax]);

subplot(5,1,2);
plot(fsi, Psi, 'Color', [1 0.5 0]);
title('FFT bilateral da amostragem ideal');
xlabel('Frequência (Hz)');
ylabel('|X(f)|');
grid on;
xlim([-fmax fmax]);

subplot(5,1,3);
plot(fsn, Psn, 'Color', [1 0.5 0]);
title('FFT bilateral da amostragem natural');
xlabel('Frequência (Hz)');
ylabel('|X(f)|');
grid on;
xlim([-fmax fmax]);

subplot(5,1,4);
plot(fft_freq, Pft, 'Color', [1 0.5 0]);
title('FFT bilateral da amostragem topo-plano');
xlabel('Frequência (Hz)');
ylabel('|X(f)|');
grid on;
xlim([-fmax fmax]);

subplot(5,1,5);
plot(fft_freq, Argft, 'Color', [1 0.5 0]);
title('FFT bilateral da amostragem topo-plano');
xlabel('Frequência (Hz)');
ylabel('∠X(f)');
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