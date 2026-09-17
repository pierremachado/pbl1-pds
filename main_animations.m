% =========================================================================
% MAIN_ANIMATIONS.M - Animações (GIF) de Amostragem e Reconstrução
% =========================================================================
%
% Gera 12 GIFs no total (6 por sweep), comparando o sinal contínuo com
% cada método de amostragem/reconstrução (ideal, natural, topo-plano):
%
%   Sweep 1 (variando a frequência do sinal, fs fixa):
%     1_freq_change_sampling_ideal.gif
%     1_freq_change_sampling_natural.gif
%     1_freq_change_sampling_flattop.gif
%     1_freq_change_reconstruction_ideal.gif
%     1_freq_change_reconstruction_natural.gif
%     1_freq_change_reconstruction_flattop.gif
%
%   Sweep 2 (variando a frequência de amostragem, f fixa):
%     2_fs_change_sampling_ideal.gif
%     2_fs_change_sampling_natural.gif
%     2_fs_change_sampling_flattop.gif
%     2_fs_change_reconstruction_ideal.gif
%     2_fs_change_reconstruction_natural.gif
%     2_fs_change_reconstruction_flattop.gif
%
% Cada GIF junta o gráfico contínuo com o método correspondente lado a
% lado, para facilitar a comparação direta dos resultados.

clear; clc; close all;

addpath(genpath('src'));
addpath('utils');

root_dir = fileparts(mfilename('fullpath'));
output_path = fullfile(root_dir, 'output');
if ~exist(output_path, 'dir')
    mkdir(output_path);
end

startTime = 0;
endTime = 1;

% Ajuste estes parâmetros conforme a velocidade do seu computador:
%   - numPoints: pontos do sinal contínuo (menor = mais rápido, menos suave)
%   - numFramesPerSweep: quantidade de quadros por animação (menor = mais rápido)
% Em ambientes mais lentos (ex: sem interface gráfica Qt/FLTK), considere
% reduzir numFramesPerSweep para acelerar a geração dos 12 GIFs.
numPoints = 2001;
numFramesPerSweep = 35;

% =========================================================================
%% SWEEP 1: Variando a Frequência do Sinal (fs fixa)
% =========================================================================
disp('Gerando animações do Sweep 1: variando a frequência do sinal...');

samplingFrequencyFixed = 50;               % fs fixa (Nyquist exige f < 25 Hz)
displayRangeSweep1 = 100;                  % fixo para a animação não "pular"
freqSweep1 = linspace(5, 40, numFramesPerSweep);          % frequência varia de 5 a 40 Hz

runAnimationSweep( ...
    'Sweep 1 (variando f)', ...
    freqSweep1, samplingFrequencyFixed, ...
    startTime, endTime, numPoints, ...
    displayRangeSweep1, ...
    '1_freq_change', ...
    output_path);

% =========================================================================
%% SWEEP 2: Variando a Frequência de Amostragem (f fixa)
% =========================================================================
disp('Gerando animações do Sweep 2: variando a frequência de amostragem...');

frequencyFixed = 20;                       % f fixa (Nyquist exige fs > 40 Hz)
displayRangeSweep2 = 150;                  % fixo para a animação
fsSweep2 = linspace(100, 15, numFramesPerSweep);          % fs varia caindo de 100 até 15 Hz

runAnimationSweep( ...
    'Sweep 2 (variando fs)', ...
    frequencyFixed, fsSweep2, ...
    startTime, endTime, numPoints, ...
    displayRangeSweep2, ...
    '2_fs_change', ...
    output_path);

fprintf('\nAnimações concluídas com sucesso! Arquivos salvos em: %s\n', output_path);
