function [xc, tc] = discreteToImpulses(xIdealSampling, samplingTime, startTime, endTime, timeStep)
    % discreteToImpulses Converte um par discreto num trem de impulsos
    % em alta resolução temporal. Útil para aplicar FFT ou facilitar a plotagem.
    %
    % Parâmetros:
    %   xIdealSampling     - Vetor de amostras no tempo discreto
    %   samplingTime - Vetor de tempo discreto original (ex: kT_s)
    %   startTime     - Tempo inicial do sinal contínuo
    %   endTime     - Tempo final do sinal contínuo
    %   timeStep     - Passo de tempo de alta resolução (frequência de amostragem virtual)
    %
    % Retornos:
    %   xc     - Vetor correspondente ao trem de impulsos
    %   tc     - Eixo de tempo contínuo equivalente
    
    % Cria o eixo de tempo de alta resolução
    tc = startTime:timeStep:endTime;
    xc = zeros(size(tc));
    
    % Aloca cada amostra discreta no índice temporal contínuo mais próximo
    for k = 1:length(samplingTime)
        [~, idx] = min(abs(tc - samplingTime(k)));
        xc(idx) = xIdealSampling(k);
    end
end