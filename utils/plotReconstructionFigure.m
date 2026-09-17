function fig = plotReconstructionFigure( ...
        figName, ...
        continuousTime, continuousSignal, ...
        reconstructedSignal, ...
        frequencies, filteredAmplitudes, ...
        displayRange, ...
        startTime, endTime, ...
        color, ...
        magYLim, ...
        showAliasingOverlay, ...
        zoomEndTime ...
    )
    % plotReconstructionFigure - Gera figura com sinal reconstruído no tempo
    % (com overlay tracejado do sinal original quando showAliasingOverlay=true)
    % e o espectro após o filtro de reconstrução.
    %
    % zoomEndTime: quando showAliasingOverlay=true, limita o eixo x a
    % [startTime, zoomEndTime] para que os ciclos de alta frequência do
    % sinal original permaneçam visualmente distinguíveis. Ignorado
    % quando showAliasingOverlay=false (default: [] usa [startTime endTime]).

    fig = figure('Name', figName, 'Position', [200, 100, 1000, 700]);

    % Sinal reconstruído
    subplot(2, 1, 1);
    plot(continuousTime, reconstructedSignal, [color '-'], 'LineWidth', 1.8);
    hold on;
    if showAliasingOverlay
        plot(continuousTime, continuousSignal, '--', 'Color', [0.55 0.55 0.55], 'LineWidth', 0.9);
        legend('Sinal Reconstruído', 'Sinal Original (referência)', 'Location', 'northeast');
    end
    hold off;

    if showAliasingOverlay
        title('Sinal Reconstruído vs Original (Aliasing)');
    else
        title('Sinal Reconstruído no Domínio do Tempo');
    end
    xlabel('Tempo (s)'); ylabel('Amplitude');
    grid on;
    if showAliasingOverlay && ~isempty(zoomEndTime)
        xlim([startTime zoomEndTime]);
    else
        xlim([startTime endTime]);
    end
    ylim([-1.2 1.2]);

    % Espectro filtrado
    subplot(2, 1, 2);
    stem(frequencies, abs(filteredAmplitudes), color, 'Filled', 'LineWidth', 1.5, 'MarkerFaceColor', color);
    title('Espectro Após o Filtro de Reconstrução');
    xlabel('Frequência (Hz)'); ylabel('Magnitude');
    grid on; xlim([-displayRange displayRange]);
    if ~isempty(magYLim)
        ylim(magYLim);
    end
end
