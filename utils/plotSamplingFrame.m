function plotSamplingFrame( ...
        continuousTime, continuousSignal, ...
        sampledTime, sampledSignal, ...
        continuousFrequencies, continuousAmplitudes, ...
        sampledFrequencies, sampledAmplitudes, ...
        displayRange, ...
        titleContinuous, titleSampled, ...
        sampledColor, sampledStyle, ...
        magYLim ...
    )
    % plotSamplingFrame - Desenha um frame de 4 subplots (2x2) comparando o
    % sinal contínuo com uma versão amostrada, em tempo e frequência.
    % Assume que a figura de destino já está ativa e foi limpa (clf).

    subplot(3, 2, 1);
    plot(continuousTime, continuousSignal, 'b-', 'LineWidth', 1.5);
    title(titleContinuous);
    xlabel('Tempo (s)'); ylabel('Amplitude'); grid on; ylim([-1.2 1.2]);

    subplot(3, 2, 2);
    if strcmp(sampledStyle, 'stem')
        stem(sampledTime, sampledSignal, sampledColor, 'filled', 'LineWidth', 1.5);
    else
        plot(sampledTime, sampledSignal, [sampledColor '-'], 'LineWidth', 1.5);
    end
    title(titleSampled);
    xlabel('Tempo (s)'); ylabel('Amplitude'); grid on; ylim([-1.2 1.2]);

    subplot(3, 2, 3);
    stem(continuousFrequencies, abs(continuousAmplitudes), 'b', 'Marker', '^', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
    title('Espectro Contínuo |X(f)|');
    xlabel('Frequência (Hz)'); ylabel('Magnitude'); grid on;
    xlim([-displayRange displayRange]); ylim([0 0.6]);

    subplot(3, 2, 4);
    stem(sampledFrequencies, abs(sampledAmplitudes), sampledColor, 'Marker', '^', 'LineWidth', 1.5, 'MarkerFaceColor', sampledColor);
    title('Espectro Amostrado X_s(f)');
    xlabel('Frequência (Hz)'); ylabel('Magnitude'); grid on;
    xlim([-displayRange displayRange]);
    if ~isempty(magYLim)
        ylim(magYLim);
    end

    subplot(3, 2, 5);
    stem(continuousFrequencies, arg(continuousAmplitudes), 'b', 'Filled', 'LineWidth', 1.5);
    title('Espectro Contínuo ∠X(f)');
    xlabel('Frequência (Hz)'); ylabel('Magnitude'); grid on;
    xlim([-displayRange displayRange]);

    subplot(3, 2, 6);
    stem(sampledFrequencies, arg(sampledAmplitudes), sampledColor, 'Filled', 'LineWidth', 1.5);
    title('Espectro Amostrado ∠X(f)');
    xlabel('Frequência (Hz)'); ylabel('Magnitude'); grid on;
    xlim([-displayRange displayRange]);
end
