function [xs, ts] = amostragem_flattop(x, Fs, w, Ti = 0, Tf)
  % parâmetros: x = função (handle, ex: @sin)
  % Fs = frequência de amostragem
  % w = duração (largura) do pulso
  % Ti = tempo inicial (default = 0), Tf = tempo final
  % saída: xs = vetor do sinal amostrado, ts = vetor de tempo contínuo

  Ts = 1/Fs;         % período de amostragem
  ts = Ti:Ts/1000:Tf; % eixo de tempo de alta resolução (contínuo)

  % 1. Definimos os instantes exatos de amostragem
  t_samp = Ti:Ts:Tf;

  % 2. Pegamos os valores ideais (amplitudes) da função nesses instantes
  amplitudes = x(t_samp);

  % 3. Criamos a matriz de atrasos e amplitudes para o pulstran
  % Transpomos (:) para garantir que sejam colunas
  D = [t_samp(:), amplitudes(:)];

  % 4. Geramos os pulsos retangulares, onde cada pulso terá a altura
  % constante definida pela matriz D (amostragem topo-plano)
  xs = pulstran(ts, D, "rectpuls", w);
end
