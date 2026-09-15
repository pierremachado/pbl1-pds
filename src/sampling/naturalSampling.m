function [sampledSignal, sampledTime] = naturalSampling(x, samplingFrequency, tau, startTime = 0, endTime)
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
  % sampledSignal: vector of sampled values
  % sampledTime: vector of sample times

  % Checagem de erro
  if isempty(x) || ~isa(x, 'function_handle')
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
  sampledTime = startTime:dt:endTime;

  % Generate the time vector for sampling points
  samplingTime = startTime:samplingPeriod:endTime;

  % Initialize the output vector with zeros
  y = zeros(size(sampledTime));

  % Sample the input signal
  for k = 1:length(samplingTime)
    idx = (sampledTime >= samplingTime(k) - tau/2) & (sampledTime < samplingTime(k) + tau/2);
    y(idx) = 1;
  end

  % Multiply the input signal by the sampling points
  sampledSignal = x(sampledTime).*y;
end
