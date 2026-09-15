function [signal, filteredAmplitudes] = ...
    naturalReconstruction( ...
        frequencies, ...
        amplitudes, ...
        samplingFrequency, ...
        tau, ...
        time
    )

    samplingPeriod = 1 / samplingFrequency;

    % Ponderação da réplica central (k = 0)
    weighting = (tau / samplingPeriod) * sinc(0);

    % Pulso ideal de amplitude samplingPeriod
    pulse = samplingPeriod * ...
        (abs(frequencies) <= samplingFrequency / 2);

    % Espectro após o filtro ideal
    filteredAmplitudes = ...
        amplitudes .* pulse * weighting;

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
