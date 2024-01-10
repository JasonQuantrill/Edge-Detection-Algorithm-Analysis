image = imread('noisy_face.png'); % Replace with your image path
grayImage = rgb2gray(image); % Convert to grayscale if necessary

% Robert masks and Convolving the image
Robert_Gx = [1 0; 0 -1];
Robert_Gy = [0 1; -1 0];
Robert_edge_x = conv2(double(grayImage), Robert_Gx, 'same');
Robert_edge_y = conv2(double(grayImage), Robert_Gy, 'same');

% Prewitt masks and Convolving the image
Prewitt_Gx = [-1 0 1; -1 0 1; -1 0 1];
Prewitt_Gy = [-1 -1 -1; 0 0 0; 1 1 1];
Prewitt_edge_x = conv2(double(grayImage), Prewitt_Gx, 'same');
Prewitt_edge_y = conv2(double(grayImage), Prewitt_Gy, 'same');

% Sobel masks and Convolving the image
Sobel_Gx = [-1 0 1; -2 0 2; -1 0 1];
Sobel_Gy = [-1 -2 -1; 0 0 0; 1 2 1];
Sobel_edge_x = conv2(double(grayImage), Sobel_Gx, 'same');
Sobel_edge_y = conv2(double(grayImage), Sobel_Gy, 'same');

% Calculate gradient magnitudes
Robert_magnitude = sqrt(Robert_edge_x.^2 + Robert_edge_y.^2);
Prewitt_magnitude = sqrt(Prewitt_edge_x.^2 + Prewitt_edge_y.^2);
Sobel_magnitude = sqrt(Sobel_edge_x.^2 + Sobel_edge_y.^2);

% Define Gabor filter parameters
lambda = 2; % Wavelength of sinusoidal factor
theta = 0; % Orientation

% Create and apply Gabor filter
gaborArray = gabor(lambda, theta);
gaborMag = imgaborfilt(grayImage, gaborArray);

% Apply Canny edge detection with custom thresholds
% You may need to experiment with these threshold values
lowThreshold = 0.20;
highThreshold = 0.30;
cannyEdges = edge(grayImage, 'Canny', [lowThreshold, highThreshold]);

% Define Scharr kernels
scharrX = [3 0 -3; 10 0 -10; 3 0 -3]; % Horizontal edges
scharrY = [3 10 3; 0 0 0; -3 -10 -3]; % Vertical edges

% Apply Scharr edge detection
scharrEdgesX = imfilter(double(grayImage), scharrX, 'replicate');
scharrEdgesY = imfilter(double(grayImage), scharrY, 'replicate');
scharrEdges = sqrt(scharrEdgesX.^2 + scharrEdgesY.^2);

% Normalize the result to enhance visibility
scharrEdges = mat2gray(scharrEdges); % Normalize the gradient magnitude
scharrEdges = imadjust(scharrEdges); % Enhance contrast

% Thresholding (optional, adjust threshold as needed)
threshold = 0.35; % Example threshold value
scharrEdges(scharrEdges < threshold) = 0;

threshold_prewitt = 110;
threshold_sobel = 150;
Robert_edges = Robert_magnitude > threshold;
Prewitt_edges = Prewitt_magnitude > threshold_prewitt;
Sobel_edges = Sobel_magnitude > threshold_sobel;

% Display results
figure;
% Display the resulting edge images
%subplot(1, 2, 1); imshow(grayImage); title('Original Image');
%subplot(1, 2, 2); imshow(Robert_edges); title('Robert');
%subplot(1, 2, 1); imshow(Prewitt_edges); title('Prewitt');
%subplot(1, 2, 2); imshow(Sobel_edges); title('Sobel');
subplot(1, 2, 1); imshow(gaborMag, []); title('Gabor');
subplot(1, 2, 2); imshow(cannyEdges); title('Canny');
%subplot(1, 2, 1); imshow(scharrEdges, []); title('Scharr');