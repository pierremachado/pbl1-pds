% =========================================================================
% Análise de Amostragem Ideal de um Sinal Senoidal
% =========================================================================
clear; clc; close all;

% 1. Definição dos Parâmetros do Sinal e da Amostragem
f0 = 2;               % Frequência do sinal original (Hz)
w0 = 2*pi*f0;         % Frequência angular (rad/s)
fs = 13;              % Frequência de amostragem (Hz) - Respeita Nyquist (fs > 2*f0)
f0 = 5;               % Frequência do sinal original (Hz)
w0 = 2*pi*f0;         % Frequência angular (rad/s)
fs = 40;              % Frequência de amostragem (Hz) - Respeita Nyquist (fs > 2*f0)
ws = 2*pi*fs;         % Frequência angular de amostragem (rad/s)
Ts = 1/fs;            % Período de amostragem (s)

% Vetores de tempo
t_cont = 0:0.001:1; % Eixo de tempo "contínuo" (alta resolução)
t_samp = 0:Ts:1;    % Eixo de tempo discreto (amostrado)

% =========================================================================
% PLOT 1: Sinal contínuo no tempo x(t) = sin(w0*t)
% =========================================================================
x_cont = sin(w0 * t_cont);

figure('Name', 'Analise de Amostragem Ideal', 'Position', [100, 100, 1000, 800]);

subplot(2, 2, 1);
plot(t_cont, x_cont, 'b-', 'LineWidth', 1.5);
title('1. Sinal Contínuo x(t) = sen(\omega_0 t)');
xlabel('Tempo (s)');
ylabel('Amplitude');
grid on;
ylim([-1.2 1.2]);

% =========================================================================
% PLOT 2: Sinal amostrado de forma ideal x_s(t) = x(t)*p(t)
% =========================================================================
x_samp = sin(w0 * t_samp);

subplot(2, 2, 2);
% Usamos 'stem' para representar o trem de impulsos ponderado pelo sinal
stem(t_samp, x_samp, 'r', 'filled', 'LineWidth', 1.5);
title('2. Sinal Amostrado x_s(t) = x(t) \cdot p(t)');
xlabel('Tempo (s)');
ylabel('Amplitude');
grid on;
ylim([-1.2 1.2]);

% =========================================================================
% PLOT 3: Espectro Analítico do Sinal Contínuo X(jw)
% =========================================================================
<<<<<<< HEAD
% Para x(t) = sen(w0*t), a magnitude de X(jw) possui impulsos em -w0 e +w0 
% com área igual a pi. Usaremos frequência em Hz (f) para facilitar a 
=======
% Para x(t) = sen(w0*t), a magnitude de X(jw) possui impulsos em -w0 e +w0
% com área igual a pi. Usaremos frequência em Hz (f) para facilitar a
>>>>>>> e947461 (Envio dos novos arquivos)
% visualização, onde a amplitude é 0.5 em -f0 e +f0.

f_orig = [-f0, f0];       % Posição dos impulsos
mag_orig = [0.5, 0.5];    % Magnitude dos impulsos

subplot(2, 2, 3);
% Representando deltas de Dirac com stem e marcadores de setas (^)
stem(f_orig, mag_orig, 'b', 'Marker', '^', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
title('3. Espectro Analítico Contínuo |X(j\omega)|');
xlabel('Frequência (Hz)');
ylabel('Magnitude');
grid on;
xlim([-40 40]);
ylim([0 0.8]);
% Adicionando linha base para clareza
line([-40 40], [0 0], 'Color', 'k');

% =========================================================================
% PLOT 4: Espectro Analítico do Sinal Amostrado X_s(jw)
% =========================================================================
% X_s(jw) = 1/Ts * sum( X(j(w - k*ws)) )
% Isso cria réplicas do espectro original deslocadas por múltiplos de fs,
% escalonadas por 1/Ts (ou seja, multiplicadas por fs).

k = -2:2; % Avaliaremos as réplicas de k=-2 até k=2
f_samp_locs = [];
mag_samp = [];

% Construindo as réplicas analiticamente
for idx = 1:length(k)
    f_shift = k(idx) * fs;
    f_samp_locs = [f_samp_locs, -f0 + f_shift, f0 + f_shift];
    % A magnitude é escalonada por 1/Ts = fs
<<<<<<< HEAD
    mag_samp = [mag_samp, 0.5 * fs, 0.5 * fs]; 
=======
    mag_samp = [mag_samp, 0.5 * fs, 0.5 * fs];
>>>>>>> e947461 (Envio dos novos arquivos)
end

subplot(2, 2, 4);
stem(f_samp_locs, mag_samp, 'r', 'Marker', '^', 'LineWidth', 1.5, 'MarkerFaceColor', 'r');
title('4. Espectro Amostrado Analítico |X_s(j\omega)|');
xlabel('Frequência (Hz)');
ylabel('Magnitude');
grid on;
xlim([-40 40]);
ylim([0 (0.5*fs)+2]);
line([-40 40], [0 0], 'Color', 'k');

<<<<<<< HEAD
sgtitle('Análise Analítica de Amostragem Ideal de Sinais');

% TODO: adicionar amostragem natural e topo-plano analítico
=======
% sgtitle('Análise Analítica de Amostragem Ideal de Sinais');

% TODO: adicionar amostragem natural e topo-plano analítico
>>>>>>> e947461 (Envio dos novos arquivos)
