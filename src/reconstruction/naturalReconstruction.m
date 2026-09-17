function [signal, filteredAmplitudes] = ...
    naturalReconstruction( ...
        frequencies, ...
        amplitudes, ...
        samplingFrequency, ...
        tau, ...
        time
    )

    samplingPeriod = 1 / samplingFrequency;

    % O peso deve ser o inverso do ciclo de trabalho para compensar a atenuação
    weighting = samplingPeriod / tau; 

    % O pulso passa-baixa ideal deve ter amplitude 1 (normalizado)
    pulse = 1 * (abs(frequencies) <= samplingFrequency / 2);

    % Espectro após o filtro ideal
    filteredAmplitudes = amplitudes .* pulse * weighting;

    % Transformada de Fourier inversa
    signal = zeros(size(time));

    for n = 1:length(time)
        signal(n) = sum( ...
            filteredAmplitudes .* ...
            exp(1j * 2*pi * frequencies * time(n)));
    end

    % Remove resíduos imaginários numéricos
    signal = real(signal);
end
