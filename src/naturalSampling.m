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

  % Calculate the sampling period and time resolution
  samplingPeriod = 1/samplingFrequency;
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