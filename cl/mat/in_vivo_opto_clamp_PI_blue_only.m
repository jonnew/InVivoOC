% Continuous output single-input, two-output PI controller for the cyclops
% LED driver.
% Written by:       Will Hendry
%                   Jon Newman
%
%



close all;
clear variables;
% cbmex('open') %opens their library
proc_fig = figure; % temorary way to stop the function
set(proc_fig, 'Name', 'Close this figure to stop');

% Parameters
dt                  = 0.001;        % ADC Polling period (sec)
num_unit            = 1;            % Number of units in spike data streams (unitless)
target_fr           = 5;            % The target firing rate (Hz/unit) 
filter_tau          = 5;            % First order averaging filter's tau (sec)
K                   = 0.1;          % Proportional gain (unitless)
Ti                  = 1.0;          % Integral time constant (sec)
D_out               = 0.25;         % Degree of overlap in two ouput signals (unitless)

% Convert time to samples
alpha = 2.0 / ((filter_tau / dt) + 1);
Ki = dt / Ti;

% Initialization
filt_fr = 0;
out = 0;
error = zeros(1,2);
t = 0;

% cbmex('trialconfig', 1); % empty the buffer and start recording

   
while (ishandle(proc_fig))
    if (ishandle(proc_fig))
        drawnow; %temporary way to stop the code
    end
    
    
    
    % Grab data
%     [spike_data, t_buf1, continuous_data] = cbmex('trialdata',1); % read some data 
    
    spike_data = [];
    
    % Some pesudo code
    this_fr = numel(spike_data)/num_unit/dt;
    
    % Smooth the fr
    filt_fr = alpha * this_fr + (1 - alpha) * filt_fr;
    
    % Generate error signal
    error(2) = error(1);
    error(1) = target_fr - filt_fr;
    
    % Generate PI control signal
    out = out + K * (error(1) - error(2));
    if (out <= 1 && out >= -1)
        out = out +  K * Ki * error(2);
    end
    
    % Generate stimuli (LED driver accepts a 0-5 volt signal. We are
    % assuming, for future use, that we have two ouputs to both inrease and
    % decrease firing.)
    out1 = 0; out2 = 0;
    
    if (D_out - 1 <= out && out <= D_out)
        out2 = out - D_out;
    elseif (out < D_out - 1)
        out2 = -1;
    end
    
    if (-D_out <= out && out <= 1 - D_out)
        out1 = out + D_out;
    elseif (out > 1 - D_out)
        out1 = 1;
    end
    
    % Maintain output bounds
    if (out < -1)
        out2 = -1;
    elseif (out2 > 0)
        out2 = 0;
    end
    if (out1 > 1)
        out1 = 1;
    elseif(out1 < 0)
        out1 = 0;
    end
    
    % Step up to 5 volt range
    out1 = 5 * out1; 
    out2 = -5 * out2; 
    
    t = t + dt;
    
    subplot(211)
    plot(t,out1,'b.');
    ylim([0 5]);
    
    subplot(212)
    plot(t,out2,'r.');
    ylim([0 5]);

    target_fr = sin(2*pi*t*10);
    
   % Write output (need to be able to update output voltage rather than
   % sending a continuous signal)
%    write(out1, channel 0)
%    write(out2, channel 1)
    
end
cbmex('analogout', 145, 'disable')
pause(1) %doesn't seem to disable the analog channel properly without some delay between comands
         %I will find the frequency at which we can send comands (probably
         %gets buffered were closing gets some priority in the buffer)
         
cbmex('close') %always close the interface for good mesure
