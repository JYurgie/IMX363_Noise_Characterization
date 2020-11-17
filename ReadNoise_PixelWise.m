%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSYCH 221 : Google Pixel 4A Noise Model - DSNU and PRNU Noise Estimation
% Authors : Melissa Horowitz, Joey Yurgelon
% Date : 11/3/2020
% Required File Structure : 
%          See 'project/README.txt' - MATLAB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all 
close all
clc

img_path = "Camera_Noise/ReadNoise/ISO_*/";

% Load in all of the '.DNG' Files
disp('Loading in the DNG Files..')
files = dir(img_path + '*.dng');

i=0;
for i=1:length(files)
   files(i).name;
   [img, info] = ieDNGRead(files(i).name); % The image data and the header information
   info;
   data(i).img = img;
   data(i).imgMean = mean2(img);
   data(i).imgSTD = std2(img);
   data(i).isoSpeed = info.ISOSpeedRatings;
   data(i).exposureTime = info.ExposureTime;

   str = strcat('IMG Processed: ', strcat(' ', string(i)), ' out of  ', strcat(' ', string(length(files))));
   disp(str)
end

disp('Preparing the Structures..')
% Bin the data based on uniqure isoSpeed settings
i=0;
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
    end
end

clear data
clear img

% Remove empty rows from the structures
data_55 = data_55(all(~cellfun(@isempty,struct2cell(data_55))));
data_99 = data_99(all(~cellfun(@isempty,struct2cell(data_99))));
data_198 = data_198(all(~cellfun(@isempty,struct2cell(data_198))));
data_299 = data_299(all(~cellfun(@isempty,struct2cell(data_299))));
data_395 = data_395(all(~cellfun(@isempty,struct2cell(data_395))));
data_798 = data_798(all(~cellfun(@isempty,struct2cell(data_798))));

% Create sorted table and structures of the data binned by isoSpeed
T = struct2table(data_55); % convert the struct array to a table
data_55T_avg = sortrows(T, 'exposureTime'); % sort the table by 'exposureTime'
data_55S_avg = table2struct(data_55T_avg); % change it back to struct array if necessary

T = struct2table(data_99); % convert the struct array to a table
data_99T_avg = sortrows(T, 'exposureTime'); % sort the table by 'exposureTime'
data_99S_avg = table2struct(data_99T_avg); % change it back to struct array if necessary

T = struct2table(data_198); % convert the struct array to a table
data_198T_avg = sortrows(T, 'exposureTime'); % sort the table by 'exposureTime'
data_198S_avg = table2struct(data_198T_avg); % change it back to struct array if necessary

T = struct2table(data_299); % convert the struct array to a table
data_299T_avg = sortrows(T, 'exposureTime'); % sort the table by 'exposureTime'
data_299S_avg = table2struct(data_299T_avg); % change it back to struct array if necessary

T = struct2table(data_395); % convert the struct array to a table
data_395T_avg = sortrows(T, 'exposureTime'); % sort the table by 'exposureTime'
data_395S_avg = table2struct(data_395T_avg); % change it back to struct array if necessary

T = struct2table(data_798); % convert the struct array to a table
data_798T_avg = sortrows(T, 'exposureTime'); % sort the table by 'exposureTime'
data_798S_avg = table2struct(data_798T_avg); % change it back to struct array if necessary


 y=0; x=0;
 for y=1:length(data_55S_avg(1).img(1,:))
     for x=1:length(data_55S_avg(1).img(:,1))
         temp = double([data_55S_avg(1).img(x,y); data_55S_avg(2).img(x,y); data_55S_avg(3).img(x,y); data_55S_avg(4).img(x,y); data_55S_avg(5).img(x,y); data_55S_avg(6).img(x,y)]);
         result = polyfit(data_55T_avg.exposureTime, temp, 1);
         m_55(x,y) = result(1);
         b_55(x,y) = result(2);
         
         temp = double([data_99S_avg(1).img(x,y); data_99S_avg(2).img(x,y); data_99S_avg(3).img(x,y); data_99S_avg(4).img(x,y); data_99S_avg(5).img(x,y)]);
         result = polyfit(data_99T_avg.exposureTime, temp, 1);
         m_99(x,y) = result(1);
         b_99(x,y) = result(2);
                  
         temp = double([data_198S_avg(1).img(x,y); data_198S_avg(2).img(x,y); data_198S_avg(3).img(x,y); data_198S_avg(4).img(x,y); data_198S_avg(5).img(x,y); data_198S_avg(6).img(x,y)]);
         result = polyfit(data_198T_avg.exposureTime, temp, 1);
         m_198(x,y) = result(1);
         b_198(x,y) = result(2);
         
         temp = double([data_299S_avg(1).img(x,y); data_299S_avg(2).img(x,y); data_299S_avg(3).img(x,y); data_299S_avg(4).img(x,y); data_299S_avg(5).img(x,y); data_299S_avg(6).img(x,y)]);
         result = polyfit(data_299T_avg.exposureTime, temp, 1);
         m_299(x,y) = result(1);
         b_299(x,y) = result(2);
         
         temp = double([data_395S_avg(1).img(x,y); data_395S_avg(2).img(x,y); data_395S_avg(3).img(x,y); data_395S_avg(4).img(x,y); data_395S_avg(5).img(x,y); data_395S_avg(6).img(x,y)]);
         result = polyfit(data_395T_avg.exposureTime, temp, 1);
         m_395(x,y) = result(1);
         b_395(x,y) = result(2);
         
         temp = double([data_798S_avg(1).img(x,y); data_798S_avg(2).img(x,y); data_798S_avg(3).img(x,y); data_798S_avg(4).img(x,y); data_798S_avg(5).img(x,y); data_798S_avg(6).img(x,y)]);
         result = polyfit(data_798T_avg.exposureTime, temp, 1);
         m_798(x,y) = result(1);
         b_798(x,y) = result(2);
     end
     disp(strcat('IMG Coord: ', strcat('(', string(x)), strcat(',', string(y), ')')))
 end
 
 
 % Normalize the SLOPE
 m_55_norm = m_55/1;
 m_99_norm = m_99/1.8;
 m_198_norm = m_198/3.6;  
 m_299_norm = m_299/5.44;
 m_395_norm = m_395/7.18;
 m_798_norm = m_798/14.51;
 
 norm_vec = {m_55_norm, m_99_norm, m_198_norm, m_299_norm, m_395_norm, m_798_norm};
 b_vec = {b_55, b_99, b_198, b_299, b_395, b_798};
 name = ["m_55" "m_99" "m_198" "m_299" "m_395" "m_798"];
 
 % Initialize struct.
 j=0;
 for j=1:6
     m_part(j).root = name(j);  
 end
 
 m_part(1).m = m_55;
 m_part(2).m = m_99;
 m_part(3).m = m_198;
 m_part(4).m = m_299;
 m_part(5).m = m_395;
 m_part(6).m = m_798;
 
 m_part(1).b = b_55;
 m_part(2).b = b_99;
 m_part(3).b = b_198;
 m_part(4).b = b_299;
 m_part(5).b = b_395;
 m_part(6).b = b_798;
 
 clear m_55
 clear m_99 
 clear m_198
 clear m_299
 clear m_395
 clear m_798

 clear b_55
 clear b_99 
 clear b_198
 clear b_299
 clear b_395
 clear b_798
 
 
 
 i=0;
 for i=1:length(norm_vec)   
   % PRNU
   % Partition the image into 3x3 sub-blocks
   heightBy3 = info.Height/3;
   widthBy3 = info.Width/3;
   temp = cell2mat(norm_vec(i)); 
   
   m_part(i).PRNU = std2(temp);
      
   m_part(i).imgTLSLP = temp(1:widthBy3, 1:heightBy3);
   m_part(i).imgTMSLP = temp((1+widthBy3):2*widthBy3, 1:heightBy3);
   m_part(i).imgLMSLP = temp(1:widthBy3, (1+heightBy3):2*heightBy3);
   m_part(i).imgMSLP = temp((1+widthBy3):2*widthBy3, (1+heightBy3):2*heightBy3);
   
   m_part(i).TL_PRNU = std2(m_part(i).imgTLSLP);
   m_part(i).TM_PRNU = std2(m_part(i).imgTMSLP);
   m_part(i).LM_PRNU = std2(m_part(i).imgLMSLP);
   m_part(i).M_PRNU = std2(m_part(i).imgMSLP);
       
   clear r
   clear gr
   clear gb
   clear b
   
   % CFA : RGBRGBRGB
%    j=0; 
%    clear img_unravel
%    img_unravel = temp(1,:);
%    for j=2:length(temp(:,1))
%       vec = temp(j,:);
%       img_unravel = horzcat(img_unravel,vec);
%    end
%    img_unravel = transpose(img_unravel);

%    %data(i).imgUnravel = img_unravel;
%    red = false;
%    green = false;
%    blue = false;

%    k=0;
%    for k=1:length(img_unravel)
%       if red == false
%           r(k) = img_unravel(k);
%           red = true;
%           continue
%       end
%       if green == false
%           g(k) = img_unravel(k);
%           green = true;
%           continue
%       end
%       if blue == false
%           b(k) = img_unravel(k);
%           red = false;
%           green = false;
%           continue
%       end
%    end
   
% FROM IMX322 DS : Gb B  Gb B
%                  R  Gr R  Gr
   y=0; x=0;
   for y=1:length(temp(1,:))
       for x=1:length(temp(:,1))
           if mod(y,2) ~= 0
               if mod(x,2) ~= 0
                  gb(x,y) = temp(x,y);
               else
                  r(x,y) = temp(x,y);
               end
           else
               if mod(x,2) ~= 0
                  b(x,y) = temp(x,y);
               else
                  gr(x,y) = temp(x,y);
               end
           end
       end
   end
   
   m_part(i).rSLP = r;
   m_part(i).grSLP = gr;
   m_part(i).gbSLP = gb;
   m_part(i).bSLP = b;

   r = nonzeros(r);
   r = reshape(r,length(r),1);
   gr = nonzeros(gr);
   gr = reshape(gr,length(gr),1);
   gb = nonzeros(gb);
   gb = reshape(gb,length(gb),1);
   b = nonzeros(b);
   b = reshape(b,length(b),1);
   
   m_part(i).rPRNU = std2(r);
   m_part(i).grPRNU = std2(gr);
   m_part(i).gbPRNU = std2(gb);
   m_part(i).bPRNU = std2(b);
   
   
   
   %DSNU
   b_temp = cell2mat(b_vec(i)); 

   m_part(i).DSNU = std2(b_temp);
   
   m_part(i).imgTLb = b_temp(1:widthBy3, 1:heightBy3);
   m_part(i).imgTMb = b_temp((1+widthBy3):2*widthBy3, 1:heightBy3);
   m_part(i).imgLMb = b_temp(1:widthBy3, (1+heightBy3):2*heightBy3);
   m_part(i).imgMb = b_temp((1+widthBy3):2*widthBy3, (1+heightBy3):2*heightBy3);
   
   m_part(i).TL_DSNU = std2(m_part(i).imgTLb);
   m_part(i).TM_DSNU = std2(m_part(i).imgTMb);
   m_part(i).LM_DSNU = std2(m_part(i).imgLMb);
   m_part(i).M_DSNU = std2(m_part(i).imgMb);
   
   clear r
   clear gr
   clear gb
   clear b
 
%    j=0; 
%    clear img_unravel
%    img_unravel = b_temp(1,:);
%    for j=2:length(b_temp(:,1))
%       vec = b_temp(j,:);
%       img_unravel = horzcat(img_unravel,vec);
%    end
%    img_unravel = transpose(img_unravel);

   %data(i).imgUnravel = img_unravel;
   
%    red = false;
%    green = false;
%    blue = false;
   
%    k=0;
%    for k=1:length(img_unravel)
%       if red == false
%           r(k) = img_unravel(k);
%           red = true;
%           continue
%       end
%       if green == false
%           g(k) = img_unravel(k);
%           green = true;
%           continue
%       end
%       if blue == false
%           b(k) = img_unravel(k);
%           red = false;
%           green = false;
%           continue
%       end
%    end

% FROM IMX322 DS : Gb B  Gb B
%                  R  Gr R  Gr
   y=0; x=0;
   for y=1:length(b_temp(1,:))
       for x=1:length(b_temp(:,1))
           if mod(y,2) ~= 0
               if mod(x,2) ~= 0
                  gb(x,y) = b_temp(x,y);
               else
                  r(x,y) = b_temp(x,y);
               end
           else
               if mod(x,2) ~= 0
                  b(x,y) = b_temp(x,y);
               else
                  gr(x,y) = b_temp(x,y);
               end
           end
       end
   end
   
   m_part(i).rOff = r;
   m_part(i).grOff = gr;
   m_part(i).gbOff = gb;
   m_part(i).bOff = b;
   
   r = nonzeros(r);
   r = reshape(r,length(r),1);
   gr = nonzeros(gr);
   gr = reshape(gr,length(gr),1);
   gb = nonzeros(gb);
   gb = reshape(gb,length(gb),1);
   b = nonzeros(b);
   b = reshape(b,length(b),1);
   
   
   m_part(i).rDSNU = std2(r);
   m_part(i).grDSNU = std2(gr);
   m_part(i).gbDSNU = std2(gb);
   m_part(i).bDSNU = std2(b);
   
 end


disp('Saving Workspace Variables')
filename = 'ReadNoise_PixelWise_Data.mat';
%filename = 'Z:\PRNU_DSNU_Data.mat';
%save(filename, 'data_55S','data_99S','data_198S', 'data_299S', 'data_395S', 'data_798S', '-v7.3'); 
save(filename, 'm_part', '-v7.3'); 

m_partT = struct2table(m_part); % convert the struct array to a table

% %%
% figure(1)
% imagesc(m_part(1).imgTLSLP)
% colorbar
% 
% figure(2)
% imagesc(m_part(1).imgLMSLP)
% colorbar
% 
% figure(3)
% imagesc(m_part(1).imgMSLP)
% colorbar
% 
% % figure(1)
% % imagesc(m_part(1).imgTLSLP)
% % colorbar
% % 
% % figure(2)
% % imagesc(m_part(1).imgLMSLP)
% % colorbar
% % 
% % figure(3)
% % imagesc(m_part(1).imgMSLP)
% % colorbar
% 
% figure(4)
% imagesc(m_part(1).m)
% colorbar
% %
%%
figure(5)
imagesc(m_part(1).m(1500:2000,1500:2000))
colorbar

figure(6)
imagesc(m_part(1).b)
colorbar


for i=1:length(m_part)
    %Gr
    temp = m_part(i).grSLP(1500:2000,1500:2000);
    temp_reshape = nonzeros(temp);
    PRNU(i).grPRNU = std2(temp_reshape)/mean2(temp_reshape)*100;
    %Gb
    temp = m_part(i).gbSLP(1500:2000,1500:2000);
    temp_reshape = nonzeros(temp);
    PRNU(i).gbPRNU = std2(temp_reshape)/mean2(temp_reshape)*100;
    %R
    temp = m_part(i).rSLP(1500:2000,1500:2000);
    temp_reshape = nonzeros(temp);
    PRNU(i).rPRNU = std2(temp_reshape)/mean2(temp_reshape)*100;
    %B
    temp = m_part(i).bSLP(1500:2000,1500:2000);
    temp_reshape = nonzeros(temp);
    PRNU(i).bPRNU = std2(temp_reshape)/mean2(temp_reshape)*100;
end

PRNU_T = struct2table(PRNU); % convert the struct array to a table
hold on
plot([55,99,198,299,395,798],PRNU_T.grPRNU)
plot([55,99,198,299,395,798],PRNU_T.gbPRNU)
plot([55,99,198,299,395,798],PRNU_T.rPRNU)
plot([55,99,198,299,395,798],PRNU_T.bPRNU)