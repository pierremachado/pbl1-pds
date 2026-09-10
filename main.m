% =========================================================================
% MAIN.M - Análise Analítica de Amostragem (Ideal, Natural e Topo-Plano)
% =========================================================================

% TODO: Adicionar análise por FFT

clear; clc; close all;

% Adiciona o diretório 'src' e o 'utils' ao path de busca do MATLAB/Octave
addpath('src', 'utils');

%% 1. Definição dos Parâmetros Globais
frequency = 5;                         % Frequência do sinal original (Hz)
omega = 2*pi*frequency;                % Frequência angular (rad/s)
samplingFrequency = 20;                % Frequência de amostragem (Hz)
samplingPeriod = 1/samplingFrequency;  % Período de amostragem (s)
tau = 0.5 * samplingPeriod;            % Largura do pulso (50% do período)
displayRange = 4 * samplingFrequency;
kMax = ceil((displayRange + frequency) / samplingFrequency);

startTime = 0;                         % Tempo inicial
endTime = 1;                           % Tempo final

% Define o sinal de origem como um "function handle" para passar às funções
x = @(t) sin(omega * t);

% Eixo de tempo do sinal base
continuousTimeStep = 0.0005;           % Passo de tempo para o vetor "contínuo"
continuousTime = startTime:continuousTimeStep:endTime;
continuousX = x(continuousTime);

% Amostragem Ideal
[idealX, idealTime] = idealSampling(x, samplingFrequency, startTime, endTime);

% Amostragem Natural
[naturalX, naturalTime] = naturalSampling(x, samplingFrequency, tau, startTime, endTime);

% Amostragem Topo-Plano
[flatTopX, flatTopTime] = flatTopSampling(x, samplingFrequency, tau, startTime, endTime);

%% FIGURA 1
figure(1, 'Name', 'Analise de Amostragem Ideal', 'Position', [100, 100, 1000, 800]);

% PLOT 1: Tempo - Sinal Contínuo
subplot(2, 2, 1);
plot(continuousTime, continuousX, 'b-', 'LineWidth', 1.5);
title('1. Sinal Contínuo x(t) = sen(\omega_0 t)');
xlabel('Tempo (s)'); ylabel('Amplitude');
grid on; ylim([-1.2 1.2]);

% PLOT 2: Tempo - Amostrado de forma Ideal
subplot(2, 2, 2);
stem(idealTime, idealX, 'r', 'filled', 'LineWidth', 1.5);
title('2. Amostragem Ideal (Tempo)');
xlabel('Tempo (s)'); ylabel('Amplitude');
grid on; ylim([-1.2 1.2]);

% PLOT 3: Frequência - Analítico (Contínuo)
subplot(2, 2, 3);
frequencyContinuous = [-frequency, frequency];
magnitudeContinuous = [0.5, 0.5];
stem(frequencyContinuous, magnitudeContinuous, 'b', 'Marker', '^', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
title('3. Espectro Contínuo Analítico |X(j\omega)|');
xlabel('Frequência (Hz)'); ylabel('Magnitude');
grid on; xlim([-displayRange displayRange]);

% PLOT 4: Frequência - Analítico (Amostrado Ideal)
subplot(2, 2, 4);
kIdealSamples = -kMax:kMax;
idealFrequencyLocations = []; 
idealMagnitudes = [];
% X_s(jω) = (1/Ts) * Σ_{k=-∞}^{∞} X(j(ω - k * ωs)))
% Esta expressão representa a transformada de Fourier da amostragem ideal de um sinal.
% É a soma de infinitas translações da transformada de Fourier original X(jω)
% espaçadas pela frequência de amostragem ωs, escaladas por 1/Ts.
for k = kIdealSamples
    frequencyShift = k * samplingFrequency;
    idealFrequencyLocations = [idealFrequencyLocations, -frequency + frequencyShift, frequency + frequencyShift];
    idealMagnitudes = [idealMagnitudes, 0.5 * samplingFrequency, 0.5 * samplingFrequency]; 
end
stem(idealFrequencyLocations, idealMagnitudes, 'r', 'Marker', '^', 'LineWidth', 1.5, 'MarkerFaceColor', 'r');
title('4. Espectro Amostrado Ideal Analítico |X_s(j\omega)|');
xlabel('Frequência (Hz)'); ylabel('Magnitude');
grid on; xlim([-displayRange displayRange]); ylim([0 (0.5*samplingFrequency)+2]);

%% FIGURA 2
figure(2, 'Name', 'Amostragem Natural e Topo-Plano', 'Position', [150, 150, 1000, 800]);

% PLOT 1: Tempo - Amostragem Natural
subplot(2, 2, 1);
plot(naturalTime, naturalX, 'b-', 'LineWidth', 1.5);
title('1. Amostragem Natural no Tempo');
xlabel('Tempo (s)'); ylabel('Amplitude');
grid on; ylim([-1.2 1.2]);

% PLOT 2: Tempo - Amostragem Topo-Plano
subplot(2, 2, 2);
plot(flatTopTime, flatTopX, 'r-', 'LineWidth', 1.5);
title('2. Amostragem Topo-Plano no Tempo');
xlabel('Tempo (s)'); ylabel('Amplitude');
grid on; ylim([-1.2 1.2]);

% PLOT 3: Frequência - Analítico (Natural)
subplot(2, 2, 3);
kNaturalSamples = -kMax:kMax; 
naturalFrequencyLocations = []; 
naturalMagnitudes = [];
% Amostragem Natural (usando interpolação sinc):
% X_s(jω) = (τ/Ts) * Σ_{k=-∞}^{∞} sinc(kω_sτ/2) * X(j(ω-kω_s))
% Esta expressão representa a amostragem natural
% onde o sinal é amostrado por um trem de pulsos retangulares com
% duração de τ segundos e período Ts.
for k = kNaturalSamples
    frequencyShift = k * samplingFrequency;
    naturalFrequencyLocations = [naturalFrequencyLocations, -frequency + frequencyShift, frequency + frequencyShift];
    naturalAmplitudeScale = (tau / samplingPeriod) * sinc(k * samplingFrequency * tau);
    naturalMagnitudes = [naturalMagnitudes, abs(naturalAmplitudeScale), abs(naturalAmplitudeScale)];
end
stem(naturalFrequencyLocations, naturalMagnitudes, 'b', 'Marker', '^', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
title('3. Espectro Analítico: Natural |X_n(j\omega)|');
xlabel('Frequência (Hz)'); ylabel('Magnitude');
grid on; xlim([-displayRange displayRange]);

% PLOT 4: Frequência - Analítico (Topo-Plano)
subplot(2, 2, 4);
flatTopFrequencyLocations = naturalFrequencyLocations; % Mesmas posições
flatTopMagnitudes = [];
% Amostragem Topo-Plano (flat-top sampling) - amostragem com retângulos:
% Xs(jω) = (τ/Ts) * sinc(ωsτ/(2π)) * Σ_{k=-∞}^{∞} X(j(ω-kωs))
% Neste caso, a função sinc é aplicada fora da soma, 
% caracterizando a amostragem por flat-top (efeito de abertura).
for i = 1:length(flatTopFrequencyLocations)
    flatTopFrequencyValues = flatTopFrequencyLocations(i);
    flatTopMagnitudeScale = (tau / samplingPeriod) * sinc(flatTopFrequencyValues * tau);
    flatTopMagnitudes = [flatTopMagnitudes, abs(flatTopMagnitudeScale)];
end
stem(flatTopFrequencyLocations, flatTopMagnitudes, 'r', 'Marker', '^', 'LineWidth', 1.5, 'MarkerFaceColor', 'r');
hold on;
% Envelope do sinc
sincEnvelopeFrequency = -displayRange:samplingPeriod:displayRange;
flatTopEnvelope = abs((tau / samplingPeriod) * sinc(sincEnvelopeFrequency * tau));
plot(sincEnvelopeFrequency, flatTopEnvelope, 'k--', 'LineWidth', 1);
hold off;
title('4. Espectro Analítico: Topo-Plano |X_{ft}(j\omega)|');
xlabel('Frequência (Hz)'); ylabel('Magnitude');
legend('Impulsos', 'Envelope sinc (Abertura)', 'Location', 'northeast');
grid on; xlim([-displayRange displayRange]);

% Save
set(1, 'paperunits', 'inches');
set(1, 'papersize', [19.2 10.8]);
set(1, 'paperposition', [0 0 19.2 10.8]);

set(2, 'paperunits', 'inches');
set(2, 'papersize', [19.2 10.8]);
set(2, 'paperposition', [0 0 19.2 10.8]);

% Define o caminho absoluto da pasta de saída primeiro
root_dir = fileparts(mfilename('fullpath'));
output_path = fullfile(root_dir, 'output');

% Cria a pasta no local correto (se não existir)
if ~exist(output_path, 'dir')
    mkdir(output_path);
end

% Salva os arquivos com o caminho absoluto
print(1, fullfile(output_path, 'sinais_amostragem1.png'), '-dpng', '-r100');
print(2, fullfile(output_path, 'sinais_amostragem2.png'), '-dpng', '-r100');