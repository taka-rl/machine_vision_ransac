function ransac_linedetection(testimage, numIterations, thresholdDistance, minInliers)
% Read the testimage
image = imread(testimage);

% Convert the image to grayscale
if size(image, 3) == 3
    grayImage = rgb2gray(image);
else
    grayImage = image; % Already grayscale
end

% Apply edge detection (Canny, Prewitt, Sobel) to obtain edge points
edgePoints = edge(grayImage, 'Prewitt');

% Thresholding: Set a threshold on the edge map
edgePoints = edgePoints > 0.1; 

% Initialize variables to store detected lines
detectedLines = [];
while true
    % Find the row and column indices of remaining edge points
    [rowIndices, colIndices] = find(edgePoints);
    
    % Number of data points
    numPoints = numel(rowIndices);
    
    if numPoints < 2
        break;  % No more points to detect lines
    end
    
    % Initialize variables to store the best model and inliers
    bestModel = [];
    maxInliers = 0;

    for iteration = 1:numIterations
        % Randomly sample two points to form a candidate line
        sampleIndices = randperm(numPoints, 2);
        sampleX = colIndices(sampleIndices);
        sampleY = rowIndices(sampleIndices);

        % Fit a line to the two sampled points
        model = polyfit(sampleX, sampleY, 1);

        % Compute the distance between each point and the model
        distances = abs(polyval(model, colIndices) - rowIndices);

        % Count inliers (points that are within the threshold)
        inliers = find(distances < thresholdDistance);

        % Update the best model if this iteration has more inliers
        if length(inliers) > maxInliers
            bestModel = model;
            maxInliers = length(inliers);
        end
    end
    if maxInliers >= minInliers
        % Store the detected line
        detectedLines = [detectedLines; bestModel];

        % Remove inliers from the edge points
        edgePoints(sub2ind(size(edgePoints), rowIndices(inliers), colIndices(inliers))) = 0;
    else
        break;  % No more significant lines found
    end
end

% Plot the original image
figure
imshow(image);
hold on;

% Plot the detected lines
for i = 1:size(detectedLines, 1)
    xRange = [min(colIndices), max(colIndices)];
    yRange = polyval(detectedLines(i, :), xRange);
    plot(xRange, yRange, 'r', 'LineWidth', 2);
end

title('RANSAC Line Detection');
xlabel('X');
ylabel('Y');

hold off;
end