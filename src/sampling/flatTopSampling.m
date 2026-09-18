function [sampledSignal, sampledTime] = ...
  flatTopSampling(x, ...
    samplingFrequency, ...
    tau, ...
    startTime = 0, ...
    endTime, ...
    numPoints
  )
  % parâmetros: x = função (handle, ex: @sin)
  % samplingFrequency = frequência de amostragem
  % tau = duração (largura) do pulso, tau <= samplingPeriod
  % startTime = tempo inicial (default = 0), endTime = tempo final
  % saída: sampledSignal = vetor do sinal amostrado, sampledTime = vetor de tempo contínuo

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
  
  sampledTime = linspace(startTime, endTime, numPoints);

  samplingTime = startTime:samplingPeriod:endTime;
  amplitudes = x(samplingTime);

  sampledSignal = zeros(size(sampledTime));

  for k = 1:length(samplingTime)
    idx = (sampledTime >= samplingTime(k)) & (sampledTime < samplingTime(k) + tau);
    sampledSignal(idx) = amplitudes(k);
  end
end
