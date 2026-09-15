% =========================================================================
% MAIN.M - Análise Analítica de Amostragem (Ideal, Natural e Topo-Plano)
% =========================================================================

clear; clc; close all;

% Adiciona o diretório 'src' e o 'utils' ao path de busca do MATLAB/Octave
addpath(genpath('src'));
addpath('utils');

%% 1. Definição dos Parâmetros Globais
frequency = 5;                         % Frequência do sinal original (Hz)
omega = 2*pi*frequency;                % Frequência angular (rad/s)
samplingFrequency = 50;                % Frequência de amostragem (Hz)
samplingPeriod = 1/samplingFrequency;  % Período de amostragem (s)
tau = 0.20 * samplingPeriod;            % Largura do pulso (50% do período); Considerar usar percentual menor.
displayRange = 4 * samplingFrequency;
kMax = ceil((displayRange + frequency) / samplingFrequency);

startTime = 0;                         % Tempo inicial
endTime = 1;                           % Tempo final

% Define o sinal de origem como um "function handle" para passar às funções
x = @(t) sin(omega * t);

% Eixo de tempo do sinal base
numPoints = 4001; % Número de pontos para plotar
continuousTime = linspace(startTime, endTime, numPoints);
continuousSignal = x(continuousTime);

% Amostragem Ideal
[idealSignal, idealTime] = idealSampling(x, samplingFrequency, startTime, endTime);

% Amostragem Natural
[naturalSignal, naturalTime] = naturalSampling(x, samplingFrequency, tau, startTime, endTime, numPoints);

% Amostragem Topo-Plano
[flatTopSignal, flatTopTime] = flatTopSampling(x, samplingFrequency, tau, startTime, endTime, numPoints);

%% FIGURA 1
figure(1, 'Name', 'Analise de Amostragem Ideal', 'Position', [100, 100, 1000, 800]);

% PLOT 1: Tempo - Sinal Contínuo
subplot(2, 2, 1);
plot(continuousTime, continuousSignal, 'b-', 'LineWidth', 1.5);
title('1. Sinal Contínuo x(t) = sen(\omega_0 t)');
xlabel('Tempo (s)'); ylabel('Amplitude');
grid on; ylim([-1.2 1.2]);

% PLOT 2: Tempo - Amostrado de forma Ideal
subplot(2, 2, 2);
stem(idealTime, idealSignal, 'r', 'filled', 'LineWidth', 1.5);
title('2. Amostragem Ideal (Tempo)');
xlabel('Tempo (s)'); ylabel('Amplitude');
grid on; ylim([-1.2 1.2]);

% PLOT 3: Frequência - Analítico (Contínuo)
subplot(2, 2, 3);
continuousFrequencies = [-frequency, frequency];
continuousAmplitudes = [0.5, 0.5];
stem(continuousFrequencies, continuousAmplitudes, 'b', 'Marker', '^', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
title('3. Espectro Contínuo Analítico |X(j\omega)|');
xlabel('Frequência (Hz)'); ylabel('Magnitude');
grid on; xlim([-displayRange displayRange]);

% PLOT 4: Frequência - Analítico (Amostrado Ideal)
subplot(2, 2, 4);
[idealAmplitudes, idealFrequencies] = idealTransform(frequency, samplingFrequency, kMax);
stem(idealFrequencies, abs(idealAmplitudes), 'r', 'Marker', '^', 'LineWidth', 1.5, 'MarkerFaceColor', 'r');
title('4. Espectro Amostrado Ideal Analítico |X_s(j\omega)|');
xlabel('Frequência (Hz)'); ylabel('Magnitude');
grid on; xlim([-displayRange displayRange]); ylim([0 (0.5*samplingFrequency)+2]);

%% FIGURA 2
figure(2, 'Name', 'Amostragem Natural e Topo-Plano', 'Position', [150, 150, 1000, 800]);

% PLOT 1: Tempo - Amostragem Natural
subplot(2, 2, 1);
plot(naturalTime, naturalSignal, 'b-', 'LineWidth', 1.5);
title('1. Amostragem Natural no Tempo');
xlabel('Tempo (s)'); ylabel('Amplitude');
grid on; ylim([-1.2 1.2]);

% PLOT 2: Tempo - Amostragem Topo-Plano
subplot(2, 2, 2);
plot(flatTopTime, flatTopSignal, 'r-', 'LineWidth', 1.5);
title('2. Amostragem Topo-Plano no Tempo');
xlabel('Tempo (s)'); ylabel('Amplitude');
grid on; ylim([-1.2 1.2]);

% PLOT 3: Frequência - Analítico (Natural)
subplot(2, 2, 3);
[naturalAmplitudes, naturalFrequencies] = naturalTransform(frequency, samplingFrequency, tau, kMax);
stem(naturalFrequencies, abs(naturalAmplitudes), 'b', 'Marker', '^', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
title('3. Espectro Analítico: Natural |X_n(j\omega)|');
xlabel('Frequência (Hz)'); ylabel('Magnitude');
grid on; xlim([-displayRange displayRange]);

% PLOT 4: Frequência - Analítico (Topo-Plano)
subplot(2, 2, 4);
[flatTopAmplitudes, flatTopFrequencies] = flatTopTransform(frequency, samplingFrequency, tau, kMax);
stem(flatTopFrequencies, abs(flatTopAmplitudes), 'r', 'Marker', '^', 'LineWidth', 1.5, 'MarkerFaceColor', 'r');
hold on;
% Envelope do sinc
sincEnvelopeFrequency = -displayRange:samplingPeriod:displayRange;
flatTopEnvelope = abs((tau / samplingPeriod) * sinc(sincEnvelopeFrequency * tau) * 0.5j);
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

% TODO: Reconstrução do Sinal
% TODO: Caso com Aliasing

%% RECONSTRUÇÃO IDEAL

[idealReconstructionSignal, filteredIdealMagnitudes] = ...
    idealReconstruction( ...
        idealFrequencies, ...
        idealAmplitudes, ...
        samplingFrequency, ...
        continuousTime);

%% FIGURA 3 - RECONSTRUÇÃO IDEAL

figure(3, 'Name', 'Reconstrução Ideal', ...
    'Position', [200, 100, 1000, 700]);

% Sinal reconstruído
subplot(2, 1, 1);

plot(continuousTime, idealReconstructionSignal, ...
    'r-', 'LineWidth', 1.5);

title('1. Sinal Reconstruído no Domínio do Tempo');
xlabel('Tempo (s)');
ylabel('Amplitude');

grid on;
xlim([startTime endTime]);
ylim([-1.2 1.2]);


% Espectro filtrado
subplot(2, 1, 2);

stem(idealFrequencies, ...
    abs(filteredIdealMagnitudes), ...
    'r', ...
    'Marker', '^', ...
    'LineWidth', 1.5, ...
    'MarkerFaceColor', 'r');

title('2. Espectro Após o Filtro Ideal');
xlabel('Frequência (Hz)');
ylabel('Magnitude');

grid on;
xlim([-displayRange displayRange]);
ylim([0 0.6]);

%% RECONSTRUÇÃO NATURAL

[naturalReconstructionSignal, filteredNaturalMagnitudes] = ...
    naturalReconstruction( ...
        naturalFrequencies, ...
        naturalAmplitudes, ...
        samplingFrequency, ...
        tau, ...
        continuousTime);

%% FIGURA 4 - RECONSTRUÇÃO NATURAL

figure(4, 'Name', 'Reconstrução Natural', ...
    'Position', [250, 100, 1000, 700]);

% Sinal reconstruído
subplot(2, 1, 1);

plot(continuousTime, naturalReconstructionSignal, ...
    'b-', 'LineWidth', 1.5);

title('1. Sinal Reconstruído no Domínio do Tempo');
xlabel('Tempo (s)');
ylabel('Amplitude');

grid on;
xlim([startTime endTime]);
ylim([-1.2 1.2]);


% Espectro filtrado
subplot(2, 1, 2);

stem(naturalFrequencies, ...
    filteredNaturalMagnitudes, ...
    'b', ...
    'Marker', '^', ...
    'LineWidth', 1.5, ...
    'MarkerFaceColor', 'b');

title('2. Espectro Após o Filtro Ideal');
xlabel('Frequência (Hz)');
ylabel('Magnitude');

grid on;
xlim([-displayRange displayRange]);

%% RECONSTRUÇÃO TOPO-PLANO

[flatTopReconstructionSignal, filteredFlatTopMagnitudes] = ...
    flatTopReconstruction( ...
        flatTopFrequencies, ...
        flatTopAmplitudes, ...
        samplingFrequency, ...
        tau, ...
        continuousTime);

%% FIGURA 5 - RECONSTRUÇÃO TOPO-PLANO

figure(5, 'Name', 'Reconstrução Topo-Plano', ...
    'Position', [300, 100, 1000, 700]);

% Sinal reconstruído
subplot(2, 1, 1);

plot(continuousTime, flatTopReconstructionSignal, ...
    'r-', 'LineWidth', 1.5);

title('1. Sinal Reconstruído no Domínio do Tempo');
xlabel('Tempo (s)');
ylabel('Amplitude');

grid on;
xlim([startTime endTime]);
ylim([-1.2 1.2]);


% Espectro filtrado
subplot(2, 1, 2);

stem(flatTopFrequencies, ...
    filteredFlatTopMagnitudes, ...
    'r', ...
    'Marker', '^', ...
    'LineWidth', 1.5, ...
    'MarkerFaceColor', 'r');

title('2. Espectro Após o Filtro Ideal');
xlabel('Frequência (Hz)');
ylabel('Magnitude');

grid on;
xlim([-displayRange displayRange]);

% TODO: Avaliar casos com Aliasing e não executar análise por FFT.
