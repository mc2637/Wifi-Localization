%read the text file

clear;
close all
addpath('./libs/');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%construct feature vector and labels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fileName = './combinedData.txt'; %change the file name

%each row of "features" contains scan results for each wifi scan
%each row of "labels" constains scan name for each wifi scan
[ features, labels ] = ExtractFeaturesUpper( fileName );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%add the visualization. Histrogram of the wifi access point signal strength.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
no_of_data_points = length(labels);
no_of_subplots_in_one_plot = 5;
k = 3; %first two plots are for cosine similarity and euclidian distance
for i = 1:no_of_data_points
    if rem(i-1,no_of_subplots_in_one_plot) == 0 %means we are
        figure(k)
        k = k + 1;
        l = 1;
    end
    subplot(no_of_subplots_in_one_plot,1,l); %draw 5 plots a time
    bar(-features(i,:));
    xlabel(labels{i,1});
    l = l + 1;    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%find similarity (Cosine similarity)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%TODO: Find similarity for scans - 
similarity_matrix = zeros(size(features,1),size(features,1));
for r = 1:no_of_data_points
    for c = 1:no_of_data_points
        A = features(r,:);  %extract values from features
        B = features(c,:);
        
        numerator = sum(A.*B);
        denominator = (sqrt(sum(A.*A)))*(sqrt(sum(B.*B)));
        
        v = numerator/denominator;
      
        indices = sub2ind(size(similarity_matrix),r,c);
        similarity_matrix(indices) = v; 
    end
end





%plot similarity
figure(1);
imagesc(similarity_matrix)
colorbar('peer', gca(), 'eastoutside');
set(gca,'xtick',1:length(labels) + 0.5);
set(gca,'xticklabel',labels);
set(gca,'ytick',1:length(labels) + 0.5);
set(gca,'yticklabel',labels);
%rotateXLabels( gca, 45 )
xticklabel_rotate([],90);
title('Cosine Similarity')

