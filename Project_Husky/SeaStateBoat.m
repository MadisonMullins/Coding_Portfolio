% Parameters for Douglas Sea State 3
Hs = 1;               % Significant wave height (average wave height), meters
Tp = 5;               % Peak period, seconds
omega = linspace(0.1, 3, 1000); % Angular frequency vector, rad/s
% Boat Parameters
m = 5000;             % Boat mass, kg
L = 8;                % Boat length, meters
B = 3;                % Boat beam (width), meters
Ixx = 8000;           % Moment of inertia about x-axis (roll), kg.m^2
Iyy = 10000;          % Moment of inertia about y-axis (pitch), kg.m^2
Izz = 12000;          % Moment of inertia about z-axis (yaw), kg.m^2
% Pierson-Moskowitz Spectrum
g = 9.81; % Acceleration due to gravity, m/s^2
alpha = 0.0081; % Empirical constant for PM spectrum
beta = 0.74; % Empirical constant
S = (alpha * g^2 ./ omega.^5) .* exp(-beta * (g ./ (omega .* Tp)).^4);
% Random phase angles for each wave component
phi = 2 * pi * rand(1, length(omega));
% Time domain simulation
dt = 0.1;                % Time step, seconds
t = 0:dt:200;            % Simulation time vector, seconds
eta = zeros(size(t));    % Wave elevation
% Generate wave elevation
for i = 1:length(omega)
    A = sqrt(2 * S(i) * (omega(2) - omega(1))); % Amplitude
    eta = eta + A * cos(omega(i) * t + phi(i));
end
% Calculate boat motion responses
% Transfer functions for boat motion (assumed simplified linear dynamics)
zeta_heave = 0.05;   % Damping ratio for heave
zeta_roll = 0.1;     % Damping ratio for roll
zeta_pitch = 0.1;    % Damping ratio for pitch
wn_heave = 2 * pi / Tp;  % Natural frequency for heave
wn_roll = wn_heave / 1.5; % Natural frequency for roll
wn_pitch = wn_heave / 1.2; % Natural frequency for pitch
% Boat response in each DOF
heave = zeros(size(t));
roll = zeros(size(t));
pitch = zeros(size(t));
for i = 2:length(t)
    % Heave response (vertical displacement)
    heave(i) = exp(-zeta_heave * wn_heave * dt) * heave(i-1) + ...
               (1 - exp(-zeta_heave * wn_heave * dt)) * eta(i);
    % Roll response (rotation about x-axis)
    roll(i) = exp(-zeta_roll * wn_roll * dt) * roll(i-1) + ...
              (1 - exp(-zeta_roll * wn_roll * dt)) * eta(i);
    % Pitch response (rotation about y-axis)
    pitch(i) = exp(-zeta_pitch * wn_pitch * dt) * pitch(i-1) + ...
               (1 - exp(-zeta_pitch * wn_pitch * dt)) * eta(i);
end
% Plot results
figure;
% Plot wave elevation
subplot(3, 1, 1);
plot(t, eta);
title('Wave Elevation (Sea State 3)');
xlabel('Time (s)');
ylabel('Wave Elevation (m)');
grid on;
% Plot boat heave
subplot(3, 1, 2);
plot(t, heave);
title('Boat Heave Response');
xlabel('Time (s)');
ylabel('Heave (m)');
grid on;
% Plot roll and pitch
subplot(3, 1, 3);
plot(t, roll, t, pitch);
title('Boat Roll and Pitch Response');
xlabel('Time (s)');
ylabel('Angle (rad)');
legend('Roll', 'Pitch');
grid on;
