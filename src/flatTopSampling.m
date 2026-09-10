function [flatTopX, flatTopTime] = flatTopSampling(x, samplingFrequency, tau, startTime = 0, endTime)
  % parâmetros: x = função (handle, ex: @sin)
  % samplingFrequency = frequência de amostragem
  % tau = duração (largura) do pulso, tau <= timeStep
  % startTime = tempo inicial (default = 0), endTime = tempo final
  % saída: flatTopX = vetor do sinal amostrado, flatTopTime = vetor de tempo contínuo

  timeStep = 1/samplingFrequency;
  dt = timeStep/1000;
  flatTopTime = startTime:dt:endTime;

  samplingTime = startTime:timeStep:endTime;
  amplitudes = x(samplingTime);

  flatTopX = zeros(size(flatTopTime));

  for k = 1:length(samplingTime)
    idx = (flatTopTime >= samplingTime(k) - tau/2) & (flatTopTime < samplingTime(k) + tau/2);
    flatTopX(idx) = amplitudes(k);
  end
end