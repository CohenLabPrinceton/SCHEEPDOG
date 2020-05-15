%% scheepdog_driver.m
% Written by Tom J. Zajdel in Daniel Cohen's group at Princeton University
%
% Code for closed-loop control of two current sources for electrical
% stimulation of cells in vitro.
% Rotation of field 360 degrees over 8 hours is demonstrated.

%% Instrumentation initialization

% Initialize Keithley sourcemeter for x-axis current stimulation (USB connection, K2450)
keith1=visa('ni','USB0::0x0000::0x0000::00000000::INSTR'); % change for your instrument
fopen(keith1);
fprintf(keith1,'*RST');  % configure keithley
fprintf(keith1,':SOUR:FUNC CURR');
fprintf(keith1,':SOUR:CURR:RANGE 20e-3');
fprintf(keith1,':SOUR:CURR:VLIMIT 100');
fprintf(keith1,':SENS:FUNC "VOLT"');
fprintf(keith1,':SENS:VOLT:RANG 40');

% Initialize Keithley sourcemeter for y-axis current stimulation (GPIB connection, K2400)
keith2 = serial('COM00');                                  % change for your setup
keith2.Terminator = 'CR/LF';
keith2.Timeout =0.5;
fopen(keith2);
fprintf(keith2, '++addr 24');
fprintf(keith2, '++read eoi');
fprintf(keith2,'*RST');
fprintf(keith2,':SOUR:FUNC CURR');
fprintf(keith2,':SOUR:CURR:RANG 20e-3');
fprintf(keith2,':SENS:VOLT:DC:PROT:LEV 100');

% Initialize Digilent Analog Discovery 2 digital multimeter
s   = daq.createSession('digilent');
ch1 = addAnalogInputChannel(s,'AD1',1,'Voltage');
ch2 = addAnalogInputChannel(s,'AD1',2,'Voltage');

s.Rate = 100;
s.DurationInSeconds = 0.5;


%% Control signal generation

time = 8*3600;      % stimulation time in seconds
t    = 0:1:time;    % time vector

tsig = 20:20:time;  % break signal down into 20-second periods
ampy = 6;           % x-axis channel voltage target
ampx = 6;           % y-axis channel voltage target

% calculate the field stimulation angle for each 20-second period
ysig  = ampy*cos(2*pi*tsig/time);
xsig  = ampx*sin(2*pi*tsig/time);
angles = atan2(ysig,xsig)*180/pi;

% divide each 20-second period into an x-stimulation and y-stimulation
% period based on the required angles
VX =[];
VY =[];
for k=20:20:length(t)
    thetak = angles(k/20);
    xon    = abs(round(20*cosd(thetak)/(abs(cosd(thetak))+abs(sind(thetak)))));
    yon    = 20-xon;

    % VX and VY are the stimulation voltage vectors
    % For a given index, only one of the two will be non-zero
    VX = [VX ampx*sign(cosd(thetak))*ones(1,xon) zeros(1,yon)];
    VY = [VY zeros(1,xon) ampy*sign(sind(thetak))*ones(1,yon)];
end

%% Control loop

% Initialize variables 
vkeith1 = [];   % voltage at output of Keithley 1 (x-axis)
vkeith2 = [];   % voltage at output of Keithley 2 (y-axis)
vx=[];          % x-axis channel voltage
vy=[];          % y-axis channel voltage
ix=[];          % x-axis current
iy=[];          % y-axis current
tt=[];          % time stamps
verrx=[];       % x-axis voltage error
verry=[];       % y-axis voltage error
currx = 8e-3;   % initial x-axis current
curry = 8e-3;   % initial y-axis current

t0 = datetime('now');   % start timer
t1 = datetime('now');
timelapse = t1 - t0;

while seconds(timelapse) < time
    tk    = seconds(timelapse);  % get elapsed time
    ttemp = t(t<=tk);            % vector of time indices lower than the elapsed time
    k     = ttemp(end);          % k is the closest index to the present time
    
    vtarget_x = VX(t==k);        % set the target voltage based on elapsed time
    vtarget_y = VY(t==k);
    
    % reverse current direction if necessary
    if sign(vtarget_x) ~= sign(currx) && sign(vtarget_x)~=0
        currx = currx*-1;
    end
    if sign(vtarget_y) ~= sign(curry) && sign(vtarget_y)~=0
        curry = curry*-1;
    end  
    
    % if intended voltage is 0, simply turn off the current source output
    if vtarget_x == 0
        fprintf(keith1,':OUTP OFF');
    end
    if vtarget_y == 0
        fprintf(keith2,':OUTP OFF');
    end

    % x-axis current stimulation
    if vtarget_x ~= 0
        fprintf(keith2,':OUTP OFF');                         % turn off y-axis
        fprintf(keith1,sprintf(':SOUR:CURR:LEV %f',currx));  % set x-axis current
        fprintf(keith1,':OUTP ON');                          % turn on x-axis
        fprintf(keith1,':READ?');                            % read Keithley output voltage
        vkeith1 = [vkeith1; str2double(fscanf(keith1))];

        % read channel voltages
        data = startForeground(s); 
        v1   = mean(data(:,1));     % x-axis
        v2   = mean(data(:,2));     % y-axis
        
        % calculate and record voltage errors
        ex    = v1-vtarget_x; 
        verrx = [verrx; ex];
        ey    = v2-vtarget_y;
        verry = [verry; ey];
        
        % feedback for x-axis control current
        currx = currx-0.0002*ex;
    end
    
    % y-axis current stimulation
    if vtarget_y ~= 0
        fprintf(keith1,':OUTP OFF');                         % turn off x-axis
        fprintf(keith2,sprintf(':SOUR:CURR:LEV %f',curry));  % set y-axis current
        fprintf(keith2,':OUTP ON');                          % turn on y-axis
        
        % read channel voltages
        data = startForeground(s);  
        v1 = mean(data(:,1));       % x-axis
        v2 = mean(data(:,2));       % y-axis

        % calculate and record voltage errors
        ex    = v1-vtarget_x;
        verrx = [verrx; ex];
        ey    = v2-vtarget_y;
        verry = [verry; ey];
        
        % feedback for y-axis control current 
        curry = curry-0.0002*ey;
    end
       
    % append data
    vx = [vx; v1];
    vy = [vy; v2];
    ix = [ix; currx];
    iy = [iy; curry];
    tt = [tt; tk]; 

    % console status update
    fprintf('\nTime: %.2f sec of %.2f sec', seconds(timelapse), time)
    fprintf('\n(ix, iy): (%e, %e) A',currx,curry);
    fprintf('\n(vx, vy): (%.2f, %.2f) V',v1,v2);
    fprintf('\n(ex, ey): (%.2f, %.2f) V\n',ex,ey);
        
    % every 10 seconds, update plot of the channel voltage and current
    if (floor(mod(tk,10))<=1)
        subplot(211)
        plot(tt./3600,vx,'r',tt./3600,vy,'b');
        xlim([0 max(tt)./3600+.001]);
        ylabel('V');
        subplot(212)
        plot(tt./3600,ix,'r',tt./3600,iy,'b');
        xlim([0 max(tt)./3600+.001]);
        ylabel('A');
        xlabel('T (h)');
    end
    pause(0.25); % <--- breakpoint HERE if you need to make adjustments in medias res
    
    t1 = datetime('now');     % update elapsed time
    timelapse = t1 - t0;
end            
fprintf(keith1,':OUTP OFF');  % when finished, turn off all outputs
fprintf(keith2,':OUTP OFF');
