function DerivativeResample(n,h)
% Re-draws graph when Resample slider is changed
% Tom O'Haver, July 2006
global t
global signal
global Scale
global Order
global SmoothWidth
global Exponent
global amp
global pos
global wid
global Noise
global amp
global pos
global wid
global Noise
global NoiseArray
global Background
global BackgroundPosition
NoiseArray=randn(size(t));  % Create noise
RedrawDerivative