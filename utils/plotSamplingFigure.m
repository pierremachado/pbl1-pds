function fig = plotSamplingFigure( ...
        figName, ...
        continuousTime, continuousSignal, ...
        sampledTime, sampledSignal, ...
        continuousFrequencies, continuousAmplitudes, ...
        sampledFrequencies, sampledAmplitudes, ...
        displayRange, ...
        sampledLabel, sampledColor, sampledStyle, ...
        magYLim, ...
        envelopeFreq, envelopeVals ...
    )
    % plotSamplingFigure - Gera uma figura padrão com 4 subplots comparando
    % o sinal contínuo com uma versão amostrada (tempo e espectro).
    %
    % sampledStyle: 'stem' (ideal) ou 'plot' (natural/topo-plano)
    % envelopeFreq/envelopeVals: opcionais, para desenhar o envelope sinc
    % (passar [] quando não aplicável)

    fig = figure('Name', figName, 'Position', [100, 100, 1000, 800]);

    % PLOT 1: Sinal contínuo no tempo
    subplot(3, 2, 1);
    plot(continuousTime, continuousSignal, 'b-', 'LineWidth', 1.5);
    title('Sinal Contínuo x(t)');
    xlabel('Tempo (s)'); ylabel('Amplitude');
    grid on; ylim([-1.2 1.2]);

    % PLOT 2: Sinal amostrado no tempo
    subplot(3, 2, 2);
    if strcmp(sampledStyle, 'stem')
        stem(sampledTime, sampledSignal, sampledColor, 'Filled', 'LineWidth', 1.5, 'MarkerFaceColor', sampledColor);
    else
        plot(sampledTime, sampledSignal, [sampledColor '-'], 'LineWidth', 1.5);
    end
    title(sampledLabel);
    xlabel('Tempo (s)'); ylabel('Amplitude');
    grid on; ylim([-1.2 1.2]);

    % PLOT 3: Espectro contínuo
    subplot(3, 2, 3);
    stem(continuousFrequencies, abs(continuousAmplitudes), 'b', 'Filled', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
    title('Espectro Contínuo |X(f)|');
    xlabel('Frequência (Hz)'); ylabel('Magnitude');
    grid on; xlim([-displayRange displayRange]);

    % PLOT 4: Espectro amostrado
    subplot(3, 2, 4);
    stem(sampledFrequencies, abs(sampledAmplitudes), sampledColor, 'Filled', 'LineWidth', 1.5, 'MarkerFaceColor', sampledColor);
    if ~isempty(envelopeFreq)
        hold on;
        plot(envelopeFreq, envelopeVals, 'k--', 'LineWidth', 1);
        legend('Impulsos', 'Envelope sinc (Abertura)', 'Location', 'northeast');
        hold off;
    end
    title(['Espectro Amostrado |X_s(f)|']);
    xlabel('Frequência (Hz)'); ylabel('Magnitude');
    grid on; xlim([-displayRange displayRange]);
    if ~isempty(magYLim)
        ylim(magYLim);
    end

    % PLOT 5: Espectro contínuo
    subplot(3, 2, 5);
    stem(continuousFrequencies, angle(continuousAmplitudes), 'b', 'Filled', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
    title('Espectro Contínuo ∠X(f)');
    xlabel('Frequência (Hz)'); ylabel('Magnitude');
    grid on; xlim([-displayRange displayRange]); ylim([-4 4]);

    % PLOT 6: Espectro amostrado
    subplot(3, 2, 6);
    stem(sampledFrequencies, angle(sampledAmplitudes), sampledColor, 'Filled', 'LineWidth', 1.5, 'MarkerFaceColor', sampledColor);
    title(['Espectro Amostrado ∠X_s(f)']);
    xlabel('Frequência (Hz)'); ylabel('Fase');
    grid on; xlim([-displayRange displayRange]); ylim([-4 4]);
end
