function [naturalX, naturalTime] = naturalSampling(x, samplingFrequency, tau, startTime = 0, endTime)
  % Natural sampling function
  %
  % Parameters:
  % x: input signal (function)
  % samplingFrequency: sampling frequency (Hz)
  % tau: pulse duration (seconds)
  % startTime: start time of sampling (default = 0 seconds)
  % endTime: end time of sampling (seconds)
  %
  % Returns:
  % naturalX: vector of sampled values
  % naturalTime: vector of sample times

  % Checagem de erro
  if isempty(x) || strcmp(typeinfo(x), "anonymous function")
    error('x must be a valid function handle');
  end
  
  if tau <= 0
      error('tau must be positive');
  end

  if startTime >= endTime
      error('startTime must < than endTime');
  end

  samplingPeriod = 1/samplingFrequency;

  if tau > samplingPeriod
      error('tau must be <= samplingPeriod');
  end

  dt = samplingPeriod/1000;

  % Generate the time vector for sampling
  naturalTime = startTime:dt:endTime;

  % Generate the time vector for sampling points
  samplingTime = startTime:samplingPeriod:endTime;

  % Initialize the output vector with zeros
  y = zeros(size(naturalTime));

  % Sample the input signal
  for k = 1:length(samplingTime)
    idx = (naturalTime >= samplingTime(k) - tau/2) & (naturalTime < samplingTime(k) + tau/2);
    y(idx) = 1;
  end

  % Multiply the input signal by the sampling points
  naturalX = x(naturalTime).*y;
end