%data_temp=load('ReadNoise_Data.mat'); - using data structure saved in
%readnoise.m
data=data_temp(1);
f = fieldnames(data);

%% overal data
for i = 1:length(f)
    for k=1:length(data.(f{i}))
        curr=data.(f{i})(k);
        %disp(data.(f{i})(k).imgSTDNorm);
        %data.(f{i})(k).imgSTDNorm = data.(f{i})(k).imgSTD*495e-3;
        data.(f{i})(k).imgSTDmV = sqrt(sum(sum(((double(curr.img)-double(curr.imgMean)).*(459e-3/(2^10))).^2))/(size(curr.img,1)*size(curr.img,2)));
        %fprintf('ISOSpeed: %0.4f; Mean: %0.4f; STD (mVrms): %f\n', data.(f{i})(k).isoSpeed, data.(f{i})(k).imgMean, data.(f{i})(k).imgSTDmV*1e3);
        fprintf('%0.4f, %0.4f\n', curr.isoSpeed, data.(f{i})(k).imgSTDmV*1e3)
    end
end

%% color channels

for i = 1:length(f)
    for k=1:length(data.(f{i}))
        curr=data.(f{i})(k);
        gb=zeros(size(curr.img));
        r=zeros(size(curr.img));
        b=zeros(size(curr.img));
        gr=zeros(size(curr.img));
        y=0; x=0;
        for y=1:size(curr.img,2)
            for x=1:size(curr.img,1)
                if mod(y,2) ~= 0
                    if mod(x,2) ~= 0
                        b(x,y) = curr.img(x,y);
                    else
                        gr(x,y) = curr.img(x,y);
                    end
                else
                    if mod(x,2) ~= 0
                        gb(x,y) = curr.img(x,y);
                    else
                        r(x,y) = curr.img(x,y);
                    end
                end
            end
        end
        r=nonzeros(r);
        b=nonzeros(b);
        gr=nonzeros(gr);
        gb=nonzeros(gb);
        rSTD = sqrt(sum(sum(((double(r)-double(mean2(r))).*(459e-3/(2^10))).^2))/(size(r,1)*size(r,2)));
        grSTD = sqrt(sum(sum(((double(gr)-double(mean2(gr))).*(459e-3/(2^10))).^2))/(size(gr,1)*size(gr,2)));
        bSTD = sqrt(sum(sum(((double(b)-double(mean2(b))).*(459e-3/(2^10))).^2))/(size(b,1)*size(b,2)));
        gbSTD = sqrt(sum(sum(((double(gb)-double(mean2(gb))).*(459e-3/(2^10))).^2))/(size(gb,1)*size(gb,2)));
        %fprintf('ISOSpeed: %0.4f; Mean: %0.4f; STD (mVrms): %f\n', data.(f{i})(k).isoSpeed, data.(f{i})(k).imgMean, data.(f{i})(k).imgSTDmV*1e3);
        fprintf('%0.4f, %0.4f, %0.4f, %0.4f, %0.4f\n', ...
            curr.isoSpeed, rSTD*1e3, grSTD*1e3, bSTD*1e3, gbSTD*1e3);
%         fprintf('%0.4f, %0.4f, %0.4f, %0.4f, %0.4f\n', ...
%             curr.isoSpeed, double(mean2(r))*1e3, double(mean2(b))*1e3, double(mean2(gr))*1e3, double(mean2(gb))*1e3);
    end
end


%% location in sensor - by column

img=data.(f{1}).img;
std_dev_matrix_198=zeros(length(f),size(img,2));
for k=1:length(data.(f{1}))
    curr=data.(f{1})(k);
    num_column = size(curr.img,2);
    std_dev_col = zeros(1,num_column);
    for c=1:num_column
        std_dev_col(c) = sqrt(sum(sum(((double(curr.img(:,c))-mean(double(curr.img(:,c)))).*(459e-3/(2^10))).^2))/(size(curr.img,1)));
    end
    std_dev_matrix_198(k,:) = std_dev_col.*1e3;
end
std_dev_matrix_198 = mean(std_dev_matrix_198);
figure(1)
subplot(2,1,1)
plot(std_dev_matrix_198)
xlabel('Column #')
ylabel('Readout Noise (mVrms)')
xlim([1 4000])
title('ISO=198')
subplot(2,1,2)
histogram(std_dev_matrix_198)
xlabel('Readout Noise (mVrms)')
ylabel('# of Columns')

std_dev_matrix_299=zeros(length(f),size(img,2));
for k=1:length(data.(f{2}))
    curr=data.(f{2})(k);
    num_column = size(curr.img,2);
    std_dev_col = zeros(1,num_column);
    for c=1:num_column
        std_dev_col(c) = sqrt(sum(sum(((double(curr.img(:,c))-mean(double(curr.img(:,c)))).*(459e-3/(2^10))).^2))/(size(curr.img,1)));
    end
    std_dev_matrix_299(k,:) = std_dev_col.*1e3;
end
std_dev_matrix_299 = mean(std_dev_matrix_299);
figure(2)
subplot(2,1,1)
plot(std_dev_matrix_299)
xlabel('Column #')
ylabel('Readout Noise (mVrms)')
xlim([1 4000])
title('ISO=299')
subplot(2,1,2)
histogram(std_dev_matrix_299)
xlabel('Readout Noise (mVrms)')
ylabel('# of Columns')

std_dev_matrix_395=zeros(length(f),size(img,2));
for k=1:length(data.(f{3}))
    curr=data.(f{3})(k);
    num_column = size(curr.img,2);
    std_dev_col = zeros(1,num_column);
    for c=1:num_column
        std_dev_col(c) = sqrt(sum(sum(((double(curr.img(:,c))-mean(double(curr.img(:,c)))).*(459e-3/(2^10))).^2))/(size(curr.img,1)));
    end
    std_dev_matrix_395(k,:) = std_dev_col.*1e3;
end
std_dev_matrix_395 = mean(std_dev_matrix_395);
figure(3)
subplot(2,1,1)
plot(std_dev_matrix_395)
xlabel('Column #')
ylabel('Readout Noise (mVrms)')
xlim([1 4000])
title('ISO=395')
subplot(2,1,2)
histogram(std_dev_matrix_395)
xlabel('Readout Noise (mVrms)')
ylabel('# of Columns')

std_dev_matrix_55=zeros(length(f),size(img,2));
for k=1:length(data.(f{4}))
    curr=data.(f{4})(k);
    num_column = size(curr.img,2);
    std_dev_col = zeros(1,num_column);
    for c=1:num_column
        std_dev_col(c) = sqrt(sum(sum(((double(curr.img(:,c))-mean(double(curr.img(:,c)))).*(459e-3/(2^10))).^2))/(size(curr.img,1)));
    end
    std_dev_matrix_55(k,:) = std_dev_col.*1e3;
end
std_dev_matrix_55 = mean(std_dev_matrix_55);
figure(4)
subplot(2,1,1)
plot(std_dev_matrix_55)
xlabel('Column #')
ylabel('Readout Noise (mVrms)')
xlim([1 4000])
title('ISO=55')
subplot(2,1,2)
histogram(std_dev_matrix_55)
xlabel('Readout Noise (mVrms)')
ylabel('# of Columns')

std_dev_matrix_798=zeros(length(f),size(img,2));
for k=1:length(data.(f{5}))
    curr=data.(f{5})(k);
    num_column = size(curr.img,2);
    std_dev_col = zeros(1,num_column);
    for c=1:num_column
        std_dev_col(c) = sqrt(sum(sum(((double(curr.img(:,c))-mean(double(curr.img(:,c)))).*(459e-3/(2^10))).^2))/(size(curr.img,1)));
    end
    std_dev_matrix_798(k,:) = std_dev_col.*1e3;
end
std_dev_matrix_798 = mean(std_dev_matrix_798);
figure(5)
subplot(2,1,1)
plot(std_dev_matrix_798)
xlabel('Column #')
ylabel('Readout Noise (mVrms)')
xlim([1 4000])
title('ISO=798')
subplot(2,1,2)
histogram(std_dev_matrix_798)
xlabel('Readout Noise (mVrms)')
ylabel('# of Columns')

std_dev_matrix_99=zeros(length(f),size(img,2));
for k=1:length(data.(f{6}))
    curr=data.(f{6})(k);
    num_column = size(curr.img,2);
    std_dev_col = zeros(1,num_column);
    for c=1:num_column
        std_dev_col(c) = sqrt(sum(sum(((double(curr.img(:,c))-mean(double(curr.img(:,c)))).*(459e-3/(2^10))).^2))/(size(curr.img,1)));
    end
    std_dev_matrix_99(k,:) = std_dev_col.*1e3;
end
std_dev_matrix_99 = mean(std_dev_matrix_99);
figure(6)
subplot(2,1,1)
plot(std_dev_matrix_99)
xlabel('Column #')
ylabel('Readout Noise (mVrms)')
xlim([1 4000])
title('ISO=99')
subplot(2,1,2)
histogram(std_dev_matrix_99)
xlabel('Readout Noise (mVrms)')
ylabel('# of Columns')