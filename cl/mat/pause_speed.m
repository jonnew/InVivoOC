close all;
clear variables;
expected_pause=0.00001;
x=[];
t_start=tic;
x_handle=tic;
j=0;
while j<=100000
        if toc(t_start)>expected_pause
            x=[x toc(x_handle)];
            t_start=tic;
            x_handle=tic;
            j=j+1;
        end
end
aprox_freq=1/mean(x);
exped_freq=1/expected_pause;
freq_error=(abs(aprox_freq-exped_freq)/exped_freq)*100;
time_information=[max(x) min(x) mean(x)]
other_information=[length(x(x>mean(x))) length(x(x>mean(x)))/length(x)*100] 
