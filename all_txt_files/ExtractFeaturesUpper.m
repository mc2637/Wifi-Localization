function [ features, labels, feature_names ] = ExtractFeaturesUpper( fileName )
%EXTRACTFEATURES Extract features and labels for wifi scans

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%construct feature dimension and labels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fid = fopen(fileName);


%figure out labels and mac addresses
tline = fgets(fid);
labels = {};
labels_i = 1;

%list all mac data for wifi hotspots
mac_addresses = containers.Map;
mac_addresses_i = 1;

while ischar(tline)
    
    %print hotspot
    %fprintf('%s\n',tline);
    
    
    %check whether line starts with
    %~^~
    if length(tline) > 2
        if strcmp(tline(1:3),'~^~') == 1 %means it is a label
            location_name = [tline(4:end-4) '_' num2str(labels_i)];
            labels{labels_i} = upper(location_name);
            labels_i = labels_i + 1;
        else %means wifi mac
            
            %
            r=regexp(tline,'~~','split');
            if ~isKey(mac_addresses,char(r(1)))
                mac_addresses(char(r(1))) = mac_addresses_i;
                mac_addresses_i = mac_addresses_i + 1;
            end
            
        end
    end
    
    %
    tline = fgets(fid);
end
fclose(fid);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%construct features
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
feature_names = keys(mac_addresses);
labels = [];

fid = fopen(fileName);

tline = fgets(fid);
labels = {};
labels_i = 0;

features = [];
current_feature = [];
%construct feature
while ischar(tline)
    
    %print hotspot
    %fprintf('%s\n',tline);
    
    %check whether line starts with
    %~^~
    if length(tline) > 2
        if strcmp(tline(1:3),'~^~') == 1 %means it is a label
            labels_i = labels_i + 1;
            %location_name = [tline(4:end-4) '_' num2str(labels_i)];
            labels{labels_i,1} = [tline(4:end-4)];
            features = [features ; current_feature'];%concat features
            current_feature = NaN*ones(length(feature_names),1);
        else %means wifi mac
            %
            r=regexp(tline,'~~','split');
            %char(r(1))
            current_feature(mac_addresses(char(r(1))),1) = str2double(char(r(end)));
            
        end
    end
    
    %
    tline = fgets(fid);
end
labels = upper(labels);
%add the last feature
features = [features ; current_feature'];%concat features
fclose(fid);
features(isnan(features)) = -200;
end


