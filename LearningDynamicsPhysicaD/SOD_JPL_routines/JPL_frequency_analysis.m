function sineFunc = JPL_frequency_analysis(t, r)
% function sineFunc = JPL_frequency_analysis(t, r)

% (C) M. Zhong

pim2                 = pi * 2;
N                    = length(t);
dt                   = t(2) - t(1);
%fNy                 = 1/(2 * dt);                   % Nyquist frequency
offs                 = mean(r);                      % DC value
r_m                  = r - offs;                     % FFT much better without offset
n                    = 24 * 60 * N;
R                    = fft(r_m, n);                  % Y(f)
Nd2                  = floor(N/2);
P2                   = abs(R/N);
P1                   = P2(1: Nd2 + 1);
P1(2: end - 1)       = 2 * P1(2 : end - 1);
fs                   = (0: Nd2)/(N * dt);            % frequency scale
% %FFT parameters at peak
[maxFFT, maxFFTindx] = max(P1);                      % Peak magnitude and location
fPeak                = fs(maxFFTindx);               % f at peak
 % Phi-Peak is for cos, sin(90° + alpha) = cos(betta), alpha = -betta
Phip                 = angle(R(maxFFTindx)) + pi/2;
Phip                 = Phip - t(1) * fPeak * pim2;   % shift for phi at x=0
%Better estimate for offset:
omega                = pim2* fPeak;
offs                 = offs - maxFFT * (cos(omega * t(1) + Phip) - ...
                       cos(omega * t(end) + Phip))/(omega * (t(end) - t(1)));
sineFunc             = @(t_vec) offs + maxFFT * sin(2 * pi * fPeak * t_vec + Phip);
end