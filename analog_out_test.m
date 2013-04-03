% At least three input arguments required
% Format: cbmex('analogout', channel, [<parameter>, [value]])
% channel: 145 (aout1), 146 (aout2), 147 (aout3), 148 (aout4)
% waveform: depends on the parameters
% <parameter>, <value> pairs are optional, Some parameters do not have values.
%  from left to right parameters will overwrite previous ones.
% <parameter>[, <value>] can be any of:
% 'pulses', waveform: waveform is vector
% 		[nNPulses nOffset nPhase1Duration nPhase2Duration nPhase1Amplitude nPhase2Amplitude nInterPhaseDelay nInterPulseDelay]
% 'sinusoid', waveform: waveform is vector [nFrequency nPhase1Amplitude]
% 'disable': (default) disable analog output
% 'mv': if specified, voltages are considered in milli volts instead of raw integer
% 'ms': if specified, intervals are considered in milli seconds instead of samples
close all;
clear variables;
cbmex('open')
proc_fig = figure; % main display
set(proc_fig, 'Name', 'Close this figure to stop');
waveform=[200, 100];
pause_time=0.0001;
cbmex('analogout', 145, 'sinusoid', waveform, 'mv')
cbmex('trialconfig', 1); % empty the buffer, buffer only event data
while (ishandle(proc_fig))
    if (ishandle(proc_fig))
        drawnow;
    end
    for j=1:100
        [spike_data, t_buf1, continuous_data] = cbmex('trialdata',1); % read some data
        cbmex('analogout', 145, 'sinusoid', waveform, 'mv')
    end
end
cbmex('analogout', 145, 'disable')
pause(1)
cbmex('close')
1/pause_time;