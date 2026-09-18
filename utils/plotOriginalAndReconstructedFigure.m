function fig = plotOriginalAndReconstructedFigure( ...
        figName, ...
        time, originalSignal, reconstructedSignal, ...
        freqs, originalAmplitudes, reconstructedAmplitudes, ...
        displayRange ...
    )
    % plotOriginalAndReconstructedFigure - cria uma figura com 6 subplots (3x2)
    % comparando o sinal original (vermelho) e o reconstruído (azul).
    
    fig = figure('Name', figName, 'Position', [100, 100, 1000, 800]);

    % PLOT 1: sinal contínuo original no tempo (vermelho)
    subplot(3, 2, 1);
    plot(time, originalSignal, 'r-', 'LineWidth', 1.5);
    title('Sinal Original x(t)');
    xlabel('Tempo (s)'); ylabel('Amplitude');
    grid on; ylim([-1.5 1.5]);

    % PLOT 2: sinal contínuo reconstruído no tempo (azul)
    subplot(3, 2, 2);
    plot(time, reconstructedSignal, 'b-', 'LineWidth', 1.5);
    title('Sinal Reconstruído x_r(t)');
    xlabel('Tempo (s)'); ylabel('Amplitude');
    grid on; ylim([-1.5 1.5]);

    % PLOT 3: espectro de magnitude original
    subplot(3, 2, 3);
    stem(freqs, abs(originalAmplitudes), 'r', 'Filled', 'LineWidth', 1.5, 'MarkerFaceColor', 'r');
    title('Espectro de Magnitude |X(f)|');
    xlabel('Frequência (Hz)'); ylabel('Magnitude');
    grid on; xlim([-displayRange displayRange]); ylim([0 0.6]);

    % PLOT 4: espectro de magnitude reconstruído
    subplot(3, 2, 4);
    stem(freqs, abs(reconstructedAmplitudes), 'b', 'Filled', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
    title('Espectro de Magnitude |X_r(f)|');
    xlabel('Frequência (Hz)'); ylabel('Magnitude');
    grid on; xlim([-displayRange displayRange]); ylim([0 0.6]);

    % PLOT 5: espectro de fase original
    subplot(3, 2, 5);
    stem(freqs, angle(originalAmplitudes), 'r', 'Filled', 'LineWidth', 1.5, 'MarkerFaceColor', 'r');
    title('Espectro de Fase \angle X(f)');
    xlabel('Frequência (Hz)'); ylabel('Fase (rad)');
    grid on; xlim([-displayRange displayRange]); ylim([-4 4]);

    % PLOT 6: espectro de fase reconstruído
    subplot(3, 2, 6);
    % zera a fase onde a magnitude é praticamente nula pra evitar ruído numérico
    amps_recon_clean = reconstructedAmplitudes;
    amps_recon_clean(abs(reconstructedAmplitudes) < 1e-10) = 0; 
    stem(freqs, angle(amps_recon_clean), 'b', 'Filled', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
    title('Espectro de Fase \angle X_r(f)');
    xlabel('Frequência (Hz)'); ylabel('Fase (rad)');
    grid on; xlim([-displayRange displayRange]); ylim([-4 4]);
end