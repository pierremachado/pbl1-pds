function [xs, ts] = naturalSampling(x, Fs, w, Ti = 0, Tf)
  % Natural sampling function
  %
  % Parameters:
  % x: input signal (function)
  % Fs: sampling frequency (Hz)
  % w: pulse duration (seconds)
  % Ti: start time of sampling (default = 0 seconds)
  % Tf: end time of sampling (seconds)
  %
  % Returns:
  % xs: vector of sampled values
  % ts: vector of sample times

  % Calculate the sampling period and time resolution
  Ts = 1/Fs;
  dt = Ts/1000;

  % Generate the time vector for sampling
  ts = Ti:dt:Tf;

  % Generate the time vector for sampling points
  t_samp = Ti:Ts:Tf;

  % Initialize the output vector with zeros
  y = zeros(size(ts));

  % Sample the input signal
  for k = 1:length(t_samp)
    idx = (ts >= t_samp(k)) & (ts < t_samp(k) + w);
    y(idx) = 1;
  end

  % Multiply the input signal by the sampling points
  xs = x(ts).*y;
end