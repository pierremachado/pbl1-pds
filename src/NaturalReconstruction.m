function [naturalSignal, filteredNaturalMagnitudes] = NaturalReconstruction( ...
    naturalFrequencyLocations, ...
    naturalMagnitudes, ...
    samplingFrequency, ...
    tau, ...
    time)

    Ts = 1 / samplingFrequency;

    % Ponderação da réplica central (k = 0)
    weighting = (tau / Ts) * sinc(0);

    % Pulso ideal de amplitude Ts
    pulse = Ts * ...
        (abs(naturalFrequencyLocations) <= samplingFrequency / 2);

    % Espectro após o filtro ideal
    filteredNaturalMagnitudes = ...
        naturalMagnitudes .* pulse * weighting;

    % Transformada de Fourier inversa
    naturalSignal = zeros(size(time));

    for n = 1:length(time)
        naturalSignal(n) = sum( ...
            filteredNaturalMagnitudes .* ...
            exp(1j * 2*pi * naturalFrequencyLocations * time(n)));
    end

    % Remove resíduos imaginários numéricos
    naturalSignal = real(naturalSignal);

end
