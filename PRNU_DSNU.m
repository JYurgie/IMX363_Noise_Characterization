%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSYCH 221 : Google Pixel 4A Noise Model - DSNU and PRNU Noise Estimation
% Authors : Melissa Horowitz, Joey Yurgelon
% Date : 11/3/2020
% Required File Structure : 
%          See 'project/README.txt' - MATLAB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear all 
% close all
% clc

offsetIMG55 = 63.137;
offsetIMG99 = 63.660;
offsetIMG198 = 63.651;
offsetIMG299 = 63.179;
offsetIMG395 = 62.463;
offsetIMG798 = 62.107;

offsetR55 = 153.808;
offsetG55 = 153.807;
offsetB55 = 153.803;

offsetR99 = 153.982;
offsetG99 = 153.981;
offsetB99 = 153.976;

offsetR198 = 148.644;
offsetG198 = 148.644;
offsetB198 = 148.638;

offsetR299 = 153.821;
offsetG299 = 153.820;
offsetB299 = 153.818;

offsetR395 = 153.580;
offsetG395 = 153.584;
offsetB395 = 153.579;

offsetR798 = 153.463;
offsetG798 = 153.458;
offsetB798 = 153.466;

offsetTL55 = 63.306;
offsetM55 = 62.920;

offsetTL99 = 63.765;
offsetM99 = 63.548;

offsetTL198 = 63.712;
offsetM198 = 63.594;

offsetTL299 = 63.252;
offsetM299 = 63.081;

offsetTL395 = 62.970;
offsetM395 = 61.839;

offsetTL798 = 62.732;
offsetM798 = 61.307;

img_path = "Camera_Noise/PRNU_DSNU/ISO_*/";

% Load in all of the '.DNG' Files
disp('Loading in the DNG Files..')
files = dir(img_path + '*.dng');
for i=1:length(files)
   files(i).name;
   [img, info] = ieDNGRead(files(i).name); % The image data and the header information
   info;
   data(i).img = img;
   data(i).imgMean = mean2(img);
   data(i).imgSTD = std2(img);
   data(i).isoSpeed = info.ISOSpeedRatings;
   data(i).fNumber = info.FNumber;
   data(i).focalLength = info.FocalLength;
   data(i).exposureTime = info.ExposureTime;
   
   % Partition the image into 3x3 sub-blocks
   heightBy3 = info.Height/3;
   widthBy3 = info.Width/3;
   
   data(i).imgTL = img(1:widthBy3, 1:heightBy3);
   data(i).imgTM = img((1+widthBy3):2*widthBy3, 1:heightBy3);
   data(i).imgLM = img(1:widthBy3, (1+heightBy3):2*heightBy3);
   data(i).imgM = img((1+widthBy3):2*widthBy3, (1+heightBy3):2*heightBy3);
   
   data(i).imgTLmean = mean2(data(i).imgTL);
   data(i).imgTMmean = mean2(data(i).imgTM);
   data(i).imgLMmean = mean2(data(i).imgLM);
   data(i).imgMmean = mean2(data(i).imgM);
   
   data(i).imgTLstd = std2(data(i).imgTL);
   data(i).imgTMstd = std2(data(i).imgTM);
   data(i).imgLMstd = std2(data(i).imgLM);
   data(i).imgMstd = std2(data(i).imgM);
   
   % Store the RGB pixel values for the RAW image
   % Slowest CHUNKY routine in the universe. 
   img_unravel = img(:,1);
   for j=2:length(img)
       vec = img(:,j);
       img_unravel = vertcat(img_unravel,vec);
   end
   
   data(i).imgUnravel = img_unravel;
      
   % Wow, this is some garbage code Joey
   red = false;
   green = false;
   blue = false;
   
   for k=1:length(img_unravel)
       if red == false
           r(k) = img_unravel(k);
           red = true;
           continue
       end
       if green == false
           g(k) = img_unravel(k);
           green = true;
           continue
       end
       if blue == false
           b(k) = img_unravel(k);
           red = false;
           green = false;
           continue
       end
   end
   
   % It works, but you know you dont feel good about it
   r = nonzeros(r);
   r = reshape(r,length(r),1);
   g = nonzeros(g);
   g = reshape(g,length(g),1);
   b = nonzeros(b);
   b = reshape(b,length(b),1);
   
   % IDC, it works.
   data(i).r = r;
   data(i).g = g;
   data(i).b = b;
   
   data(i).rMean = mean2(r);
   data(i).gMean = mean2(g);
   data(i).bMean = mean2(b);
   
   data(i).rSTD = std2(r);
   data(i).gSTD = std2(g);
   data(i).bSTD = std2(b);
   
   switch info.ISOSpeedRatings
        case 55
            data(i).imgMeanNorm = mean2((img-offsetIMG55));
            data(i).imgSTDNorm = std2((img-offsetIMG55));
            data(i).rMeanNorm = mean2((r-offsetR55));
            data(i).rSTDNorm = std2((r-offsetR55));
            data(i).gMeanNorm = mean2((g-offsetG55));
            data(i).gSTDNorm = std2((g-offsetG55));
            data(i).bMeanNorm = mean2((b-offsetB55));
            data(i).bSTDNorm = std2((b-offsetB55));
            
            data(i).imgTLmeanNorm = mean2((data(i).imgTL-offsetTL55));
            data(i).imgTMmeanNorm = mean2((data(i).imgTM-offsetIMG55));
            data(i).imgLMmeanNorm = mean2((data(i).imgLM-offsetIMG55));
            data(i).imgMmeanNorm = mean2((data(i).imgM-offsetM55));

            data(i).imgTLstdNorm = std2((data(i).imgTL-offsetTL55));
            data(i).imgTMstdNorm = std2((data(i).imgTM-offsetIMG55));
            data(i).imgLMstdNorm = std2((data(i).imgLM-offsetIMG55));
            data(i).imgMstdNorm = std2((data(i).imgM-offsetM55));
        case 99
            data(i).imgMeanNorm = mean2((img-offsetIMG99)/1.8);
            data(i).imgSTDNorm = std2((img-offsetIMG99)/1.8);
            data(i).rMeanNorm = mean2((r-offsetR99)/1.8);
            data(i).rSTDNorm = std2((r-offsetR99)/1.8);
            data(i).gMeanNorm = mean2((g-offsetG99)/1.8);
            data(i).gSTDNorm = std2((g-offsetG99)/1.8);
            data(i).bMeanNorm = mean2((b-offsetB99)/1.8);
            data(i).bSTDNorm = std2((b-offsetB99)/1.8);
            
            data(i).imgTLmeanNorm = mean2((data(i).imgTL-offsetTL99)/1.8);
            data(i).imgTMmeanNorm = mean2((data(i).imgTM-offsetIMG99)/1.8);
            data(i).imgLMmeanNorm = mean2((data(i).imgLM-offsetIMG99)/1.8);
            data(i).imgMmeanNorm = mean2((data(i).imgM-offsetM99)/1.8);

            data(i).imgTLstdNorm = std2((data(i).imgTL-offsetTL99)/1.8);
            data(i).imgTMstdNorm = std2((data(i).imgTM-offsetIMG99)/1.8);
            data(i).imgLMstdNorm = std2((data(i).imgLM-offsetIMG99)/1.8);
            data(i).imgMstdNorm = std2((data(i).imgM-offsetM99)/1.8);
        case 198
            data(i).imgMeanNorm = mean2((img-offsetIMG198)/3.6);
            data(i).imgSTDNorm = std2((img-offsetIMG198)/3.6);
            data(i).rMeanNorm = mean2((r-offsetR198)/3.6);
            data(i).rSTDNorm = std2((r-offsetR198)/3.6);
            data(i).gMeanNorm = mean2((g-offsetG198)/3.6);
            data(i).gSTDNorm = std2((g-offsetG198)/3.6);
            data(i).bMeanNorm = mean2((b-offsetB198)/3.6);
            data(i).bSTDNorm = std2((b-offsetB198)/3.6);
            
            data(i).imgTLmeanNorm = mean2((data(i).imgTL-offsetTL198)/3.6);
            data(i).imgTMmeanNorm = mean2((data(i).imgTM-offsetIMG198)/3.6);
            data(i).imgLMmeanNorm = mean2((data(i).imgLM-offsetIMG198)/3.6);
            data(i).imgMmeanNorm = mean2((data(i).imgM-offsetM198)/3.6);

            data(i).imgTLstdNorm = std2((data(i).imgTL-offsetTL198)/3.6);
            data(i).imgTMstdNorm = std2((data(i).imgTM-offsetIMG198)/3.6);
            data(i).imgLMstdNorm = std2((data(i).imgLM-offsetIMG198)/3.6);
            data(i).imgMstdNorm = std2((data(i).imgM-offsetM198)/3.6);
        case 299
            data(i).imgMeanNorm = mean2((img-offsetIMG299)/5.44);
            data(i).imgSTDNorm = std2((img-offsetIMG299)/5.44);
            data(i).rMeanNorm = mean2((r-offsetR299)/5.44);
            data(i).rSTDNorm = std2((r-offsetR299)/5.44);
            data(i).gMeanNorm = mean2((g-offsetG299)/5.44);
            data(i).gSTDNorm = std2((g-offsetG299)/5.44);
            data(i).bMeanNorm = mean2((b-offsetB299)/5.44);
            data(i).bSTDNorm = std2((b-offsetB299)/5.44);
            
            data(i).imgTLmeanNorm = mean2((data(i).imgTL-offsetTL299)/5.44);
            data(i).imgTMmeanNorm = mean2((data(i).imgTM-offsetIMG299)/5.44);
            data(i).imgLMmeanNorm = mean2((data(i).imgLM-offsetIMG299)/5.44);
            data(i).imgMmeanNorm = mean2((data(i).imgM-offsetM299)/5.44);

            data(i).imgTLstdNorm = std2((data(i).imgTL-offsetTL299)/5.44);
            data(i).imgTMstdNorm = std2((data(i).imgTM-offsetIMG299)/5.44);
            data(i).imgLMstdNorm = std2((data(i).imgLM-offsetIMG299)/5.44);
            data(i).imgMstdNorm = std2((data(i).imgM-offsetM299)/5.44);
        case 395
            data(i).imgMeanNorm = mean2((img-offsetIMG395)/7.18);
            data(i).imgSTDNorm = std2((img-offsetIMG395)/7.18);
            data(i).rMeanNorm = mean2((r-offsetR395)/7.18);
            data(i).rSTDNorm = std2((r-offsetR395)/7.18);
            data(i).gMeanNorm = mean2((g-offsetG395)/7.18);
            data(i).gSTDNorm = std2((g-offsetG395)/7.18);
            data(i).bMeanNorm = mean2((b-offsetB395)/7.18);
            data(i).bSTDNorm = std2((b-offsetB395)/7.18);
            
            data(i).imgTLmeanNorm = mean2((data(i).imgTL-offsetTL395)/7.18);
            data(i).imgTMmeanNorm = mean2((data(i).imgTM-offsetIMG395)/7.18);
            data(i).imgLMmeanNorm = mean2((data(i).imgLM-offsetIMG395)/7.18);
            data(i).imgMmeanNorm = mean2((data(i).imgM-offsetM395)/7.18);

            data(i).imgTLstdNorm = std2((data(i).imgTL-offsetTL395)/7.18);
            data(i).imgTMstdNorm = std2((data(i).imgTM-offsetIMG395)/7.18);
            data(i).imgLMstdNorm = std2((data(i).imgLM-offsetIMG395)/7.18);
            data(i).imgMstdNorm = std2((data(i).imgM-offsetM395)/7.18);
        case 798
            data(i).imgMeanNorm = mean2((img-offsetIMG798)/14.51);
            data(i).imgSTDNorm = std2((img-offsetIMG798)/14.51);
            data(i).rMeanNorm = mean2((r-offsetR798)/14.51);
            data(i).rSTDNorm = std2((r-offsetR798)/14.51);
            data(i).gMeanNorm = mean2((g-offsetG798)/14.51);
            data(i).gSTDNorm = std2((g-offsetG798)/14.51);
            data(i).bMeanNorm = mean2((b-offsetB798)/14.51);
            data(i).bSTDNorm = std2((b-offsetB798)/14.51);
            
            data(i).imgTLmeanNorm = mean2((data(i).imgTL-offsetTL798)/14.51);
            data(i).imgTMmeanNorm = mean2((data(i).imgTM-offsetIMG798)/14.51);
            data(i).imgLMmeanNorm = mean2((data(i).imgLM-offsetIMG798)/14.51);
            data(i).imgMmeanNorm = mean2((data(i).imgM-offsetM798)/14.51);

            data(i).imgTLstdNorm = std2((data(i).imgTL-offsetTL798)/14.51);
            data(i).imgTMstdNorm = std2((data(i).imgTM-offsetIMG798)/14.51);
            data(i).imgLMstdNorm = std2((data(i).imgLM-offsetIMG798)/14.51);
            data(i).imgMstdNorm = std2((data(i).imgM-offsetM798)/14.51);
%         case 1598
%             data(i).imgMeanNorm = mean2(img/35.29);
%             data(i).imgSTDNorm = std2(img/35.29);
%         case 3199
%             data(i).imgMeanNorm = mean2(img/58.164);
%             data(i).imgSTDNorm = std2(img/58.164);
   end
   str = strcat('IMG Processed: ', strcat(' ', string(i)), ' out of  ', strcat(' ', string(length(files))));
   disp(str)
end

disp('Preparing the Structures..')
% Bin the data based on uniqure isoSpeed settings
for i=1:length(data)
% This file is checked into the repository, so we use it as an example
    switch data(i).isoSpeed
        case 55
            data_55(i) = data(i);
        case 99
            data_99(i) = data(i);
        case 198
            data_198(i) = data(i);
        case 299
            data_299(i) = data(i);
        case 395
            data_395(i) = data(i);
        case 798
            data_798(i) = data(i);
%         case 1598
%             data_1598(i) = data(i);
%         case 3199
%             data_3199(i) = data(i);
    end
end

% Remove empty rows from the structures
data_55 = data_55(all(~cellfun(@isempty,struct2cell(data_55))));
data_99 = data_99(all(~cellfun(@isempty,struct2cell(data_99))));
data_198 = data_198(all(~cellfun(@isempty,struct2cell(data_198))));
data_299 = data_299(all(~cellfun(@isempty,struct2cell(data_299))));
data_395 = data_395(all(~cellfun(@isempty,struct2cell(data_395))));
data_798 = data_798(all(~cellfun(@isempty,struct2cell(data_798))));

% Create sorted table and structures of the data binned by isoSpeed
T = struct2table(data_55); % convert the struct array to a table
data_55T = sortrows(T, 'exposureTime'); % sort the table by 'exposureTime'
data_55S = table2struct(data_55T); % change it back to struct array if necessary

T = struct2table(data_99); % convert the struct array to a table
data_99T = sortrows(T, 'exposureTime'); % sort the table by 'exposureTime'
data_99S = table2struct(data_99T); % change it back to struct array if necessary

T = struct2table(data_198); % convert the struct array to a table
data_198T = sortrows(T, 'exposureTime'); % sort the table by 'exposureTime'
data_198S = table2struct(data_198T); % change it back to struct array if necessary

T = struct2table(data_299); % convert the struct array to a table
data_299T = sortrows(T, 'exposureTime'); % sort the table by 'exposureTime'
data_299S = table2struct(data_299T); % change it back to struct array if necessary

T = struct2table(data_395); % convert the struct array to a table
data_395T = sortrows(T, 'exposureTime'); % sort the table by 'exposureTime'
data_395S = table2struct(data_395T); % change it back to struct array if necessary

T = struct2table(data_798); % convert the struct array to a table
data_798T = sortrows(T, 'exposureTime'); % sort the table by 'exposureTime'
data_798S = table2struct(data_798T); % change it back to struct array if necessary

% AVERAGE ROUTINE
 j = 1;
 for i = 1:5:length(data_55T.exposureTime)
     x1 = data_55S(i);
     x2 = data_55S(i+1);
     x3 = data_55S(i+2);
     x4 = data_55S(i+3);
     x5 = data_55S(i+4);
     
     data_55S_avg(j).imgMean = (x1.imgMean + x2.imgMean + x3.imgMean + x4.imgMean  + x5.imgMean)/5;
     data_55S_avg(j).exposureTime = (x1.exposureTime + x2.exposureTime + x3.exposureTime + x4.exposureTime  + x5.exposureTime)/5;
     data_55S_avg(j).imgMeanNorm = (x1.imgMeanNorm + x2.imgMeanNorm + x3.imgMeanNorm + x4.imgMeanNorm  + x5.imgMeanNorm)/5;
     data_55S_avg(j).exposureTime = (x1.exposureTime + x2.exposureTime + x3.exposureTime + x4.exposureTime  + x5.exposureTime)/5;
     
     
     data_55S_avg(j).rMean = (x1.rMean + x2.rMean + x3.rMean + x4.rMean  + x5.rMean)/5;
     data_55S_avg(j).gMean = (x1.gMean + x2.gMean + x3.gMean + x4.gMean  + x5.gMean)/5;
     data_55S_avg(j).bMean = (x1.bMean + x2.bMean + x3.bMean + x4.bMean  + x5.bMean)/5;
     
     
     data_55S_avg(j).rMeanNorm = (x1.rMeanNorm + x2.rMeanNorm + x3.rMeanNorm + x4.rMeanNorm  + x5.rMeanNorm)/5;
     data_55S_avg(j).gMeanNorm = (x1.gMeanNorm + x2.gMeanNorm + x3.gMeanNorm + x4.gMeanNorm  + x5.gMeanNorm)/5;
     data_55S_avg(j).bMeanNorm = (x1.bMeanNorm + x2.bMeanNorm + x3.bMeanNorm + x4.bMeanNorm  + x5.bMeanNorm)/5;
     
     data_55S_avg(j).imgTLmean = (x1.imgTLmean + x2.imgTLmean + x3.imgTLmean + x4.imgTLmean  + x5.imgTLmean)/5;
     data_55S_avg(j).imgTMmean = (x1.imgTMmean  + x2.imgTMmean  + x3.imgTMmean  + x4.imgTMmean   + x5.imgTMmean )/5;
     data_55S_avg(j).imgLMmean = (x1.imgLMmean + x2.imgLMmean + x3.imgLMmean + x4.imgLMmean  + x5.imgLMmean)/5;
     data_55S_avg(j).imgMmean = (x1.imgMmean + x2.imgMmean + x3.imgMmean + x4.imgMmean  + x5.imgMmean)/5;

     data_55S_avg(j).imgTLmeanNorm = (x1.imgTLmeanNorm + x2.imgTLmeanNorm + x3.imgTLmeanNorm + x4.imgTLmeanNorm  + x5.imgTLmeanNorm)/5;
     data_55S_avg(j).imgTMmeanNorm = (x1.imgTMmeanNorm  + x2.imgTMmeanNorm  + x3.imgTMmeanNorm  + x4.imgTMmeanNorm   + x5.imgTMmeanNorm )/5;
     data_55S_avg(j).imgLMmeanNorm = (x1.imgLMmeanNorm + x2.imgLMmeanNorm + x3.imgLMmeanNorm + x4.imgLMmeanNorm  + x5.imgLMmeanNorm)/5;
     data_55S_avg(j).imgMmeanNorm = (x1.imgMmeanNorm + x2.imgMmeanNorm + x3.imgMmeanNorm + x4.imgMmeanNorm  + x5.imgMmeanNorm)/5;

     data_55S_avg(j).imgSTD = (x1.imgSTD + x2.imgSTD + x3.imgSTD + x4.imgSTD  + x5.imgSTD)/5;
     data_55S_avg(j).imgSTDNorm = (x1.imgSTDNorm + x2.imgSTDNorm + x3.imgSTDNorm + x4.imgSTDNorm  + x5.imgSTDNorm)/5;
     
     data_55S_avg(j).rSTD = (x1.rSTD + x2.rSTD + x3.rSTD + x4.rSTD  + x5.rSTD)/5;
     data_55S_avg(j).gSTD = (x1.gSTD + x2.gSTD + x3.gSTD + x4.gSTD  + x5.gSTD)/5;
     data_55S_avg(j).bSTD = (x1.bSTD + x2.bSTD + x3.bSTD + x4.bSTD  + x5.bSTD)/5;
     data_55S_avg(j).rSTDNorm = (x1.rSTDNorm + x2.rSTDNorm + x3.rSTDNorm + x4.rSTDNorm  + x5.rSTDNorm)/5;
     data_55S_avg(j).gSTDNorm = (x1.gSTDNorm + x2.gSTDNorm + x3.gSTDNorm + x4.gSTDNorm  + x5.gSTDNorm)/5;
     data_55S_avg(j).bSTDNorm = (x1.bSTDNorm + x2.bSTDNorm + x3.bSTDNorm + x4.bSTDNorm  + x5.bSTDNorm)/5;
     
     data_55S_avg(j).imgTLstd = (x1.imgTLstd + x2.imgTLstd + x3.imgTLstd + x4.imgTLstd  + x5.imgTLstd)/5;
     data_55S_avg(j).imgTMstd = (x1.imgTMstd  + x2.imgTMstd  + x3.imgTMstd  + x4.imgTMstd   + x5.imgTMstd)/5;
     data_55S_avg(j).imgLMstd = (x1.imgLMstd + x2.imgLMstd + x3.imgLMstd + x4.imgLMstd  + x5.imgLMstd)/5;
     data_55S_avg(j).imgMstd = (x1.imgMstd + x2.imgMstd + x3.imgMstd + x4.imgMstd  + x5.imgMstd)/5;

     data_55S_avg(j).imgTLstdNorm = (x1.imgTLstdNorm + x2.imgTLstdNorm + x3.imgTLstdNorm + x4.imgTLstdNorm  + x5.imgTLstdNorm)/5;
     data_55S_avg(j).imgTMstdNorm = (x1.imgTMstdNorm  + x2.imgTMstdNorm  + x3.imgTMstdNorm  + x4.imgTMstdNorm   + x5.imgTMstdNorm )/5;
     data_55S_avg(j).imgLMstdNorm = (x1.imgLMstdNorm + x2.imgLMstdNorm + x3.imgLMstdNorm + x4.imgLMstdNorm  + x5.imgLMstdNorm)/5;
     data_55S_avg(j).imgMstdNorm = (x1.imgMstdNorm + x2.imgMstdNorm + x3.imgMstdNorm + x4.imgMstdNorm  + x5.imgMstdNorm)/5;
     
     j = j + 1;  
 end
 
 j = 1;
 for i = 1:5:length(data_99T.exposureTime)
     x1 = data_99S(i);
     x2 = data_99S(i+1);
     x3 = data_99S(i+2);
     x4 = data_99S(i+3);
     x5 = data_99S(i+4);
     
     data_99S_avg(j).imgMean = (x1.imgMean + x2.imgMean + x3.imgMean + x4.imgMean  + x5.imgMean)/5;
     data_99S_avg(j).exposureTime = (x1.exposureTime + x2.exposureTime + x3.exposureTime + x4.exposureTime  + x5.exposureTime)/5;
     data_99S_avg(j).imgMeanNorm = (x1.imgMeanNorm + x2.imgMeanNorm + x3.imgMeanNorm + x4.imgMeanNorm  + x5.imgMeanNorm)/5;
     data_99S_avg(j).exposureTime = (x1.exposureTime + x2.exposureTime + x3.exposureTime + x4.exposureTime  + x5.exposureTime)/5;
     
     data_99S_avg(j).rMean = (x1.rMean + x2.rMean + x3.rMean + x4.rMean  + x5.rMean)/5;
     data_99S_avg(j).gMean = (x1.gMean + x2.gMean + x3.gMean + x4.gMean  + x5.gMean)/5;
     data_99S_avg(j).bMean = (x1.bMean + x2.bMean + x3.bMean + x4.bMean  + x5.bMean)/5;     

     data_99S_avg(j).rMeanNorm = (x1.rMeanNorm + x2.rMeanNorm + x3.rMeanNorm + x4.rMeanNorm  + x5.rMeanNorm)/5;
     data_99S_avg(j).gMeanNorm = (x1.gMeanNorm + x2.gMeanNorm + x3.gMeanNorm + x4.gMeanNorm  + x5.gMeanNorm)/5;
     data_99S_avg(j).bMeanNorm = (x1.bMeanNorm + x2.bMeanNorm + x3.bMeanNorm + x4.bMeanNorm  + x5.bMeanNorm)/5;
     
     data_99S_avg(j).imgTLmean = (x1.imgTLmean + x2.imgTLmean + x3.imgTLmean + x4.imgTLmean  + x5.imgTLmean)/5;
     data_99S_avg(j).imgTMmean = (x1.imgTMmean  + x2.imgTMmean  + x3.imgTMmean  + x4.imgTMmean   + x5.imgTMmean )/5;
     data_99S_avg(j).imgLMmean = (x1.imgLMmean + x2.imgLMmean + x3.imgLMmean + x4.imgLMmean  + x5.imgLMmean)/5;
     data_99S_avg(j).imgMmean = (x1.imgMmean + x2.imgMmean + x3.imgMmean + x4.imgMmean  + x5.imgMmean)/5;
     
     data_99S_avg(j).imgTLmeanNorm = (x1.imgTLmeanNorm + x2.imgTLmeanNorm + x3.imgTLmeanNorm + x4.imgTLmeanNorm  + x5.imgTLmeanNorm)/5;
     data_99S_avg(j).imgTMmeanNorm = (x1.imgTMmeanNorm  + x2.imgTMmeanNorm  + x3.imgTMmeanNorm  + x4.imgTMmeanNorm   + x5.imgTMmeanNorm )/5;
     data_99S_avg(j).imgLMmeanNorm = (x1.imgLMmeanNorm + x2.imgLMmeanNorm + x3.imgLMmeanNorm + x4.imgLMmeanNorm  + x5.imgLMmeanNorm)/5;
     data_99S_avg(j).imgMmeanNorm = (x1.imgMmeanNorm + x2.imgMmeanNorm + x3.imgMmeanNorm + x4.imgMmeanNorm  + x5.imgMmeanNorm)/5;     
     
     data_99S_avg(j).imgSTD = (x1.imgSTD + x2.imgSTD + x3.imgSTD + x4.imgSTD  + x5.imgSTD)/5;
     data_99S_avg(j).imgSTDNorm = (x1.imgSTDNorm + x2.imgSTDNorm + x3.imgSTDNorm + x4.imgSTDNorm  + x5.imgSTDNorm)/5;
     
     data_99S_avg(j).rSTD = (x1.rSTD + x2.rSTD + x3.rSTD + x4.rSTD  + x5.rSTD)/5;
     data_99S_avg(j).gSTD = (x1.gSTD + x2.gSTD + x3.gSTD + x4.gSTD  + x5.gSTD)/5;
     data_99S_avg(j).bSTD = (x1.bSTD + x2.bSTD + x3.bSTD + x4.bSTD  + x5.bSTD)/5;
     data_99S_avg(j).rSTDNorm = (x1.rSTDNorm + x2.rSTDNorm + x3.rSTDNorm + x4.rSTDNorm  + x5.rSTDNorm)/5;
     data_99S_avg(j).gSTDNorm = (x1.gSTDNorm + x2.gSTDNorm + x3.gSTDNorm + x4.gSTDNorm  + x5.gSTDNorm)/5;
     data_99S_avg(j).bSTDNorm = (x1.bSTDNorm + x2.bSTDNorm + x3.bSTDNorm + x4.bSTDNorm  + x5.bSTDNorm)/5;
     
     data_99S_avg(j).imgTLstd = (x1.imgTLstd + x2.imgTLstd + x3.imgTLstd + x4.imgTLstd  + x5.imgTLstd)/5;
     data_99S_avg(j).imgTMstd = (x1.imgTMstd  + x2.imgTMstd  + x3.imgTMstd  + x4.imgTMstd   + x5.imgTMstd)/5;
     data_99S_avg(j).imgLMstd = (x1.imgLMstd + x2.imgLMstd + x3.imgLMstd + x4.imgLMstd  + x5.imgLMstd)/5;
     data_99S_avg(j).imgMstd = (x1.imgMstd + x2.imgMstd + x3.imgMstd + x4.imgMstd  + x5.imgMstd)/5;

     data_99S_avg(j).imgTLstdNorm = (x1.imgTLstdNorm + x2.imgTLstdNorm + x3.imgTLstdNorm + x4.imgTLstdNorm  + x5.imgTLstdNorm)/5;
     data_99S_avg(j).imgTMstdNorm = (x1.imgTMstdNorm  + x2.imgTMstdNorm  + x3.imgTMstdNorm  + x4.imgTMstdNorm   + x5.imgTMstdNorm )/5;
     data_99S_avg(j).imgLMstdNorm = (x1.imgLMstdNorm + x2.imgLMstdNorm + x3.imgLMstdNorm + x4.imgLMstdNorm  + x5.imgLMstdNorm)/5;
     data_99S_avg(j).imgMstdNorm = (x1.imgMstdNorm + x2.imgMstdNorm + x3.imgMstdNorm + x4.imgMstdNorm  + x5.imgMstdNorm)/5;
     
     j = j + 1;  
 end
 
 j = 1;
 for i = 1:5:length(data_198T.exposureTime)
     x1 = data_198S(i);
     x2 = data_198S(i+1);
     x3 = data_198S(i+2);
     x4 = data_198S(i+3);
     x5 = data_198S(i+4);
     
     data_198S_avg(j).imgMean = (x1.imgMean + x2.imgMean + x3.imgMean + x4.imgMean  + x5.imgMean)/5;
     data_198S_avg(j).exposureTime = (x1.exposureTime + x2.exposureTime + x3.exposureTime + x4.exposureTime  + x5.exposureTime)/5;
     data_198S_avg(j).imgMeanNorm = (x1.imgMeanNorm + x2.imgMeanNorm + x3.imgMeanNorm + x4.imgMeanNorm  + x5.imgMeanNorm)/5;
     data_198S_avg(j).exposureTime = (x1.exposureTime + x2.exposureTime + x3.exposureTime + x4.exposureTime  + x5.exposureTime)/5;
     
     data_198S_avg(j).rMean = (x1.rMean + x2.rMean + x3.rMean + x4.rMean  + x5.rMean)/5;
     data_198S_avg(j).gMean = (x1.gMean + x2.gMean + x3.gMean + x4.gMean  + x5.gMean)/5;
     data_198S_avg(j).bMean = (x1.bMean + x2.bMean + x3.bMean + x4.bMean  + x5.bMean)/5;        
     
     data_198S_avg(j).rMeanNorm = (x1.rMeanNorm + x2.rMeanNorm + x3.rMeanNorm + x4.rMeanNorm  + x5.rMeanNorm)/5;
     data_198S_avg(j).gMeanNorm = (x1.gMeanNorm + x2.gMeanNorm + x3.gMeanNorm + x4.gMeanNorm  + x5.gMeanNorm)/5;
     data_198S_avg(j).bMeanNorm = (x1.bMeanNorm + x2.bMeanNorm + x3.bMeanNorm + x4.bMeanNorm  + x5.bMeanNorm)/5;
     
     data_198S_avg(j).imgTLmean = (x1.imgTLmean + x2.imgTLmean + x3.imgTLmean + x4.imgTLmean  + x5.imgTLmean)/5;
     data_198S_avg(j).imgTMmean = (x1.imgTMmean  + x2.imgTMmean  + x3.imgTMmean  + x4.imgTMmean   + x5.imgTMmean )/5;
     data_198S_avg(j).imgLMmean = (x1.imgLMmean + x2.imgLMmean + x3.imgLMmean + x4.imgLMmean  + x5.imgLMmean)/5;
     data_198S_avg(j).imgMmean = (x1.imgMmean + x2.imgMmean + x3.imgMmean + x4.imgMmean  + x5.imgMmean)/5;
     
     data_198S_avg(j).imgTLmeanNorm = (x1.imgTLmeanNorm + x2.imgTLmeanNorm + x3.imgTLmeanNorm + x4.imgTLmeanNorm  + x5.imgTLmeanNorm)/5;
     data_198S_avg(j).imgTMmeanNorm = (x1.imgTMmeanNorm  + x2.imgTMmeanNorm  + x3.imgTMmeanNorm  + x4.imgTMmeanNorm   + x5.imgTMmeanNorm )/5;
     data_198S_avg(j).imgLMmeanNorm = (x1.imgLMmeanNorm + x2.imgLMmeanNorm + x3.imgLMmeanNorm + x4.imgLMmeanNorm  + x5.imgLMmeanNorm)/5;
     data_198S_avg(j).imgMmeanNorm = (x1.imgMmeanNorm + x2.imgMmeanNorm + x3.imgMmeanNorm + x4.imgMmeanNorm  + x5.imgMmeanNorm)/5;     
     
     data_198S_avg(j).imgSTD = (x1.imgSTD + x2.imgSTD + x3.imgSTD + x4.imgSTD  + x5.imgSTD)/5;
     data_198S_avg(j).imgSTDNorm = (x1.imgSTDNorm + x2.imgSTDNorm + x3.imgSTDNorm + x4.imgSTDNorm  + x5.imgSTDNorm)/5;
     
     data_198S_avg(j).rSTD = (x1.rSTD + x2.rSTD + x3.rSTD + x4.rSTD  + x5.rSTD)/5;
     data_198S_avg(j).gSTD = (x1.gSTD + x2.gSTD + x3.gSTD + x4.gSTD  + x5.gSTD)/5;
     data_198S_avg(j).bSTD = (x1.bSTD + x2.bSTD + x3.bSTD + x4.bSTD  + x5.bSTD)/5;
     data_198S_avg(j).rSTDNorm = (x1.rSTDNorm + x2.rSTDNorm + x3.rSTDNorm + x4.rSTDNorm  + x5.rSTDNorm)/5;
     data_198S_avg(j).gSTDNorm = (x1.gSTDNorm + x2.gSTDNorm + x3.gSTDNorm + x4.gSTDNorm  + x5.gSTDNorm)/5;
     data_198S_avg(j).bSTDNorm = (x1.bSTDNorm + x2.bSTDNorm + x3.bSTDNorm + x4.bSTDNorm  + x5.bSTDNorm)/5;
     
     data_198S_avg(j).imgTLstd = (x1.imgTLstd + x2.imgTLstd + x3.imgTLstd + x4.imgTLstd  + x5.imgTLstd)/5;
     data_198S_avg(j).imgTMstd = (x1.imgTMstd  + x2.imgTMstd  + x3.imgTMstd  + x4.imgTMstd   + x5.imgTMstd)/5;
     data_198S_avg(j).imgLMstd = (x1.imgLMstd + x2.imgLMstd + x3.imgLMstd + x4.imgLMstd  + x5.imgLMstd)/5;
     data_198S_avg(j).imgMstd = (x1.imgMstd + x2.imgMstd + x3.imgMstd + x4.imgMstd  + x5.imgMstd)/5;

     data_198S_avg(j).imgTLstdNorm = (x1.imgTLstdNorm + x2.imgTLstdNorm + x3.imgTLstdNorm + x4.imgTLstdNorm  + x5.imgTLstdNorm)/5;
     data_198S_avg(j).imgTMstdNorm = (x1.imgTMstdNorm  + x2.imgTMstdNorm  + x3.imgTMstdNorm  + x4.imgTMstdNorm   + x5.imgTMstdNorm )/5;
     data_198S_avg(j).imgLMstdNorm = (x1.imgLMstdNorm + x2.imgLMstdNorm + x3.imgLMstdNorm + x4.imgLMstdNorm  + x5.imgLMstdNorm)/5;
     data_198S_avg(j).imgMstdNorm = (x1.imgMstdNorm + x2.imgMstdNorm + x3.imgMstdNorm + x4.imgMstdNorm  + x5.imgMstdNorm)/5;
     
     j = j + 1;  
 end
 
 j = 1;
 for i = 1:5:length(data_299T.exposureTime)
     x1 = data_299S(i);
     x2 = data_299S(i+1);
     x3 = data_299S(i+2);
     x4 = data_299S(i+3);
     x5 = data_299S(i+4);
     
     data_299S_avg(j).imgMean = (x1.imgMean + x2.imgMean + x3.imgMean + x4.imgMean  + x5.imgMean)/5;
     data_299S_avg(j).exposureTime = (x1.exposureTime + x2.exposureTime + x3.exposureTime + x4.exposureTime  + x5.exposureTime)/5;
     data_299S_avg(j).imgMeanNorm = (x1.imgMeanNorm + x2.imgMeanNorm + x3.imgMeanNorm + x4.imgMeanNorm  + x5.imgMeanNorm)/5;
     data_299S_avg(j).exposureTime = (x1.exposureTime + x2.exposureTime + x3.exposureTime + x4.exposureTime  + x5.exposureTime)/5;
     
     data_299S_avg(j).rMean = (x1.rMean + x2.rMean + x3.rMean + x4.rMean  + x5.rMean)/5;
     data_299S_avg(j).gMean = (x1.gMean + x2.gMean + x3.gMean + x4.gMean  + x5.gMean)/5;
     data_299S_avg(j).bMean = (x1.bMean + x2.bMean + x3.bMean + x4.bMean  + x5.bMean)/5;           
     
     data_299S_avg(j).rMeanNorm = (x1.rMeanNorm + x2.rMeanNorm + x3.rMeanNorm + x4.rMeanNorm  + x5.rMeanNorm)/5;
     data_299S_avg(j).gMeanNorm = (x1.gMeanNorm + x2.gMeanNorm + x3.gMeanNorm + x4.gMeanNorm  + x5.gMeanNorm)/5;
     data_299S_avg(j).bMeanNorm = (x1.bMeanNorm + x2.bMeanNorm + x3.bMeanNorm + x4.bMeanNorm  + x5.bMeanNorm)/5;
     
     data_299S_avg(j).imgTLmean = (x1.imgTLmean + x2.imgTLmean + x3.imgTLmean + x4.imgTLmean  + x5.imgTLmean)/5;
     data_299S_avg(j).imgTMmean = (x1.imgTMmean  + x2.imgTMmean  + x3.imgTMmean  + x4.imgTMmean   + x5.imgTMmean )/5;
     data_299S_avg(j).imgLMmean = (x1.imgLMmean + x2.imgLMmean + x3.imgLMmean + x4.imgLMmean  + x5.imgLMmean)/5;
     data_299S_avg(j).imgMmean = (x1.imgMmean + x2.imgMmean + x3.imgMmean + x4.imgMmean  + x5.imgMmean)/5;
     
     data_299S_avg(j).imgTLmeanNorm = (x1.imgTLmeanNorm + x2.imgTLmeanNorm + x3.imgTLmeanNorm + x4.imgTLmeanNorm  + x5.imgTLmeanNorm)/5;
     data_299S_avg(j).imgTMmeanNorm = (x1.imgTMmeanNorm  + x2.imgTMmeanNorm  + x3.imgTMmeanNorm  + x4.imgTMmeanNorm   + x5.imgTMmeanNorm )/5;
     data_299S_avg(j).imgLMmeanNorm = (x1.imgLMmeanNorm + x2.imgLMmeanNorm + x3.imgLMmeanNorm + x4.imgLMmeanNorm  + x5.imgLMmeanNorm)/5;
     data_299S_avg(j).imgMmeanNorm = (x1.imgMmeanNorm + x2.imgMmeanNorm + x3.imgMmeanNorm + x4.imgMmeanNorm  + x5.imgMmeanNorm)/5;     
     
     data_299S_avg(j).imgSTD = (x1.imgSTD + x2.imgSTD + x3.imgSTD + x4.imgSTD  + x5.imgSTD)/5;
     data_299S_avg(j).imgSTDNorm = (x1.imgSTDNorm + x2.imgSTDNorm + x3.imgSTDNorm + x4.imgSTDNorm  + x5.imgSTDNorm)/5;
     
     data_299S_avg(j).rSTD = (x1.rSTD + x2.rSTD + x3.rSTD + x4.rSTD  + x5.rSTD)/5;
     data_299S_avg(j).gSTD = (x1.gSTD + x2.gSTD + x3.gSTD + x4.gSTD  + x5.gSTD)/5;
     data_299S_avg(j).bSTD = (x1.bSTD + x2.bSTD + x3.bSTD + x4.bSTD  + x5.bSTD)/5;
     data_299S_avg(j).rSTDNorm = (x1.rSTDNorm + x2.rSTDNorm + x3.rSTDNorm + x4.rSTDNorm  + x5.rSTDNorm)/5;
     data_299S_avg(j).gSTDNorm = (x1.gSTDNorm + x2.gSTDNorm + x3.gSTDNorm + x4.gSTDNorm  + x5.gSTDNorm)/5;
     data_299S_avg(j).bSTDNorm = (x1.bSTDNorm + x2.bSTDNorm + x3.bSTDNorm + x4.bSTDNorm  + x5.bSTDNorm)/5;
     
     data_299S_avg(j).imgTLstd = (x1.imgTLstd + x2.imgTLstd + x3.imgTLstd + x4.imgTLstd  + x5.imgTLstd)/5;
     data_299S_avg(j).imgTMstd = (x1.imgTMstd  + x2.imgTMstd  + x3.imgTMstd  + x4.imgTMstd   + x5.imgTMstd)/5;
     data_299S_avg(j).imgLMstd = (x1.imgLMstd + x2.imgLMstd + x3.imgLMstd + x4.imgLMstd  + x5.imgLMstd)/5;
     data_299S_avg(j).imgMstd = (x1.imgMstd + x2.imgMstd + x3.imgMstd + x4.imgMstd  + x5.imgMstd)/5;

     data_299S_avg(j).imgTLstdNorm = (x1.imgTLstdNorm + x2.imgTLstdNorm + x3.imgTLstdNorm + x4.imgTLstdNorm  + x5.imgTLstdNorm)/5;
     data_299S_avg(j).imgTMstdNorm = (x1.imgTMstdNorm  + x2.imgTMstdNorm  + x3.imgTMstdNorm  + x4.imgTMstdNorm   + x5.imgTMstdNorm )/5;
     data_299S_avg(j).imgLMstdNorm = (x1.imgLMstdNorm + x2.imgLMstdNorm + x3.imgLMstdNorm + x4.imgLMstdNorm  + x5.imgLMstdNorm)/5;
     data_299S_avg(j).imgMstdNorm = (x1.imgMstdNorm + x2.imgMstdNorm + x3.imgMstdNorm + x4.imgMstdNorm  + x5.imgMstdNorm)/5;
     
     j = j + 1;  
 end
 
 j = 1;
 for i = 1:5:length(data_395T.exposureTime)
     x1 = data_395S(i);
     x2 = data_395S(i+1);
     x3 = data_395S(i+2);
     x4 = data_395S(i+3);
     x5 = data_395S(i+4);
     
     data_395S_avg(j).imgMean = (x1.imgMean + x2.imgMean + x3.imgMean + x4.imgMean  + x5.imgMean)/5;
     data_395S_avg(j).exposureTime = (x1.exposureTime + x2.exposureTime + x3.exposureTime + x4.exposureTime  + x5.exposureTime)/5;
     data_395S_avg(j).imgMeanNorm = (x1.imgMeanNorm + x2.imgMeanNorm + x3.imgMeanNorm + x4.imgMeanNorm  + x5.imgMeanNorm)/5;
     data_395S_avg(j).exposureTime = (x1.exposureTime + x2.exposureTime + x3.exposureTime + x4.exposureTime  + x5.exposureTime)/5;
     
     data_395S_avg(j).rMean = (x1.rMean + x2.rMean + x3.rMean + x4.rMean  + x5.rMean)/5;
     data_395S_avg(j).gMean = (x1.gMean + x2.gMean + x3.gMean + x4.gMean  + x5.gMean)/5;
     data_395S_avg(j).bMean = (x1.bMean + x2.bMean + x3.bMean + x4.bMean  + x5.bMean)/5;         
     
     data_395S_avg(j).rMeanNorm = (x1.rMeanNorm + x2.rMeanNorm + x3.rMeanNorm + x4.rMeanNorm  + x5.rMeanNorm)/5;
     data_395S_avg(j).gMeanNorm = (x1.gMeanNorm + x2.gMeanNorm + x3.gMeanNorm + x4.gMeanNorm  + x5.gMeanNorm)/5;
     data_395S_avg(j).bMeanNorm = (x1.bMeanNorm + x2.bMeanNorm + x3.bMeanNorm + x4.bMeanNorm  + x5.bMeanNorm)/5;
     
     data_395S_avg(j).imgTLmean = (x1.imgTLmean + x2.imgTLmean + x3.imgTLmean + x4.imgTLmean  + x5.imgTLmean)/5;
     data_395S_avg(j).imgTMmean = (x1.imgTMmean  + x2.imgTMmean  + x3.imgTMmean  + x4.imgTMmean   + x5.imgTMmean )/5;
     data_395S_avg(j).imgLMmean = (x1.imgLMmean + x2.imgLMmean + x3.imgLMmean + x4.imgLMmean  + x5.imgLMmean)/5;
     data_395S_avg(j).imgMmean = (x1.imgMmean + x2.imgMmean + x3.imgMmean + x4.imgMmean  + x5.imgMmean)/5;
     
     data_395S_avg(j).imgTLmeanNorm = (x1.imgTLmeanNorm + x2.imgTLmeanNorm + x3.imgTLmeanNorm + x4.imgTLmeanNorm  + x5.imgTLmeanNorm)/5;
     data_395S_avg(j).imgTMmeanNorm = (x1.imgTMmeanNorm  + x2.imgTMmeanNorm  + x3.imgTMmeanNorm  + x4.imgTMmeanNorm   + x5.imgTMmeanNorm )/5;
     data_395S_avg(j).imgLMmeanNorm = (x1.imgLMmeanNorm + x2.imgLMmeanNorm + x3.imgLMmeanNorm + x4.imgLMmeanNorm  + x5.imgLMmeanNorm)/5;
     data_395S_avg(j).imgMmeanNorm = (x1.imgMmeanNorm + x2.imgMmeanNorm + x3.imgMmeanNorm + x4.imgMmeanNorm  + x5.imgMmeanNorm)/5;    
     
     data_395S_avg(j).imgSTD = (x1.imgSTD + x2.imgSTD + x3.imgSTD + x4.imgSTD  + x5.imgSTD)/5;
     data_395S_avg(j).imgSTDNorm = (x1.imgSTDNorm + x2.imgSTDNorm + x3.imgSTDNorm + x4.imgSTDNorm  + x5.imgSTDNorm)/5;
     
     data_395S_avg(j).rSTD = (x1.rSTD + x2.rSTD + x3.rSTD + x4.rSTD  + x5.rSTD)/5;
     data_395S_avg(j).gSTD = (x1.gSTD + x2.gSTD + x3.gSTD + x4.gSTD  + x5.gSTD)/5;
     data_395S_avg(j).bSTD = (x1.bSTD + x2.bSTD + x3.bSTD + x4.bSTD  + x5.bSTD)/5;
     data_395S_avg(j).rSTDNorm = (x1.rSTDNorm + x2.rSTDNorm + x3.rSTDNorm + x4.rSTDNorm  + x5.rSTDNorm)/5;
     data_395S_avg(j).gSTDNorm = (x1.gSTDNorm + x2.gSTDNorm + x3.gSTDNorm + x4.gSTDNorm  + x5.gSTDNorm)/5;
     data_395S_avg(j).bSTDNorm = (x1.bSTDNorm + x2.bSTDNorm + x3.bSTDNorm + x4.bSTDNorm  + x5.bSTDNorm)/5;
     
     data_395S_avg(j).imgTLstd = (x1.imgTLstd + x2.imgTLstd + x3.imgTLstd + x4.imgTLstd  + x5.imgTLstd)/5;
     data_395S_avg(j).imgTMstd = (x1.imgTMstd  + x2.imgTMstd  + x3.imgTMstd  + x4.imgTMstd   + x5.imgTMstd)/5;
     data_395S_avg(j).imgLMstd = (x1.imgLMstd + x2.imgLMstd + x3.imgLMstd + x4.imgLMstd  + x5.imgLMstd)/5;
     data_395S_avg(j).imgMstd = (x1.imgMstd + x2.imgMstd + x3.imgMstd + x4.imgMstd  + x5.imgMstd)/5;

     data_395S_avg(j).imgTLstdNorm = (x1.imgTLstdNorm + x2.imgTLstdNorm + x3.imgTLstdNorm + x4.imgTLstdNorm  + x5.imgTLstdNorm)/5;
     data_395S_avg(j).imgTMstdNorm = (x1.imgTMstdNorm  + x2.imgTMstdNorm  + x3.imgTMstdNorm  + x4.imgTMstdNorm   + x5.imgTMstdNorm )/5;
     data_395S_avg(j).imgLMstdNorm = (x1.imgLMstdNorm + x2.imgLMstdNorm + x3.imgLMstdNorm + x4.imgLMstdNorm  + x5.imgLMstdNorm)/5;
     data_395S_avg(j).imgMstdNorm = (x1.imgMstdNorm + x2.imgMstdNorm + x3.imgMstdNorm + x4.imgMstdNorm  + x5.imgMstdNorm)/5;
     
     j = j + 1;  
 end
 
 j = 1;
 for i = 1:5:length(data_798T.exposureTime)
     x1 = data_798S(i);
     x2 = data_798S(i+1);
     x3 = data_798S(i+2);
     x4 = data_798S(i+3);
     x5 = data_798S(i+4);
     
     data_798S_avg(j).imgMean = (x1.imgMean + x2.imgMean + x3.imgMean + x4.imgMean  + x5.imgMean)/5;
     data_798S_avg(j).exposureTime = (x1.exposureTime + x2.exposureTime + x3.exposureTime + x4.exposureTime  + x5.exposureTime)/5;
     data_798S_avg(j).imgMeanNorm = (x1.imgMeanNorm + x2.imgMeanNorm + x3.imgMeanNorm + x4.imgMeanNorm  + x5.imgMeanNorm)/5;
     data_798S_avg(j).exposureTime = (x1.exposureTime + x2.exposureTime + x3.exposureTime + x4.exposureTime  + x5.exposureTime)/5;
     
     data_798S_avg(j).rMean = (x1.rMean + x2.rMean + x3.rMean + x4.rMean  + x5.rMean)/5;
     data_798S_avg(j).gMean = (x1.gMean + x2.gMean + x3.gMean + x4.gMean  + x5.gMean)/5;
     data_798S_avg(j).bMean = (x1.bMean + x2.bMean + x3.bMean + x4.bMean  + x5.bMean)/5;        
     
     data_798S_avg(j).rMeanNorm = (x1.rMeanNorm + x2.rMeanNorm + x3.rMeanNorm + x4.rMeanNorm  + x5.rMeanNorm)/5;
     data_798S_avg(j).gMeanNorm = (x1.gMeanNorm + x2.gMeanNorm + x3.gMeanNorm + x4.gMeanNorm  + x5.gMeanNorm)/5;
     data_798S_avg(j).bMeanNorm = (x1.bMeanNorm + x2.bMeanNorm + x3.bMeanNorm + x4.bMeanNorm  + x5.bMeanNorm)/5;
        
     data_798S_avg(j).imgTLmean = (x1.imgTLmean + x2.imgTLmean + x3.imgTLmean + x4.imgTLmean  + x5.imgTLmean)/5;
     data_798S_avg(j).imgTMmean = (x1.imgTMmean  + x2.imgTMmean  + x3.imgTMmean  + x4.imgTMmean   + x5.imgTMmean )/5;
     data_798S_avg(j).imgLMmean = (x1.imgLMmean + x2.imgLMmean + x3.imgLMmean + x4.imgLMmean  + x5.imgLMmean)/5;
     data_798S_avg(j).imgMmean = (x1.imgMmean + x2.imgMmean + x3.imgMmean + x4.imgMmean  + x5.imgMmean)/5;
     
     data_798S_avg(j).imgTLmeanNorm = (x1.imgTLmeanNorm + x2.imgTLmeanNorm + x3.imgTLmeanNorm + x4.imgTLmeanNorm  + x5.imgTLmeanNorm)/5;
     data_798S_avg(j).imgTMmeanNorm = (x1.imgTMmeanNorm  + x2.imgTMmeanNorm  + x3.imgTMmeanNorm  + x4.imgTMmeanNorm   + x5.imgTMmeanNorm )/5;
     data_798S_avg(j).imgLMmeanNorm = (x1.imgLMmeanNorm + x2.imgLMmeanNorm + x3.imgLMmeanNorm + x4.imgLMmeanNorm  + x5.imgLMmeanNorm)/5;
     data_798S_avg(j).imgMmeanNorm = (x1.imgMmeanNorm + x2.imgMmeanNorm + x3.imgMmeanNorm + x4.imgMmeanNorm  + x5.imgMmeanNorm)/5;     
     
     data_798S_avg(j).imgSTD = (x1.imgSTD + x2.imgSTD + x3.imgSTD + x4.imgSTD  + x5.imgSTD)/5;
     data_798S_avg(j).imgSTDNorm = (x1.imgSTDNorm + x2.imgSTDNorm + x3.imgSTDNorm + x4.imgSTDNorm  + x5.imgSTDNorm)/5;
     
     data_798S_avg(j).rSTD = (x1.rSTD + x2.rSTD + x3.rSTD + x4.rSTD  + x5.rSTD)/5;
     data_798S_avg(j).gSTD = (x1.gSTD + x2.gSTD + x3.gSTD + x4.gSTD  + x5.gSTD)/5;
     data_798S_avg(j).bSTD = (x1.bSTD + x2.bSTD + x3.bSTD + x4.bSTD  + x5.bSTD)/5;
     data_798S_avg(j).rSTDNorm = (x1.rSTDNorm + x2.rSTDNorm + x3.rSTDNorm + x4.rSTDNorm  + x5.rSTDNorm)/5;
     data_798S_avg(j).gSTDNorm = (x1.gSTDNorm + x2.gSTDNorm + x3.gSTDNorm + x4.gSTDNorm  + x5.gSTDNorm)/5;
     data_798S_avg(j).bSTDNorm = (x1.bSTDNorm + x2.bSTDNorm + x3.bSTDNorm + x4.bSTDNorm  + x5.bSTDNorm)/5;
     
     data_798S_avg(j).imgTLstd = (x1.imgTLstd + x2.imgTLstd + x3.imgTLstd + x4.imgTLstd  + x5.imgTLstd)/5;
     data_798S_avg(j).imgTMstd = (x1.imgTMstd  + x2.imgTMstd  + x3.imgTMstd  + x4.imgTMstd   + x5.imgTMstd)/5;
     data_798S_avg(j).imgLMstd = (x1.imgLMstd + x2.imgLMstd + x3.imgLMstd + x4.imgLMstd  + x5.imgLMstd)/5;
     data_798S_avg(j).imgMstd = (x1.imgMstd + x2.imgMstd + x3.imgMstd + x4.imgMstd  + x5.imgMstd)/5;

     data_798S_avg(j).imgTLstdNorm = (x1.imgTLstdNorm + x2.imgTLstdNorm + x3.imgTLstdNorm + x4.imgTLstdNorm  + x5.imgTLstdNorm)/5;
     data_798S_avg(j).imgTMstdNorm = (x1.imgTMstdNorm  + x2.imgTMstdNorm  + x3.imgTMstdNorm  + x4.imgTMstdNorm   + x5.imgTMstdNorm )/5;
     data_798S_avg(j).imgLMstdNorm = (x1.imgLMstdNorm + x2.imgLMstdNorm + x3.imgLMstdNorm + x4.imgLMstdNorm  + x5.imgLMstdNorm)/5;
     data_798S_avg(j).imgMstdNorm = (x1.imgMstdNorm + x2.imgMstdNorm + x3.imgMstdNorm + x4.imgMstdNorm  + x5.imgMstdNorm)/5;
     
     j = j + 1;  
 end


disp('Saving Workspace Variables')
filename = 'PRNU_DSNU_Data.mat';
%filename = 'Z:\PRNU_DSNU_Data.mat';
%save(filename, 'data_55S','data_99S','data_198S', 'data_299S', 'data_395S', 'data_798S', '-v7.3'); 
save(filename, 'data_55S_avg','data_99S_avg','data_198S_avg', 'data_299S_avg', 'data_395S_avg', 'data_798S_avg', '-v7.3'); 


% Plot the data for each isoSpeed setting (Data is not normalized)
figure(1)
hold on
errorbar(data_55T.exposureTime, data_55T.imgMean, data_55T.imgSTD, 'DisplayName', '55')
errorbar(data_99T.exposureTime, data_99T.imgMean, data_99T.imgSTD, 'DisplayName', '99')
errorbar(data_198T.exposureTime, data_198T.imgMean, data_198T.imgSTD, 'DisplayName', '198')
errorbar(data_299T.exposureTime, data_299T.imgMean, data_299T.imgSTD, 'DisplayName', '299')
errorbar(data_395T.exposureTime, data_395T.imgMean, data_395T.imgSTD, 'DisplayName', '395')
errorbar(data_798T.exposureTime, data_798T.imgMean, data_798T.imgSTD, 'DisplayName', '798')
% errorbar(data_1598T.exposureTime, data_1598T.imgMean, data_1598T.imgSTD)
% errorbar(data_3199T.exposureTime, data_3199T.imgMean, data_3199T.imgSTD)
title('Exposure Time (s) vs. DN')
xlabel('Exposure Time (s)')
ylabel('Digital Number (16-bit FS)')
legend
%legend('55', '99', '198', '299', '395', '798')

% Plot the data for each isoSpeed setting (Data is normalized)
figure(2)
hold on
errorbar(data_55T.exposureTime, data_55T.imgMeanNorm, data_55T.imgSTDNorm, 'DisplayName', '55')
errorbar(data_99T.exposureTime, data_99T.imgMeanNorm, data_99T.imgSTDNorm, 'DisplayName', '99')
errorbar(data_198T.exposureTime, data_198T.imgMeanNorm, data_198T.imgSTDNorm, 'DisplayName', '198')
errorbar(data_299T.exposureTime, data_299T.imgMeanNorm, data_299T.imgSTDNorm, 'DisplayName', '299')
errorbar(data_395T.exposureTime, data_395T.imgMeanNorm, data_395T.imgSTDNorm, 'DisplayName', '395')
errorbar(data_798T.exposureTime, data_798T.imgMeanNorm, data_798T.imgSTDNorm, 'DisplayName', '798')
% errorbar(data_1598T.exposureTime, data_1598T.imgMeanNorm, data_1598T.imgSTDNorm)
%errorbar(data_3199T.exposureTime, data_3199T.imgMeanNorm, data_3199T.imgSTDNorm)
title('Exposure Time (s) vs. DN (Normalized)')
xlabel('Exposure Time (s)')
ylabel('Digital Number (16-bit FS)')
legend
%legend('55', '99', '198', '299', '395', '798')