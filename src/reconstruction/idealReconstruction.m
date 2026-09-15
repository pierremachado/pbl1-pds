function [idealSignal, filteredIdealMagnitudes] = idealReconstruction( ...
    idealFrequencyLocations, ...
    idealMagnitudes, ...
    samplingFrequency, ...
    time)

    Ts = 1 / samplingFrequency;

    % Pulso ideal de amplitude Ts
    pulse = Ts * ...
        (abs(idealFrequencyLocations) <= samplingFrequency / 2);

    % Espectro após o filtro ideal
    filteredIdealMagnitudes = ...
        idealMagnitudes .* pulse;

    % Transformada de Fourier inversa
    idealSignal = zeros(size(time));

    for n = 1:length(time)
        idealSignal(n) = sum( ...
            filteredIdealMagnitudes .* ...
            exp(1j * 2*pi * idealFrequencyLocations * time(n)));
    end

    % Remove resíduos imaginários numéricos
    idealSignal = real(idealSignal);

end
