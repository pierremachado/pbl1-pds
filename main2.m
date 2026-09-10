% =========================================================================
% Análise Analítica: Amostragem Natural e de Topo-Plano
% =========================================================================
clear; clc; close all;

% Parâmetros base (mesmos da análise anterior)
f0 = 5;                 % Frequência do sinal original (Hz)
w0 = 2*pi*f0;
fs = 37;                % Frequência de amostragem (Hz)
Ts = 1/fs;              % Período de amostragem (s)

% Parâmetro do pulso retangular
tau = 0.2 * Ts;         % Largura do pulso (20% do período de amostragem)

% Vetor de tempo contínuo
t_cont = 0:0.0005:0.5;
x_cont = sin(w0 * t_cont);

figure('Name', 'Amostragem Natural e Topo-Plano', 'Position', [100, 100, 1000, 800]);

% =========================================================================
% PLOT 1: Amostragem Natural no Tempo
% x_n(t) = x(t) * p(t), onde p(t) é um trem de pulsos retangulares
% =========================================================================
% Criando o trem de pulsos p(t) analiticamente
% Consideramos pulsos centralizados em k*Ts
p_t = abs(mod(t_cont + Ts/2, Ts) - Ts/2) <= tau/2;
x_nat = x_cont .* p_t;

subplot(2, 2, 1);
plot(t_cont, x_nat, 'b-', 'LineWidth', 1.5);
title('1. Amostragem Natural no Tempo');
xlabel('Tempo (s)');
ylabel('Amplitude');
grid on;
ylim([-1.2 1.2]);

% =========================================================================
% PLOT 2: Amostragem de Topo-Plano no Tempo
% x_ft(t) = sum( x(kTs) * rect((t-kTs)/tau) )
% =========================================================================
x_ft = zeros(size(t_cont));
k_max = floor(max(t_cont)/Ts);

for k = 0:k_max
    tk = k * Ts;
    % Pulso retangular deslocado para t = kTs
    rect_k = abs(t_cont - tk) <= tau/2;
    % Modulação da amplitude pelo valor do sinal no instante kTs
    x_ft = x_ft + sin(w0 * tk) .* rect_k;
end

subplot(2, 2, 2);
plot(t_cont, x_ft, 'r-', 'LineWidth', 1.5);
title('2. Amostragem de Topo-Plano no Tempo');
xlabel('Tempo (s)');
ylabel('Amplitude');
grid on;
ylim([-1.2 1.2]);

% =========================================================================
% PLOT 3: Espectro da Amostragem Natural
% O envelope das réplicas depende da harmônica k da freq. de amostragem
% =========================================================================
k_vec = -3:3; 
f_nat_locs = [];
mag_nat = [];

for idx = 1:length(k_vec)
    k = k_vec(idx);
    f_shift = k * fs;
    
    % As componentes ficam em +/- f0 + k*fs
    f_nat_locs = [f_nat_locs, -f0 + f_shift, f0 + f_shift];
    
    % Fator de escala da amostragem natural (coeficientes de Fourier de p(t))
    % sinc(k * fs * tau) no MATLAB já implementa sin(pi*k*fs*tau)/(pi*k*fs*tau)
    amp_k = (tau / Ts) * sinc(k * fs * tau);
    
    % Magnitude base (0.5) multiplicada pelo fator de escala da componente k
    mag_nat = [mag_nat, abs(0.5 * amp_k), abs(0.5 * amp_k)];
end

subplot(2, 2, 3);
stem(f_nat_locs, mag_nat, 'b', 'Marker', '^', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
title('3. Espectro Amost. Natural |X_n(j\omega)|');
xlabel('Frequência (Hz)');
ylabel('Magnitude');
grid on;
xlim([-60 60]);
line([-60 60], [0 0], 'Color', 'k');

% =========================================================================
% PLOT 4: Espectro da Amostragem de Topo-Plano
% O envelope das réplicas depende da frequência ABSOLUTA do componente (f)
% =========================================================================
f_ft_locs = [];
mag_ft = [];

% Calculando as posições das componentes
for idx = 1:length(k_vec)
    k = k_vec(idx);
    f_shift = k * fs;
    f_ft_locs = [f_ft_locs, -f0 + f_shift, f0 + f_shift];
end

% A magnitude na amostragem topo-plano é atenuada continuamente por sinc(f*tau)
% avaliado diretamente na frequência onde o impulso se encontra.
for i = 1:length(f_ft_locs)
    f_val = f_ft_locs(i);
    % Espectro = (1/Ts) * X(jw) * H(jw), com H(jw) = tau * sinc(f * tau)
    % Usamos 0.5 da magnitude de base de X(jw)
    amp_f = (tau / Ts) * sinc(f_val * tau);
    mag_ft = [mag_ft, abs(0.5 * amp_f)];
end

subplot(2, 2, 4);
stem(f_ft_locs, mag_ft, 'r', 'Marker', '^', 'LineWidth', 1.5, 'MarkerFaceColor', 'r');
hold on;
% Desenhando o envelope sinc contínuo (Efeito de Abertura / Aperture Effect)
f_env = -60:0.1:60;
env_ft = abs(0.5 * (tau / Ts) * sinc(f_env * tau));
plot(f_env, env_ft, 'k--', 'LineWidth', 1);
hold off;

title('4. Espectro Amost. Topo-Plano |X_{ft}(j\omega)|');
xlabel('Frequência (Hz)');
ylabel('Magnitude');
legend('Impulsos', 'Envelope sinc (Efeito de Abertura)');
grid on;
xlim([-60 60]);
line([-60 60], [0 0], 'Color', 'k');

sgtitle('Amostragem Natural vs Topo-Plano (Domínios do Tempo e Frequência)');