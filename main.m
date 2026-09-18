% =========================================================================
% MAIN.M - Análise Analítica de Amostragem (Ideal, Natural e Topo-Plano)
% Casos: Nyquist Respeitado vs Aliasing (Nyquist Violado)
% =========================================================================
%
% Este script gera, para cada caso (Nyquist OK / Aliasing), as figuras de:
%   - Amostragem ideal, natural e topo-plano (sinal no tempo + espectro)
%   - Reconstrução ideal, natural e topo-plano (sinal reconstruído + espectro)
%
% No caso de aliasing, as figuras de reconstrução incluem uma sobreposição
% tracejada do sinal original, evidenciando a frequência "fantasma" que a
% reconstrução efetivamente recupera.
%
% Todas as figuras são salvas como PNG na pasta 'output'.

clear; clc; close all;

% Adiciona o diretório 'src' e o 'utils' ao path de busca do MATLAB/Octave
addpath(genpath('src'));
addpath('utils');

% -------------------------------------------------------------------
% Parâmetros comuns
% -------------------------------------------------------------------
samplingFrequency = 50;    % Frequência de amostragem (Hz), fixa nos dois casos
nyquistFrequency = samplingFrequency / 2;

startTime = 0;
endTime = 1;
numPoints = 5001;

% Define o caminho absoluto da pasta de saída
root_dir = fileparts(mfilename('fullpath'));
output_path = fullfile(root_dir, 'output');
if ~exist(output_path, 'dir')
    mkdir(output_path);
end

fprintf('Frequência de amostragem fixa: fs = %d Hz (Nyquist = %.1f Hz)\n\n', ...
    samplingFrequency, nyquistFrequency);

% -------------------------------------------------------------------
% CASO 1: Nyquist Respeitado (f < fs/2)
% -------------------------------------------------------------------
frequencyNyquistOk = 5; % Hz

runSamplingCase( ...
    'Nyquist Respeitado', 'nyquist_ok', ...
    frequencyNyquistOk, samplingFrequency, ...
    startTime, endTime, numPoints, ...
    output_path);

% -------------------------------------------------------------------
% CASO 2: Aliasing (f > fs/2)
% -------------------------------------------------------------------
frequencyAliasing = 40; % Hz (> 25 Hz de Nyquist)

runSamplingCase( ...
    'Aliasing', 'aliasing', ...
    frequencyAliasing, samplingFrequency, ...
    startTime, endTime, numPoints, ...
    output_path);

fprintf('\nAnálise estática concluída. Figuras salvas em: %s\n', output_path);
