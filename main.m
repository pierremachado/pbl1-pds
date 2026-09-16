% =========================================================================
% MAIN.M - Análise Analítica de Amostragem com Animação (GIF)
% =========================================================================

clear; clc; close all;

% Adiciona o diretório 'src' e o 'utils' ao path de busca do MATLAB/Octave
addpath(genpath('src'));
addpath('utils');

% Configuração de diretório de saída
root_dir = fileparts(mfilename('fullpath'));
output_path = fullfile(root_dir, 'output');
if ~exist(output_path, 'dir')
    mkdir(output_path);
end

% Nomes dos arquivos de saída
gif1_fig1 = fullfile(output_path, '1_ideal_freq_change.gif');
gif1_fig2 = fullfile(output_path, '1_nat_flat_freq_change.gif');
gif2_fig1 = fullfile(output_path, '2_ideal_fs_change.gif');
gif2_fig2 = fullfile(output_path, '2_nat_flat_fs_change.gif');

% Parâmetros Globais Fixos de Tempo
startTime = 0;
endTime = 1;
numPoints = 4001;
continuousTime = linspace(startTime, endTime, numPoints);

% Configuração das Figuras
fig1 = figure(1, 'Name', 'Analise de Amostragem Ideal', 'Position', [100, 100, 1000, 800], 'Color', 'w');
fig2 = figure(2, 'Name', 'Amostragem Natural e Topo-Plano', 'Position', [150, 150, 1000, 800], 'Color', 'w');

% =========================================================================
%% ANIMAÇÃO 1: Variando a Frequência do Sinal (fs fixa)
% =========================================================================
disp('Gerando Animação 1: Variando a Frequência do Sinal...');

samplingFrequency = 50;                % fs fixa em 50 Hz (Nyquist exige f < 25 Hz)
samplingPeriod = 1/samplingFrequency;
tau = 0.20 * samplingPeriod;
displayRange = 100;                    % Fixo para a animação não pular
freq_sweep = linspace(5, 40, 35);      % Frequência varia de 5 a 40 Hz

for i = 1:length(freq_sweep)
    frequency = freq_sweep(i);
    omega = 2*pi*frequency;
    x = @(t) sin(omega * t);
    continuousSignal = x(continuousTime);
    kMax = ceil((displayRange + frequency) / samplingFrequency);

    % Cálculos
    [idealSignal, idealTime] = idealSampling(x, samplingFrequency, startTime, endTime);
    [naturalSignal, naturalTime] = naturalSampling(x, samplingFrequency, tau, startTime, endTime, numPoints);
    [flatTopSignal, flatTopTime] = flatTopSampling(x, samplingFrequency, tau, startTime, endTime, numPoints);

    % --- Atualiza Figura 1 ---
    figure(fig1); clf;
    
    subplot(2, 2, 1);
    plot(continuousTime, continuousSignal, 'b-', 'LineWidth', 1.5);
    title(sprintf('1. Sinal Contínuo (f = %.1f Hz)', frequency));
    xlabel('Tempo (s)'); ylabel('Amplitude'); grid on; ylim([-1.2 1.2]);

    subplot(2, 2, 2);
    stem(idealTime, idealSignal, 'r', 'filled', 'LineWidth', 1.5);
    title(sprintf('2. Amostragem Ideal (fs = %d Hz)', samplingFrequency));
    xlabel('Tempo (s)'); ylabel('Amplitude'); grid on; ylim([-1.2 1.2]);

    subplot(2, 2, 3);
    stem([-frequency, frequency], [0.5, 0.5], 'b', 'Marker', '^', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
    title('3. Espectro Contínuo |X(j\omega)|');
    xlabel('Frequência (Hz)'); ylabel('Magnitude'); grid on; xlim([-displayRange displayRange]); ylim([0 1]);

    subplot(2, 2, 4);
    [idealAmplitudes, idealFrequencies] = idealTransform(frequency, samplingFrequency, kMax);
    stem(idealFrequencies, abs(idealAmplitudes), 'r', 'Marker', '^', 'LineWidth', 1.5, 'MarkerFaceColor', 'r');
    title('4. Espectro Amostrado Ideal |X_s(j\omega)|');
    xlabel('Frequência (Hz)'); ylabel('Magnitude'); grid on; xlim([-displayRange displayRange]); ylim([0 27]);

    drawnow;
    frame = getframe(fig1); im = frame2im(frame); [imind, cm] = rgb2ind(im);
    if i == 1
        imwrite(imind, cm, gif1_fig1, 'gif', 'Loopcount', inf, 'DelayTime', 0.15);
    else
        imwrite(imind, cm, gif1_fig1, 'gif', 'WriteMode', 'append', 'DelayTime', 0.15);
    end

    % --- Atualiza Figura 2 ---
    figure(fig2); clf;

    subplot(2, 2, 1);
    plot(naturalTime, naturalSignal, 'b-', 'LineWidth', 1.5);
    title(sprintf('1. Amostragem Natural (f = %.1f Hz)', frequency));
    xlabel('Tempo (s)'); ylabel('Amplitude'); grid on; ylim([-1.2 1.2]);

    subplot(2, 2, 2);
    plot(flatTopTime, flatTopSignal, 'r-', 'LineWidth', 1.5);
    title(sprintf('2. Amostragem Topo-Plano (fs = %d Hz)', samplingFrequency));
    xlabel('Tempo (s)'); ylabel('Amplitude'); grid on; ylim([-1.2 1.2]);

    subplot(2, 2, 3);
    [naturalAmplitudes, naturalFrequencies] = naturalTransform(frequency, samplingFrequency, tau, kMax);
    stem(naturalFrequencies, abs(naturalAmplitudes), 'b', 'Marker', '^', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
    title('3. Espectro Natural |X_n(j\omega)|');
    xlabel('Frequência (Hz)'); ylabel('Magnitude'); grid on; xlim([-displayRange displayRange]); ylim([0 1.5]);

    subplot(2, 2, 4);
    [flatTopAmplitudes, flatTopFrequencies] = flatTopTransform(frequency, samplingFrequency, tau, kMax);
    stem(flatTopFrequencies, abs(flatTopAmplitudes), 'r', 'Marker', '^', 'LineWidth', 1.5, 'MarkerFaceColor', 'r');
    hold on;
    sincEnvelopeFrequency = -displayRange:0.1:displayRange;
    flatTopEnvelope = abs((tau / samplingPeriod) * sinc(sincEnvelopeFrequency * tau) * 0.5j);
    plot(sincEnvelopeFrequency, flatTopEnvelope, 'k--', 'LineWidth', 1); hold off;
    title('4. Espectro Topo-Plano |X_{ft}(j\omega)|');
    xlabel('Frequência (Hz)'); ylabel('Magnitude'); grid on; xlim([-displayRange displayRange]); ylim([0 1.5]);

    drawnow;
    frame = getframe(fig2); im = frame2im(frame); [imind, cm] = rgb2ind(im);
    if i == 1
        imwrite(imind, cm, gif1_fig2, 'gif', 'Loopcount', inf, 'DelayTime', 0.15);
    else
        imwrite(imind, cm, gif1_fig2, 'gif', 'WriteMode', 'append', 'DelayTime', 0.15);
    end
end

% =========================================================================
%% ANIMAÇÃO 2: Variando a Frequência de Amostragem (f fixa)
% =========================================================================
disp('Gerando Animação 2: Variando a Frequência de Amostragem...');

frequency = 20;                        % f fixa em 20 Hz (Nyquist exige fs > 40 Hz)
omega = 2*pi*frequency;
x = @(t) sin(omega * t);
continuousSignal = x(continuousTime);
displayRange = 150;                    % Fixo para a animação
fs_sweep = linspace(100, 15, 35);      % fs varia caindo de 100 até 15 Hz

for i = 1:length(fs_sweep)
    samplingFrequency = fs_sweep(i);
    samplingPeriod = 1/samplingFrequency;
    tau = 0.20 * samplingPeriod;
    kMax = ceil((displayRange + frequency) / samplingFrequency);

    % Cálculos
    [idealSignal, idealTime] = idealSampling(x, samplingFrequency, startTime, endTime);
    [naturalSignal, naturalTime] = naturalSampling(x, samplingFrequency, tau, startTime, endTime, numPoints);
    [flatTopSignal, flatTopTime] = flatTopSampling(x, samplingFrequency, tau, startTime, endTime, numPoints);

    % --- Atualiza Figura 1 ---
    figure(fig1); clf;
    
    subplot(2, 2, 1);
    plot(continuousTime, continuousSignal, 'b-', 'LineWidth', 1.5);
    title(sprintf('1. Sinal Contínuo (f = %d Hz)', frequency));
    xlabel('Tempo (s)'); ylabel('Amplitude'); grid on; ylim([-1.2 1.2]);

    subplot(2, 2, 2);
    stem(idealTime, idealSignal, 'r', 'filled', 'LineWidth', 1.5);
    title(sprintf('2. Amostragem Ideal (fs = %.1f Hz)', samplingFrequency));
    xlabel('Tempo (s)'); ylabel('Amplitude'); grid on; ylim([-1.2 1.2]);

    subplot(2, 2, 3);
    stem([-frequency, frequency], [0.5, 0.5], 'b', 'Marker', '^', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
    title('3. Espectro Contínuo |X(j\omega)|');
    xlabel('Frequência (Hz)'); ylabel('Magnitude'); grid on; xlim([-displayRange displayRange]); ylim([0 1]);

    subplot(2, 2, 4);
    [idealAmplitudes, idealFrequencies] = idealTransform(frequency, samplingFrequency, kMax);
    stem(idealFrequencies, abs(idealAmplitudes), 'r', 'Marker', '^', 'LineWidth', 1.5, 'MarkerFaceColor', 'r');
    title('4. Espectro Amostrado Ideal |X_s(j\omega)|');
    xlabel('Frequência (Hz)'); ylabel('Magnitude'); grid on; xlim([-displayRange displayRange]); ylim([0 52]);

    drawnow;
    frame = getframe(fig1); im = frame2im(frame); [imind, cm] = rgb2ind(im);
    if i == 1
        imwrite(imind, cm, gif2_fig1, 'gif', 'Loopcount', inf, 'DelayTime', 0.15);
    else
        imwrite(imind, cm, gif2_fig1, 'gif', 'WriteMode', 'append', 'DelayTime', 0.15);
    end

    % --- Atualiza Figura 2 ---
    figure(fig2); clf;

    subplot(2, 2, 1);
    plot(naturalTime, naturalSignal, 'b-', 'LineWidth', 1.5);
    title(sprintf('1. Amostragem Natural (fs = %.1f Hz)', samplingFrequency));
    xlabel('Tempo (s)'); ylabel('Amplitude'); grid on; ylim([-1.2 1.2]);

    subplot(2, 2, 2);
    plot(flatTopTime, flatTopSignal, 'r-', 'LineWidth', 1.5);
    title(sprintf('2. Amostragem Topo-Plano (fs = %.1f Hz)', samplingFrequency));
    xlabel('Tempo (s)'); ylabel('Amplitude'); grid on; ylim([-1.2 1.2]);

    subplot(2, 2, 3);
    [naturalAmplitudes, naturalFrequencies] = naturalTransform(frequency, samplingFrequency, tau, kMax);
    stem(naturalFrequencies, abs(naturalAmplitudes), 'b', 'Marker', '^', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
    title('3. Espectro Natural |X_n(j\omega)|');
    xlabel('Frequência (Hz)'); ylabel('Magnitude'); grid on; xlim([-displayRange displayRange]); ylim([0 1.5]);

    subplot(2, 2, 4);
    [flatTopAmplitudes, flatTopFrequencies] = flatTopTransform(frequency, samplingFrequency, tau, kMax);
    stem(flatTopFrequencies, abs(flatTopAmplitudes), 'r', 'Marker', '^', 'LineWidth', 1.5, 'MarkerFaceColor', 'r');
    hold on;
    sincEnvelopeFrequency = -displayRange:0.1:displayRange;
    flatTopEnvelope = abs((tau / samplingPeriod) * sinc(sincEnvelopeFrequency * tau) * 0.5j);
    plot(sincEnvelopeFrequency, flatTopEnvelope, 'k--', 'LineWidth', 1); hold off;
    title('4. Espectro Topo-Plano |X_{ft}(j\omega)|');
    xlabel('Frequência (Hz)'); ylabel('Magnitude'); grid on; xlim([-displayRange displayRange]); ylim([0 1.5]);

    drawnow;
    frame = getframe(fig2); im = frame2im(frame); [imind, cm] = rgb2ind(im);
    if i == 1
        imwrite(imind, cm, gif2_fig2, 'gif', 'Loopcount', inf, 'DelayTime', 0.15);
    else
        imwrite(imind, cm, gif2_fig2, 'gif', 'WriteMode', 'append', 'DelayTime', 0.15);
    end
end

disp('Animações concluídas com sucesso e salvas na pasta "output"!');

# % TODO: Reconstrução do Sinal
# % TODO: Caso com Aliasing

# %% RECONSTRUÇÃO IDEAL

# [idealReconstructionSignal, filteredIdealMagnitudes] = ...
#     idealReconstruction( ...
#         idealFrequencies, ...
#         idealAmplitudes, ...
#         samplingFrequency, ...
#         continuousTime);

# %% FIGURA 3 - RECONSTRUÇÃO IDEAL

# figure(3, 'Name', 'Reconstrução Ideal', ...
#     'Position', [200, 100, 1000, 700]);

# % Sinal reconstruído
# subplot(2, 1, 1);

# plot(continuousTime, idealReconstructionSignal, ...
#     'r-', 'LineWidth', 1.5);

# title('1. Sinal Reconstruído no Domínio do Tempo');
# xlabel('Tempo (s)');
# ylabel('Amplitude');

# grid on;
# xlim([startTime endTime]);
# ylim([-1.2 1.2]);


# % Espectro filtrado
# subplot(2, 1, 2);

# stem(idealFrequencies, ...
#     abs(filteredIdealMagnitudes), ...
#     'r', ...
#     'Marker', '^', ...
#     'LineWidth', 1.5, ...
#     'MarkerFaceColor', 'r');

# title('2. Espectro Após o Filtro Ideal');
# xlabel('Frequência (Hz)');
# ylabel('Magnitude');

# grid on;
# xlim([-displayRange displayRange]);
# ylim([0 0.6]);

# %% RECONSTRUÇÃO NATURAL

# [naturalReconstructionSignal, filteredNaturalMagnitudes] = ...
#     naturalReconstruction( ...
#         naturalFrequencies, ...
#         naturalAmplitudes, ...
#         samplingFrequency, ...
#         tau, ...
#         continuousTime);

# %% FIGURA 4 - RECONSTRUÇÃO NATURAL

# figure(4, 'Name', 'Reconstrução Natural', ...
#     'Position', [250, 100, 1000, 700]);

# % Sinal reconstruído
# subplot(2, 1, 1);

# plot(continuousTime, naturalReconstructionSignal, ...
#     'b-', 'LineWidth', 1.5);

# title('1. Sinal Reconstruído no Domínio do Tempo');
# xlabel('Tempo (s)');
# ylabel('Amplitude');

# grid on;
# xlim([startTime endTime]);
# ylim([-1.2 1.2]);


# % Espectro filtrado
# subplot(2, 1, 2);

# stem(naturalFrequencies, ...
#     filteredNaturalMagnitudes, ...
#     'b', ...
#     'Marker', '^', ...
#     'LineWidth', 1.5, ...
#     'MarkerFaceColor', 'b');

# title('2. Espectro Após o Filtro Ideal');
# xlabel('Frequência (Hz)');
# ylabel('Magnitude');

# grid on;
# xlim([-displayRange displayRange]);

# %% RECONSTRUÇÃO TOPO-PLANO

# [flatTopReconstructionSignal, filteredFlatTopMagnitudes] = ...
#     flatTopReconstruction( ...
#         flatTopFrequencies, ...
#         flatTopAmplitudes, ...
#         samplingFrequency, ...
#         tau, ...
#         continuousTime);

# %% FIGURA 5 - RECONSTRUÇÃO TOPO-PLANO

# figure(5, 'Name', 'Reconstrução Topo-Plano', ...
#     'Position', [300, 100, 1000, 700]);

# % Sinal reconstruído
# subplot(2, 1, 1);

# plot(continuousTime, flatTopReconstructionSignal, ...
#     'r-', 'LineWidth', 1.5);

# title('1. Sinal Reconstruído no Domínio do Tempo');
# xlabel('Tempo (s)');
# ylabel('Amplitude');

# grid on;
# xlim([startTime endTime]);
# ylim([-1.2 1.2]);


# % Espectro filtrado
# subplot(2, 1, 2);

# stem(flatTopFrequencies, ...
#     filteredFlatTopMagnitudes, ...
#     'r', ...
#     'Marker', '^', ...
#     'LineWidth', 1.5, ...
#     'MarkerFaceColor', 'r');

# title('2. Espectro Após o Filtro Ideal');
# xlabel('Frequência (Hz)');
# ylabel('Magnitude');

# grid on;
# xlim([-displayRange displayRange]);

# % TODO: Avaliar casos com Aliasing e não executar análise por FFT.
