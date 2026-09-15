function [flatTopX, flatTopTime] = flatTopSampling(x, samplingFrequency, tau, startTime = 0, endTime = 1)
  % parâmetros: x = função (handle, ex: @sin)
  % samplingFrequency = frequência de amostragem
  % tau = duração (largura) do pulso, tau <= samplingPeriod
  % startTime = tempo inicial (default = 0), endTime = tempo final
  % saída: flatTopX = vetor do sinal amostrado, flatTopTime = vetor de tempo contínuo

  % Checagem de erro
  if isempty(x) || ~isa(x, 'function_handle')
    error('x must be a valid function handle');
  end
  
  if tau <= 0
      error('tau must be positive');
  end

  if startTime >= endTime
      error('startTime must < than endTime');
  end

  samplingPeriod = 1/samplingFrequency;

  if tau > samplingPeriod
      error('tau must be <= samplingPeriod');
  end

  dt = samplingPeriod/1000;
  flatTopTime = startTime:dt:endTime;

  samplingTime = startTime:samplingPeriod:endTime;
  amplitudes = x(samplingTime);

  flatTopX = zeros(size(flatTopTime));

  for k = 1:length(samplingTime)
    idx = (flatTopTime >= samplingTime(k) - tau/2) & (flatTopTime < samplingTime(k) + tau/2);
    flatTopX(idx) = amplitudes(k);
  end
end