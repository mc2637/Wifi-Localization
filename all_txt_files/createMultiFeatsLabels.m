here = pwd;
%cd all_txt_files
fileNames = dir('*.txt');
[numPeople,temp] = size(fileNames);

%%% extract data from each file %%%
for j=1:numPeople
fileName = fileNames(j).name;   
eval(['[features',num2str(j),',labels',num2str(j),',featureNames',num2str(j),'] = ExtractFeaturesUpper(fileName);']);

end

%%% find all existing feature names from all files %%%%
for jj=1:numPeople-1
    if jj==1
    eval(['combNames',num2str(jj),' = union(featureNames',num2str(jj),',featureNames',num2str(jj+1),');']);
    else
    eval(['combNames',num2str(jj),' = union(combNames',num2str(jj-1),',featureNames',num2str(jj+1),');']);
    end
end

eval(['combNames = combNames',num2str(numPeople-1),';']);

%%%% create identifier column %%%%
idxs = [];
lens = [];
for jjj=1:numPeople    
    groupIndex=[1:numPeople];
    eval(['[len,temp] = size(features',num2str(jjj),');']);
    idxTemp = ones(len,1)*jjj;
    lens = [lens, len];
    idxs = [idxs; idxTemp];
end

%%%%%% create combined features matrix %%%%

%%% find the column indices of the original feature names that match the
%%% columns of the combined names THIS MIGHT TAKE A MINUTE

for k=1:numPeople
eval(['[len,orgCols] = size(features',num2str(k),');']);
    colIdx = zeros(1,orgCols);
        for kk=1:orgCols
                for kkk=1:length(combNames)
                    eval(['flg=strcmp(featureNames',num2str(k),'(kk),combNames(kkk));']);
                        if flg
                            colIdx(kk)=kkk;
                        else
                        end
                end
        end
eval(['colIdx',num2str(k),'=colIdx;']);
checkZero = find(colIdx==0);

end


all_features = [];

for n=1:numPeople
    expanded(n).expFeatures = ones(lens(n),length(combNames))*NaN;
    eval(['expanded(n).expFeatures(:,colIdx',num2str(n),') = features',num2str(n),';']);
    all_features = [all_features; expanded(n).expFeatures];
end



%%%%%%% create labels %%%%%%%

locationStrings = {'P318','U312','U5128','DAUH','DAP','DAC','GH219'};
all_labels = [];
for nn =1:numPeople
    labels(nn).numeric = zeros(lens(nn),1);
    eval(['labels(nn).labels = labels',num2str(nn),';']);
         
            for nnn=1:lens(nn)
             for s=1:7
                 flg = strfind(labels(nn).labels{nnn},locationStrings{s});
                 if flg == 1
                     labels(nn).numeric(nnn) = s;
                 else
                 end
             end
            end 
            
    all_labels = [all_labels; labels(nn).numeric];
end

all_data = [idxs, all_features, all_labels];
all_data(find(all_labels==0),:) = [];
[numRows,numCols] = size(all_data);

% putting a very negative number in the nan elements
all_data(isnan(all_data)) = -200;

clearvars -except all_data

% Implement LOSO and KNN from scratch here from this point.




   

    
    