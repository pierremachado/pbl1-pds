function plotReconstructionFrame( ...
        continuousTime, continuousSignal, ...
        reconstructedSignal, ...
        frequencies, filteredAmplitudes, ...
        displayRange, ...
        titleContinuous, titleReconstructed, ...
        color, ...
        magYLim ...
    )
    % plotReconstructionFrame - Desenha um frame de 4 subplots (2x2)
    % comparando o sinal contínuo original com o sinal reconstruído,
    % em tempo e frequência. Assume que a figura de destino já está
    % ativa e foi limpa (clf).

    subplot(2, 2, 1);
    plot(continuousTime, continuousSignal, 'b-', 'LineWidth', 1.5);
    title(titleContinuous);
    xlabel('Tempo (s)'); ylabel('Amplitude'); grid on; ylim([-1.2 1.2]);

    subplot(2, 2, 2);
    plot(continuousTime, reconstructedSignal, [color '-'], 'LineWidth', 1.5);
    title(titleReconstructed);
    xlabel('Tempo (s)'); ylabel('Amplitude'); grid on; ylim([-1.2 1.2]);

    subplot(2, 2, 3);
    plot(continuousTime, continuousSignal, 'k--', 'LineWidth', 1);
    hold on;
    plot(continuousTime, reconstructedSignal, [color '-'], 'LineWidth', 1.2);
    hold off;
    title('Sobreposição: Original vs Reconstruído');
    xlabel('Tempo (s)'); ylabel('Amplitude'); grid on; ylim([-1.2 1.2]);
    legend('Original', 'Reconstruído', 'Location', 'northeast');

    subplot(2, 2, 4);
    stem(frequencies, abs(filteredAmplitudes), color, 'Marker', '^', 'LineWidth', 1.5, 'MarkerFaceColor', color);
    title('Espectro Após o Filtro');
    xlabel('Frequência (Hz)'); ylabel('Magnitude'); grid on;
    xlim([-displayRange displayRange]);
    if ~isempty(magYLim)
        ylim(magYLim);
    end
end
