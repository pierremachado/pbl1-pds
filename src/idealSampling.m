function [idealX, idealTime] = idealSampling(x, samplingFrequency, startTime = 0, endTime = 1)
  % idealSampling - Função para amostragem ideal de um sinal
  % 
  % Parâmetros:
  % x: Função que representa o sinal a ser amostrado
  % samplingFrequency: Frequência de amostragem (Hz)
  % startTime: Tempo inicial do intervalo de amostragem (opcional, default = 0)
  % endTime: Tempo final do intervalo de amostragem (opcional)
  % 
  % Saída:
  % idealX: Vetor de amostras do sinal
  % idealTime: Vetor de tempos correspondentes às amostras

  % Checagem de erro
  if isempty(x) || strcmp(typeinfo(x), "anonymous function")
    error('x must be a valid function handle');
  end

  if startTime >= endTime
      error('startTime must < than endTime');
  end

  samplingPeriod = 1/samplingFrequency;  % Cálculo do período de amostragem

  idealTime = startTime:samplingPeriod:(endTime-samplingPeriod);  % Geração do vetor de tempos de amostragem
  idealX = x(idealTime);  % Cálculo do vetor de amostras correspondentes
end