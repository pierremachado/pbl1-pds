function [xs, ts] = idealSampling(x, Fs, Ti = 0, Tf)
  % idealSampling - Função para amostragem ideal de um sinal
  % 
  % Parâmetros:
  % x: Função que representa o sinal a ser amostrado
  % Fs: Frequência de amostragem (Hz)
  % Ti: Tempo inicial do intervalo de amostragem (opcional, default = 0)
  % Tf: Tempo final do intervalo de amostragem (opcional)
  % 
  % Saída:
  % xs: Vetor de amostras do sinal
  % ts: Vetor de tempos correspondentes às amostras

  Ts = 1/Fs;  % Cálculo do período de amostragem

  ts = Ti:Ts:(Tf-Ts);  % Geração do vetor de tempos de amostragem
  xs = x(ts);  % Cálculo do vetor de amostras correspondentes
end