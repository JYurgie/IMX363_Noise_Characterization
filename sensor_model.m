%% Lines to change/uncomment
% Exposure time: Line 50
% Scene: Choose line 59 (uniform white scene) or 61 (macbetch)
% Sensor Computation: uncomment one of line 133+ depending on which
%   isospeed

%% measured noise
% read noise
readnoise_55 = 0.3e-3;
readnoise_99 = 0.4e-3;
readnoise_198 = 0.6e-3;
readnoise_299 = 0.81e-3;
readnoise_395 = 0.99e-3;
readnoise_798 = 1.92e-3;

% PRNU
prnu_55 = 4.10;
prnu_99 = 4.60;
prnu_198 = 5.43;
prnu_299 = 5.42;
prnu_395 = 6.49;
prnu_798 = 7.58;

% DSNU - in V
dsnu_55 = 2.25e-3;
dsnu_99 = 2.88e-3;
dsnu_198 = 4.05e-3;
dsnu_299 = 6.08e-3;
dsnu_395 = 5.35e-3;
dsnu_798 = 8.83e-3;

% analog gain
gain_55 = 1;
gain_99 = 1.8;
gain_198 = 3.60;
gain_299 = 4.35;
gain_395 = 14.51;
gain_798 = 29.05;

% dark voltage - mV/s
dark_55 = 22.78e-3;
dark_99 = 31.9e-3;
dark_198 = 15.48e-3;
dark_299 = 22.95e-3;
dark_395 = 33.38e-3;
dark_798 = 31.58e-3;

% Analog Offset - mV
analog_offset = 3.585e-3;

% Black Level
black_level = 63.93;

% Exposure Time - S
exposure_time = 0.007;

% general model params
rows = 3024;
cols = 4032;


%% initiate scene
ieInit;
wave = 400:10:700;
patchSize = 64;
% Uniform White Desnity
scene = sceneCreate('uniformd65',patchSize,wave);
% Macbeth filter
%scene = sceneCreate('macbeth',patchSize,wave); 
%scene = sceneCreate('macbeth tungsten',patchSize,wave); 
oi = oiCreate;
oi = oiSet(oi,'optics fnumber',1.7);
oi = oiSet(oi,'optics offaxis method','cos4th');
oi = oiSet(oi,'optics focal length',24e-3);
oi = oiCompute(oi,scene);
oiWindow(oi);

%sceneWindow(scene); % optional, for visualizing the scene 
% premade imx363 sensor sensor
sensor = sensorCreate('imx363');
pixel =  sensorGet(sensor,'pixel');

%% initiate sensors

% all iso sensors
sensor_55 = sensorCreate('imx363');
sensor_55 = sensorSet(sensor_55,'rows',rows);
sensor_55 = sensorSet(sensor_55,'cols',cols);
sensor_55 = sensorSet(sensor_55,'pixel read noise volts',readnoise_55); 
sensor_55 = sensorSet(sensor_55,'dsnu level',dsnu_55);  
sensor_55 = sensorSet(sensor_55,'prnu level',prnu_55);
sensor_55 = sensorSet(sensor_55,'analog gain',gain_55);
sensor_55 = sensorSet(sensor_55,'analog offset',analog_offset);
sensor_55 = sensorSet(sensor_55,'pixel dark voltage',dark_55);
sensor_55 = sensorSet(sensor_55,'exposure time',exposure_time);



sensor_99 = sensorCreate('imx363');
sensor_99 = sensorSet(sensor_99,'rows',rows);
sensor_99 = sensorSet(sensor_99,'cols',cols);
sensor_99 = sensorSet(sensor_99,'pixel read noise volts',readnoise_99); 
sensor_99 = sensorSet(sensor_99,'dsnu level',dsnu_99);  
sensor_99 = sensorSet(sensor_99,'prnu level',prnu_99);
sensor_99 = sensorSet(sensor_99,'analog gain',gain_99);
sensor_99 = sensorSet(sensor_99,'analog offset',analog_offset);
sensor_99 = sensorSet(sensor_99,'pixel dark voltage',dark_99);
sensor_99 = sensorSet(sensor_99,'exposure time',exposure_time);


sensor_198 = sensorCreate('imx363');
sensor_198 = sensorSet(sensor_198,'rows',rows);
sensor_198 = sensorSet(sensor_198,'cols',cols);
sensor_198 = sensorSet(sensor_198,'pixel read noise volts',readnoise_198); 
sensor_198 = sensorSet(sensor_198,'dsnu level',dsnu_198);  
sensor_198 = sensorSet(sensor_198,'prnu level',prnu_198);
sensor_198 = sensorSet(sensor_198,'analog gain',gain_198);
sensor_198 = sensorSet(sensor_198,'analog offset',analog_offset);
sensor_198 = sensorSet(sensor_198,'pixel dark voltage',dark_198);
sensor_198 = sensorSet(sensor_198,'exposure time',exposure_time);


sensor_299 = sensorCreate('imx363');
sensor_299 = sensorSet(sensor_299,'rows',rows);
sensor_299 = sensorSet(sensor_299,'cols',cols);
sensor_299 = sensorSet(sensor_299,'pixel read noise volts',readnoise_299); 
sensor_299 = sensorSet(sensor_299,'dsnu level',dsnu_299);  
sensor_299 = sensorSet(sensor_299,'prnu level',prnu_299);
sensor_299 = sensorSet(sensor_299,'analog gain',gain_299);
sensor_299 = sensorSet(sensor_299,'analog offset',analog_offset);
sensor_299 = sensorSet(sensor_299,'pixel dark voltage',dark_299);
sensor_299 = sensorSet(sensor_299,'exposure time',exposure_time);
sensor_299 = sensorSet(sensor_299,'blacklevel',black_level);

sensor_395 = sensorCreate('imx363');
sensor_395 = sensorSet(sensor_395,'rows',rows);
sensor_395 = sensorSet(sensor_395,'cols',cols);
sensor_395 = sensorSet(sensor_395,'pixel read noise volts',readnoise_395); 
sensor_395 = sensorSet(sensor_395,'dsnu level',dsnu_395);  
sensor_395 = sensorSet(sensor_395,'prnu level',prnu_395);
sensor_395 = sensorSet(sensor_395,'analog gain',gain_395);
sensor_395 = sensorSet(sensor_395,'analog offset',analog_offset);
sensor_395 = sensorSet(sensor_395,'pixel dark voltage',dark_395);
sensor_395 = sensorSet(sensor_395,'exposure time',exposure_time);


sensor_798 = sensorCreate('imx363');
sensor_798 = sensorSet(sensor_798,'rows',rows);
sensor_798 = sensorSet(sensor_798,'cols',cols);
sensor_798 = sensorSet(sensor_798,'pixel read noise volts',readnoise_798); 
sensor_798 = sensorSet(sensor_798,'dsnu level',dsnu_798);  
sensor_798 = sensorSet(sensor_798,'prnu level',prnu_798);
sensor_798 = sensorSet(sensor_798,'analog gain',gain_798);
sensor_798 = sensorSet(sensor_798,'analog offset',analog_offset);
sensor_798 = sensorSet(sensor_798,'pixel dark voltage',dark_798);
sensor_798 = sensorSet(sensor_798,'exposure time',exposure_time);


%% compute sensors
%sensor = sensorCompute(sensor,oi);
%sensor_55 = sensorCompute(sensor_55,oi);
%sensor_99 = sensorCompute(sensor_99,oi);
sensor_198 = sensorCompute(sensor_198,oi);
%sensor_299 = sensorCompute(sensor_299,oi);
%sensor_395 = sensorCompute(sensor_395,oi);
%sensor_798 = sensorCompute(sensor_798,oi);
sensor = sensor_198;
sensorWindow(sensor);


%% Image Processor

% The sensor array is demosaiced, color-balanced, and rendered on
% a display The image processing pipeline is managed by the
% fourth principal ISET structure, the virtual camera image (ip).
% This structure allows the user to set a variety of image
% processing methods, including demosaicking and color balancing.
ip = ipCreate;

% The routines for setting and getting image processing
% parameters are ipGet and ipSet.
%
ip = ipSet(ip,'name','Unbalanced');
ip = ipSet(ip,'scale display',1);

% The default properties use bilinear demosaicking, no color
% conversion or balancing.  The sensor RGB values are simply set
% to the display RGB values.
ip = ipCompute(ip,sensor);

% As in the other cases, we can bring up a window to view the
% processed data, this time a full RGB image.
ieAddObject(ip); ipWindow

%% You can experiment by changing the processing parameters 

% For example
ip2 = ipSet(ip,'name','More Balanced');
ip2 = ipSet(ip2,'internalCS','XYZ');
ip2 = ipSet(ip2,'conversion method sensor','MCC Optimized');
ip2 = ipSet(ip2,'correction method illuminant','Gray World');

% With these parameters, the colors will appear to be more accurate
ip2 = ipCompute(ip2,sensor);

ipWindow(ip2)

% Again, this window offers the opportunity to perform many
% parameter changes and to evaluate certain metric properties of
% the current system. Try the pulldown menu item (Analyze |
% Create Slanted Bar) and then run the pulldown menu (Analyze |
% ISO12233) to obtain a spatial frequency response function for
% the slanted bar image in the ISO standard.
