function runContinuousAnimationSweep( ...
        sweepLabel, ...
        f1Sweep, f2Sweep, ...
        startTime, endTime, numPoints, ...
        displayRange, ...
        gifPrefix, ...
        outputPath ...
    )
    % runContinuousAnimationSweep - Gera 1 GIF animando a reconstrução
    % contínua com a filtragem de frequências, variando f1 ou f2.

    numFrames = max(length(f1Sweep), length(f2Sweep));
    if isscalar(f1Sweep), f1Sweep = repmat(f1Sweep, 1, numFrames); end
    if isscalar(f2Sweep), f2Sweep = repmat(f2Sweep, 1, numFrames); end

    continuousTime = linspace(startTime, endTime, numPoints);
    gifPath = fullfile(outputPath, sprintf('%s_continuous_reconstruction.gif', gifPrefix));
    
    figCont = figure('Position', [100, 100, 1000, 800], 'Color', 'w');
    fprintf('  %s: %d frames...\n', sweepLabel, numFrames);

    for i = 1:numFrames
        f1 = f1Sweep(i);
        f2 = f2Sweep(i);

        fprintf('    Frame %d/%d (f1=%.1f Hz, f2=%.1f Hz)\n', i, numFrames, f1, f2);

        % Cria o sinal composto x_c(t)
        compSignal = sin(2*pi*f1*continuousTime) + 0.25*sin(2*pi*f2*continuousTime);
        
        % Frequências e amplitudes analíticas do sinal composto
        compFrequencies = [-f2, -f1, f1, f2];
        compAmplitudes = [0.125j, 0.5j, -0.5j, -0.125j];
        
        % O corte é feito na primeira frequência para isolá-la
        cutoffFrequency = f1 * (1 + 1e-6);

        % Aplica a reconstrução contínua (filtragem)
        [compReconSignal, filteredCompAmplitudes] = continuousReconstruction( ...
            compFrequencies, compAmplitudes, cutoffFrequency, continuousTime);

        frameTitle = sprintf('f_1 = %.1f Hz | f_2 = %.1f Hz | Corte = %.2f Hz', f1, f2, cutoffFrequency);

        % Atualiza o frame e adiciona ao GIF
        figure(figCont); clf;
        plotContinuousReconFrame( ...
            continuousTime, compSignal, compReconSignal, ...
            compFrequencies, compAmplitudes, filteredCompAmplitudes, ...
            displayRange, frameTitle ...
        );
        appendGifFrame(figCont, gifPath, i);
    end

    close(figCont);
    fprintf('    GIF salvo: %s\n', gifPath);
end