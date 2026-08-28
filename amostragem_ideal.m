function [xs, ts] = amostragem_ideal(x, Fs, Ti = 0, Tf)

  % parâmetros: x = função, Fs = frequência de amostragem
  % Ti = tempo inicial (default = 0), Tf = tempo final
  % saída: xs = vetor de amostras

  Ts = 1/Fs;

  ts = Ti:Ts:(Tf-Ts);
  xs = x(ts);

end
