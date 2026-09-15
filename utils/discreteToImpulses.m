function [x, time] = discreteToImpulses(discreteX, discreteTime, startTime, endTime, timeStep)
    % discreteToImpulses Converte um par discreto num trem de impulsos
    % em alta resolução temporal. Útil para aplicar FFT ou facilitar a plotagem.
    %
    % Parâmetros:
    %   discreteX     - Vetor de amostras no tempo discreto
    %   discreteTime - Vetor de tempo discreto original (ex: kT_s)
    %   startTime     - Tempo inicial do sinal contínuo
    %   endTime     - Tempo final do sinal contínuo
    %   timeStep     - Passo de tempo de alta resolução (frequência de amostragem virtual)
    %
    % Retornos:
    %   x - Vetor correspondente ao trem de impulsos
    %   time - Eixo de tempo contínuo equivalente

    % Checagem de erros
    if ~isvector(discreteX) || ~isvector(discreteTime)
        error('Input must be vectors');
    end
    
    if length(discreteX) ~= length(discreteTime)
        error('discreteX and discreteTime must have same length');
    end
    
    if timeStep <= 0
        error('timeStep must be positive');
    end

    if endTime <= startTime
        error('startTime must be lesser than endTime');
    end

    % Cria o eixo de tempo de alta resolução
    time = startTime:timeStep:endTime;
    x = zeros(size(time));
    
    % Aloca cada amostra discreta no índice temporal contínuo mais próximo
    for k = 1:length(discreteTime)
        [~, idx] = min(abs(time - discreteTime(k)));
        x(idx) = discreteX(k);
    end
end
