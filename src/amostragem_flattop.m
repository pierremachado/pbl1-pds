function [xs, ts] = amostragem_flattop(x, Fs, w, Ti = 0, Tf)
  % parâmetros: x = função (handle, ex: @sin)
  % Fs = frequência de amostragem
  % w = duração (largura) do pulso, w <= Ts
  % Ti = tempo inicial (default = 0), Tf = tempo final
  % saída: xs = vetor do sinal amostrado, ts = vetor de tempo contínuo

  Ts = 1/Fs;
  dt = Ts/1000;
  ts = Ti:dt:Tf;

  t_samp = Ti:Ts:Tf;
  amplitudes = x(t_samp);

  xs = zeros(size(ts));

  for k = 1:length(t_samp)
    % pulso causal: começa em t_samp(k), dura w segundos
    idx = (ts >= t_samp(k)) & (ts < t_samp(k) + w);
    xs(idx) = amplitudes(k);
  end
end