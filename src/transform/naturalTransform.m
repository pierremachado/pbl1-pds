function [amplitudes, frequencies] = ...
    naturalTransform( ...
        frequency, ...
        samplingFrequency, ...
        tau, ...
        kMax
    )

    samplingPeriod = 1/samplingFrequency;

    kSamples = -kMax:kMax;
    frequencies = [];
    amplitudes = [];
    % Amostragem Natural (usando interpolação sinc):
    % X_s(f) = (τ/Ts) * Σ_{k=-∞}^{∞} sinc(kfsτ) * X(f-fs)
    % Esta expressão representa a amostragem natural
    % onde o sinal é amostrado por um trem de pulsos retangulares com
    % duração de τ segundos e período Ts.
    for k = kSamples
        frequencyShift = k * samplingFrequency;
        frequencies = [frequencies, -frequency + frequencyShift, frequency + frequencyShift];
        amplitudeScale = (tau / samplingPeriod) * sinc(k * samplingFrequency * tau);
        amplitudes = [amplitudes, 0.5j * amplitudeScale, -0.5j * amplitudeScale];
    end
end
