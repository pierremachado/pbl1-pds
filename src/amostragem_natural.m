function [xs, ts] = amostragem_natural(x, Fs, w, Ti = 0, Tf)
  % parâmetros: x = função, Fs = frequência de amostragem
  % w = duração do pulso
  % Ti = tempo inicial (default = 0), Tf = tempo final
  % saída: xs = vetor de amostras

  Ts = 1/Fs;
  dt = Ts/1000;
  ts = Ti:dt:Tf;

  t_samp = Ti:Ts:Tf;

  y = zeros(size(ts));
  for k = 1:length(t_samp)
    idx = (ts >= t_samp(k)) & (ts < t_samp(k) + w);
    y(idx) = 1;
  end

  xs = x(ts).*y;
end