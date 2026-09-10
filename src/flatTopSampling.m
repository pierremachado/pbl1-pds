function [xs, ts] = flatTopSampling(x, samplingFrequency, tau, startTime = 0, endTime)
  % parâmetros: x = função (handle, ex: @sin)
  % samplingFrequency = frequência de amostragem
  % tau = duração (largura) do pulso, tau <= timeStep
  % startTime = tempo inicial (default = 0), endTime = tempo final
  % saída: xs = vetor do sinal amostrado, ts = vetor de tempo contínuo

  timeStep = 1/samplingFrequency;
  dt = timeStep/1000;
  ts = startTime:dt:endTime;

  t_samp = startTime:timeStep:endTime;
  amplitudes = x(t_samp);

  xs = zeros(size(ts));

  for k = 1:length(t_samp)
    % pulso causal: começa em t_samp(k), dura tau segundos
    idx = (ts >= t_samp(k)) & (ts < t_samp(k) + tau);
    xs(idx) = amplitudes(k);
  end
end