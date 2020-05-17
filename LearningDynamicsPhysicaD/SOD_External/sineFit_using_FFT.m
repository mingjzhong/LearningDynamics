function SineParams = sineFit_using_FFT(x, y, ZP_type)
% Purpose: Estimation of noisy sine curve parameters by FFT and non linear fitting.
%
% Syntax:
%       [SineParams]=sineFit(x,y)
%       Input: x and y values, y=offs+amp+sin(2*pi*f*x+phi)+noise
%       Output: SineParams(1): offset (offs)
%               SineParams(2): amplitude (amp)
%               SineParams(3): frequency (f)
%               SineParams(4): phaseshift (phi)
%       yOut = offs + amp * sin(2 * pi * f * x + phi)

% Author: Peter Seibold; modified by Ming Zhong

%% FFT
pi2                  = 2 * pi;
NumSamples           = length(x);
T                    = x(2) - x(1);
fNy                  = 1/(2 * T);                    % Nyquist frequency
offs                 = mean(y);                      % DC value
y_m                  = y - offs;                     % FFT much better without offset
switch ZP_type
  case 'none'
    n                = NumSamples;                   % no zero padding
  case 'some padding'
    n                = 2   * NumSamples;
  case 'more padding'
    n                = 2   * 2^nextpow2(NumSamples);
  case 'heavy padding'
    n                = 128 * 2^nextpow2(NumSamples); % heavy zero padding
  otherwise
    error('');
end
Y                    = fft(y_m, n);                  % Y(f)
n2                   = floor(n/2);
P2                   = abs(Y/NumSamples);
P1                   = P2(1: n2 + 1);
P1(2: end - 1)       = 2 * P1(2 : end - 1);
fs                   = (0: n2)/n/T;                  % frequency scale
% %FFT parameters at peak
[maxFFT, maxFFTindx] = max(P1);                      % Peak magnitude and location
fPeak                = fs(maxFFTindx);               % f at peak
 % Phi-Peak is for cos, sin(90° + alpha) = cos(betta), alpha = -betta
Phip                 = angle(Y(maxFFTindx)) + pi/2;
Phip                 = Phip - x(1) * fPeak * pi2;    % shift for phi at x=0
%Better estimate for offset:
omega                = pi2 * fPeak;
offs                 = offs - maxFFT * (cos(omega * x(1) + Phip) - ...
                       cos(omega * x(end) + Phip))/(omega * (x(end) - x(1)));
%% Fitting
paramsFFTp           = [offs, maxFFT, fPeak, Phip];
if maxFFTindx < 0.99 * n2
% FFT peak not at f-Nyquist
  NumPeaks           = 1;
  paramsFFT          = paramsFFTp;
else
% Samples per period close to 2, max FFT peak close to f-Nyquist
% Set 1st evaluation point a little below f-Nyquist
  fIndxExtra1        = round(maxFFTindx * 0.995);
  fExtra1            = fs(fIndxExtra1);
  PhiExtra1          = angle(Y(fIndxExtra1)) + pi/2 - x(1) * fExtra1 * pi2;
% extra f for evaluation left of max peak 
  fIndxExtra2        = round(0.75 * maxFFTindx);
  fExtra2            = fs(fIndxExtra2);
  PhiExtra2          = angle(Y(fIndxExtra2)) + pi/2 - x(1) * fExtra2 * pi2;
% put together  
  paramsFFT          = [[offs,       maxFFT, 0.995 * fPeak, PhiExtra1]; ...
                        [offs, 0.8 * maxFFT,       fExtra2, PhiExtra2]];
  NumPeaks           = 2;
end
paramsOut            = zeros(NumPeaks, 6);           % for regression outputs
%% find best fit in time domain
modelfun             = @(paramc, x) paramc(1) + paramc(2) * sin(pi2 * paramc(3) * x + paramc(4));
opts                 = statset('nlinfit');
opts.MaxIter         = 10000;                        % 620 is the limit in evaluated test set.
opts.Display         = 'off';
opts.TolFun          = 1e-9;
opts.TolX            = 1e-9;
warning('off', 'all');                               % disable warnings from nlinfit
for i = 1 : NumPeaks
  [SineParams, ~, ~, ~, MSE] = nlinfit(x, y, modelfun, paramsFFT(i, :), opts);
% make frequency positive
  if SineParams(3) < 0
    SineParams(3)    = -SineParams(3);
% sin(2 * pi * - f - phi) = sin(2 * pi * f + phi + pi)    
    SineParams(4)    = pi - SineParams(4);          
  end
% make amplitude positive
  if SineParams(2) < 0
    SineParams(2)    = -SineParams(2);
    SineParams(4)    = SineParams(4) + pi;
  end
  paramsOut(i, :)    = [SineParams, MSE, MSE];
  if NumSamples < 5  % && SineParams(3) <= fNy
% No valid MSE from nlinfit if num samples < 5
% Overwrite MSE, set priority to 1st result (by *i)
% will be overwritten again with max allowed amplitude
    paramsOut(i, 5)  = 0.003 * i;
  end
  if SineParams(3) > fNy
% f larger than nyquist limit
    paramsOut(i, 5)  = Inf;                          %set MSE to terrible
  end
end
warning('on','all');
%% take best manipulated score
[MSEmin, MSEminIndx] = min(paramsOut(:, 5));
SineParams           = paramsOut(MSEminIndx, 1 : 4);
% Determine max allowed amplitude by MSEmin
if MSEmin <= 0.00001 || ...                          % extremly good MSE
   NumSamples < 5 ||    ...                          % no MSE with nlinfit for less than 5 samples
  (NumSamples ==5 && SineParams(3)<0.8*paramsFFT(1,3)) ||... % num period propably <1
  (MSEmin < 1 && x(end) - x(1) < 0.5/SineParams(3))  % propably less than 0.5 periods
  maxAmp             = 66 * maxFFT;                  % max allowed amplitude
elseif MSEmin > 0.3
  maxAmp             = 4 * maxFFT;
elseif MSEmin > 0.01
  maxAmp             = 6 * maxFFT;
elseif MSEmin > 0.001
  maxAmp             = 18 * maxFFT;
else
%very good MSE, 0.00001 < MSE <0.001
  maxAmp             = 33 * maxFFT;
end
% maxAmp=0;%TEST! Force FFT output
if SineParams(2) > maxAmp || SineParams(3) >fNy
% Best regression has too big amplitude or is over Nyquist limit,
% take original FFT result
  SineParams         = paramsFFTp;
%  MSE                = NaN;                         % for PlotResults
else
%  MSE                = paramsOut(MSEminIndx, 6);    % for PlotResults
end
% make phase between 0 and 2 pi
SineParams(4)        = rem(SineParams(4),pi2);
if SineParams(4) < 0
  SineParams(4)      = SineParams(4) + pi2;
end
end