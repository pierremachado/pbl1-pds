function [amplitudes, frequencies] = ...
    idealTransform( ...
        frequency, ...
        samplingFrequency, ...
        kMax
    )

    kSamples = -kMax:kMax;
    frequencies = [];
    amplitudes = [];

    % Xs(f) = (1/Ts) * Σ_{k=-∞}^{∞} X(f - kfs)
    % Esta expressão representa a transformada de Fourier da amostragem ideal de um sinal.
    % É a soma de infinitas translações da transformada de Fourier original X(jω)
    % espaçadas pela frequência de amostragem ωs, escaladas por 1/Ts.
    for k = kSamples
        frequencyShift = k * samplingFrequency;
        frequencies = [frequencies, -frequency + frequencyShift, frequency + frequencyShift];
        amplitudes = [amplitudes, 0.5j * samplingFrequency, -0.5j * samplingFrequency];
    end
end
