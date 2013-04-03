close all;
clear variables;
cbmex('open') %opens their library
proc_fig = figure; % temorary way to stop the function
set(proc_fig, 'Name', 'Close this figure to stop');
target_frequency=5; %the target frequency in Hz
collection_time=0.01; %collect samples for this amount time

%temporary holder for starting output
waveform=[200, 100]; %[nFrequency nPhase1Amplitude]
cbmex('analogout', 145, 'sinusoid', waveform, 'mv')

cbmex('trialconfig', 1); % empty the buffer and start recording
t_start=tic; %marks the begning of recording (could alternativly use cputime)

    %in the future the program should probably be albe to wait here and
    %take in some user input
    
    %if we want to use 5 seconds worth of spikes we could collect here
    %first before doing adding the most recently collected data
    %for example
    
%     while (toc(t_start)<5)
%         if toc(t_start)>=5
%             [spike_data, t_buf1, continuous_data] = cbmex('trialdata',1);
%         end
%     end
%t_start=tic; %to have a new time to start from

    %would get 5 seonds worth of data which will need some editing to
    %correctly bin the spike_data unless we use the time stamps in
    %spike_data to estimate a firing frequency over a time period
    
    %alternatively we could use a vector of spike_data that is seporated
    %by the bin size we want. where we would really just collect for the
    %amount of time equal to the delta_t we use for the binning and put
    %that section of the spike_data into the next element of the vector
    
while (ishandle(proc_fig))
    if (ishandle(proc_fig))
        drawnow; %temporary way to stop the code
    end
    

    while (toc(t_start)<collection_time)
        if toc(t_start)>=collection_time
            [spike_data, t_buf1, continuous_data] = cbmex('trialdata',1); % read some data 
            %spike_data has the spike timestamps sorted according to whatever
            %algorithm was used to set up the channel in the central program
            %currently only channel one is turned on and it samples at 
            %10kHz where the spike processing is filtered
            %with a HP 250Hz, with a threshold value of -86uV, and the Hoops
            %sorthing algorithm
            t_start=tic;
        end
    end
    %binning of the last five seconds
        %would take in the new spike_data add it on to what is currently
        %saved in some variable and then erase and equivilent time worth of
        %spike_data from the running 
    
    %more filtering
        %depends on what we want to do with the firing rates gotten from
        %binning the spikes
    
    %finding the population frequency (of the last 5 seconds I'm assuming)
        %average firing rate in the last 5 seconds?
        
    %compare to target frequency to get an error
        %
    
    %PI control that takes the error as an input
        %not sure how to make one in MATLAB 
        %I'm guessing there is some way to make a transfer function that
        %would be previously defined before the bulk of the code is run
    
    %change output signal based on the PI controler
        %pules?
        %chaging amp/freq of an sinusoid?
    
end
cbmex('analogout', 145, 'disable')
pause(1) %doesn't seem to disable the analog channel properly without some delay between comands
         %I will find the frequency at which we can send comands (probably
         %gets buffered were closing gets some priority in the buffer)
         
cbmex('close') %always close the interface for good mesure
