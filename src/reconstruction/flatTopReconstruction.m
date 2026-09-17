function [signal, filteredAmplitudes] = ...
    flatTopReconstruction( ...
        frequencies, ...
        amplitudes, ...
        samplingFrequency, ...
        tau, ...
        time
    )

    samplingPeriod = 1 / samplingFrequency;

    % Filtro Equalizador (Compensa a magnitude do sinc e o atraso de tau/2)
    % Note o uso imperativo de './' para a divisão termo a termo
    equalizer = (samplingPeriod / tau) ./ sinc(frequencies * tau) .* exp(1j * pi * frequencies * tau);

    % O pulso passa-baixa ideal deve ter amplitude 1 (normalizado)
    pulse = 1 * (abs(frequencies) <= samplingFrequency / 2);

    % Espectro após o filtro ideal e a equalização
    filteredAmplitudes = amplitudes .* pulse .* equalizer;

    % Transformada de Fourier inversa clássica
    signal = zeros(size(time));

    for n = 1:length(time)
        signal(n) = sum( ...
            filteredAmplitudes .* ...
            exp(1j * 2*pi * frequencies * time(n)));
    end

    signal = real(signal);
end
