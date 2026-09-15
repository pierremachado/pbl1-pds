function [amplitudes, frequencies] = dataTransform(sampledSignal, sampledTime, displayRange, numPoints)
    frequencies = linspace(-displayRange, displayRange, numPoints);
    N = length(sampledSignal);
    
    % 1. Garantimos as orientações dos vetores para a matemática de matrizes
    sampledSignal = sampledSignal(:).'; % Garante vetor-linha (1 x N)
    sampledTime = sampledTime(:);       % Garante vetor-coluna (N x 1)
    frequencies = frequencies(:).';     % Garante vetor-linha (1 x M)
    
    % 2. O truque da vetorização!
    % Ao multiplicar (Nx1) por (1xM), geramos uma matriz gigante (NxM)
    % contendo todos os ângulos possíveis de uma só vez, processados em C/C++ por baixo dos panos.
    faseMatriz = exp(-1j * 2 * pi * sampledTime * frequencies);
    
    % 3. Multiplicamos o sinal pela matriz. 
    % A álgebra linear (1xN) * (NxM) automaticamente faz o papel do 'sum()' 
    % e nos devolve um vetor-linha (1xM) com as amplitudes prontas.
    amplitudes = (sampledSignal * faseMatriz) / N;
end