% =========================================================================
% MAIN_CONTINUOUS_ANIMATIONS.M - Animações (GIF) da Reconstrução Contínua
% =========================================================================

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
numPoints = 2001;
numFramesPerSweep = 40;

displayRange = 60; % Fixo para a animação não ficar "pulando" o eixo X

% =========================================================================
%% SWEEP 1: Variando a Frequência da 1ª Senoide (f1), com f2 fixa
% =========================================================================
disp('Gerando animação do Sweep 1: variando a frequência da 1ª senoide (f1)...');

f2Fixed = 5; % Hz
f1Sweep = linspace(1, 20, numFramesPerSweep); % f1 varia de 1 a 10 Hz

runContinuousAnimationSweep( ...
    'Sweep 1 (variando f1)', ...
    f1Sweep, f2Fixed, ...
    startTime, endTime, numPoints, ...
    displayRange, ...
    '1_f1_change', ...
    output_path);

% =========================================================================
%% SWEEP 2: Variando a Frequência da 2ª Senoide (f2), com f1 fixa
% =========================================================================
disp('Gerando animação do Sweep 2: variando a frequência da 2ª senoide (f2)...');

f1Fixed = 5; % Hz
f2Sweep = linspace(1, 20, numFramesPerSweep); % f2 varia, impactando o harmônico

runContinuousAnimationSweep( ...
    'Sweep 2 (variando f2)', ...
    f1Fixed, f2Sweep, ...
    startTime, endTime, numPoints, ...
    displayRange, ...
    '2_f2_change', ...
    output_path);

fprintf('\nAnimações contínuas concluídas com sucesso! Arquivos salvos em: %s\n', output_path);