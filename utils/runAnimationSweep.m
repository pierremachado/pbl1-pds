function runAnimationSweep( ...
        sweepLabel, ...
        freqSweep, fsSweep, ...
        startTime, endTime, numPoints, ...
        displayRange, ...
        gifPrefix, ...
        outputPath ...
    )
    % runAnimationSweep - Gera 6 GIFs comparando o sinal contínuo com cada
    % método de amostragem/reconstrução (ideal, natural, topo-plano),
    % variando quadro a quadro conforme freqSweep e fsSweep (um dos dois
    % deve ser escalar quando o outro varia, ou ambos vetores do mesmo
    % tamanho).
    %
    % gifPrefix: prefixo usado nos nomes de arquivo (ex: '1_freq_change')

    numFrames = max(length(freqSweep), length(fsSweep));
    if isscalar(freqSweep)
        freqSweep = repmat(freqSweep, 1, numFrames);
    end
    if isscalar(fsSweep)
        fsSweep = repmat(fsSweep, 1, numFrames);
    end

    continuousTime = linspace(startTime, endTime, numPoints);

    % Nomes dos arquivos de saída (6 GIFs: amostragem x3 + reconstrução x3)
    gifSamplingIdeal    = fullfile(outputPath, sprintf('%s_sampling_ideal.gif', gifPrefix));
    gifSamplingNatural  = fullfile(outputPath, sprintf('%s_sampling_natural.gif', gifPrefix));
    gifSamplingFlatTop  = fullfile(outputPath, sprintf('%s_sampling_flattop.gif', gifPrefix));
    gifReconIdeal       = fullfile(outputPath, sprintf('%s_reconstruction_ideal.gif', gifPrefix));
    gifReconNatural     = fullfile(outputPath, sprintf('%s_reconstruction_natural.gif', gifPrefix));
    gifReconFlatTop     = fullfile(outputPath, sprintf('%s_reconstruction_flattop.gif', gifPrefix));

    % Figuras únicas, reutilizadas a cada frame (mais rápido que recriar)
    figSamplingIdeal   = figure('Position', [50,  50, 900, 700], 'Color', 'w');
    figSamplingNatural = figure('Position', [100, 50, 900, 700], 'Color', 'w');
    figSamplingFlatTop = figure('Position', [150, 50, 900, 700], 'Color', 'w');
    figReconIdeal      = figure('Position', [200, 50, 900, 700], 'Color', 'w');
    figReconNatural    = figure('Position', [250, 50, 900, 700], 'Color', 'w');
    figReconFlatTop    = figure('Position', [300, 50, 900, 700], 'Color', 'w');

    fprintf('  %s: %d frames...\n', sweepLabel, numFrames);

    for i = 1:numFrames
        frequency = freqSweep(i);
        samplingFrequency = fsSweep(i);

        fprintf('    Frame %d/%d (f=%.1f Hz, fs=%.1f Hz)\n', i, numFrames, frequency, samplingFrequency);

        omega = 2 * pi * frequency;
        samplingPeriod = 1 / samplingFrequency;
        tau = 0.2 * samplingPeriod;
        kMax = ceil((displayRange + frequency) / samplingFrequency);

        x = @(t) sin(omega * t);
        continuousSignal = x(continuousTime);
        continuousFrequencies = [-frequency, frequency];
        continuousAmplitudes = [0.5j, -0.5j];

        % --- Cálculos: amostragem ---
        [idealSignal, idealTime] = idealSampling(x, samplingFrequency, startTime, endTime);
        [idealAmplitudes, idealFrequencies] = idealTransform(frequency, samplingFrequency, kMax);

        [naturalSignal, naturalTime] = naturalSampling(x, samplingFrequency, tau, startTime, endTime, numPoints);
        [naturalAmplitudes, naturalFrequencies] = naturalTransform(frequency, samplingFrequency, tau, kMax);

        [flatTopSignal, flatTopTime] = flatTopSampling(x, samplingFrequency, tau, startTime, endTime, numPoints);
        [flatTopAmplitudes, flatTopFrequencies] = flatTopTransform(frequency, samplingFrequency, tau, kMax);

        % --- Cálculos: reconstrução ---
        [idealReconSignal, idealReconAmps] = idealReconstruction( ...
            idealFrequencies, idealAmplitudes, samplingFrequency, continuousTime);
        [naturalReconSignal, naturalReconAmps] = naturalReconstruction( ...
            naturalFrequencies, naturalAmplitudes, samplingFrequency, tau, continuousTime);
        [flatTopReconSignal, flatTopReconAmps] = flatTopReconstruction( ...
            flatTopFrequencies, flatTopAmplitudes, samplingFrequency, tau, continuousTime);

        frameTitle = sprintf('f = %.1f Hz | fs = %.1f Hz', frequency, samplingFrequency);

        % --- Frame: Amostragem Ideal ---
        figure(figSamplingIdeal); clf;
        plotSamplingFrame( ...
            continuousTime, continuousSignal, idealTime, idealSignal, ...
            continuousFrequencies, continuousAmplitudes, idealFrequencies, idealAmplitudes, ...
            displayRange, ...
            sprintf('Sinal Contínuo (%s)', frameTitle), 'Amostragem Ideal', ...
            'r', 'stem', []);
        appendGifFrame(figSamplingIdeal, gifSamplingIdeal, i);

        % --- Frame: Amostragem Natural ---
        figure(figSamplingNatural); clf;
        plotSamplingFrame( ...
            continuousTime, continuousSignal, naturalTime, naturalSignal, ...
            continuousFrequencies, continuousAmplitudes, naturalFrequencies, naturalAmplitudes, ...
            displayRange, ...
            sprintf('Sinal Contínuo (%s)', frameTitle), 'Amostragem Natural', ...
            'b', 'plot', []);
        appendGifFrame(figSamplingNatural, gifSamplingNatural, i);

        % --- Frame: Amostragem Topo-Plano ---
        figure(figSamplingFlatTop); clf;
        plotSamplingFrame( ...
            continuousTime, continuousSignal, flatTopTime, flatTopSignal, ...
            continuousFrequencies, continuousAmplitudes, flatTopFrequencies, flatTopAmplitudes, ...
            displayRange, ...
            sprintf('Sinal Contínuo (%s)', frameTitle), 'Amostragem Topo-Plano', ...
            'r', 'plot', []);
        appendGifFrame(figSamplingFlatTop, gifSamplingFlatTop, i);

        % --- Frame: Reconstrução Ideal ---
        figure(figReconIdeal); clf;
        plotReconstructionFrame( ...
            continuousTime, continuousSignal, idealReconSignal, ...
            idealFrequencies, idealReconAmps, displayRange, ...
            sprintf('Sinal Contínuo (%s)', frameTitle), 'Reconstrução Ideal', ...
            'r', [0 0.6]);
        appendGifFrame(figReconIdeal, gifReconIdeal, i);

        % --- Frame: Reconstrução Natural ---
        figure(figReconNatural); clf;
        plotReconstructionFrame( ...
            continuousTime, continuousSignal, naturalReconSignal, ...
            naturalFrequencies, naturalReconAmps, displayRange, ...
            sprintf('Sinal Contínuo (%s)', frameTitle), 'Reconstrução Natural', ...
            'b', [0 0.6]);
        appendGifFrame(figReconNatural, gifReconNatural, i);

        % --- Frame: Reconstrução Topo-Plano ---
        figure(figReconFlatTop); clf;
        plotReconstructionFrame( ...
            continuousTime, continuousSignal, flatTopReconSignal, ...
            flatTopFrequencies, flatTopReconAmps, displayRange, ...
            sprintf('Sinal Contínuo (%s)', frameTitle), 'Reconstrução Topo-Plano', ...
            'r', [0 0.6]);
        appendGifFrame(figReconFlatTop, gifReconFlatTop, i);
    end

    close(figSamplingIdeal); close(figSamplingNatural); close(figSamplingFlatTop);
    close(figReconIdeal); close(figReconNatural); close(figReconFlatTop);

    fprintf('    GIFs salvos:\n');
    fprintf('      %s\n', gifSamplingIdeal);
    fprintf('      %s\n', gifSamplingNatural);
    fprintf('      %s\n', gifSamplingFlatTop);
    fprintf('      %s\n', gifReconIdeal);
    fprintf('      %s\n', gifReconNatural);
    fprintf('      %s\n', gifReconFlatTop);
end
