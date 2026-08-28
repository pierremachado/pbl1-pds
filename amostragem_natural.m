function [xs, ts] = amostragem_natural(x, Fs, w, Ti = 0, Tf)
  % parâmetros: x = função, Fs = frequência de amostragem
  % w = duração do pulso
  % Ti = tempo inicial (default = 0), Tf = Tempo final
  % saída: xs = vetor de amostras
  Ts = 1/Fs; % período de amostragem
  ts = Ti:0.0001:Tf;
  y = pulstran (ts, Ti:Ts:Tf, "rectpuls", w)

  xs = x(ts).*y;
end
