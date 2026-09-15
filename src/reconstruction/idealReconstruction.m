function [signal, filteredAmplitudes] = ...
    idealReconstruction( ...
        frequencies, ...
        amplitudes, ...
        samplingFrequency, ...
        time
    )

    samplingPeriod = 1 / samplingFrequency;

    % Pulso ideal de amplitude samplingPeriod
    pulse = samplingPeriod * ...
        (abs(frequencies) <= samplingFrequency / 2);

    % Espectro após o filtro ideal
    filteredAmplitudes = ...
        amplitudes .* pulse;

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
