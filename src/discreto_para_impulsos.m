function [xc, tc] = discreto_para_impulsos(xs, t_samp, Ti, Tf, dt)
  % converte um par discreto (xs, t_samp) num trem de impulsos
  % em alta resolução temporal, útil para FFT/plot
  tc = Ti:dt:Tf;
  xc = zeros(size(tc));

  for k = 1:length(t_samp)
    [~, idx] = min(abs(tc - t_samp(k)));
    xc(idx) = xs(k);
  end
end