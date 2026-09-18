function [signal, filteredAmplitudes] = ...
    continuousReconstruction( ...
        frequencies, ...
        amplitudes, ...
        cutoffFrequency,
        time
    )

    % O pulso passa-baixa ideal deve ter amplitude 1 (normalizado)
    pulse = 1 * (abs(frequencies) <= cutoffFrequency);

    % Espectro após o filtro ideal e a equalização
    filteredAmplitudes = amplitudes .* pulse

    % Transformada de Fourier inversa clássica
    signal = zeros(size(time));

    for n = 1:length(time)
        signal(n) = sum( ...
            filteredAmplitudes .* ...
            exp(1j * 2*pi * frequencies * time(n)));
    end

    signal = real(signal);
end
