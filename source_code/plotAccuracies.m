% plotting cross validation accuracies and their corresponding
%   hyper parameters C and g obtained when searching for best C and g values
% note: values obtained from using the SpamAssassin dataset

% note: best hyper parameters are C = 3, g = 0.01

% note how when looking at C value vs accuracy that there are several peaks with
%   similarly high values

% note how when looking at g value vs accuracy that the highest accuracies
%   occur when g is closer to 0
% when looking closer (setting below = 0.1), can see that there are also peaks
%   for accuracy with varying low g that you could not see when g ranged
%   from 0 to 1000

load "../saved_data/for_plotting.mat"

% 3D scatter plot, 4 point marker size, green markers
scatter3(accsAndParams(:, 2), accsAndParams(:, 3), accsAndParams(:, 1), 4, 'g')

xlabel("C value")
ylabel("g value")
zlabel("accuracy")

fprintf("\nhit any key to zoom in on a lower g value range\n")
pause;

below = 0.1; % plot will have g values from 0 to below
gBelow = find(accsAndParams(:, 3) < 0.1);
ap2 = accsAndParams(gBelow, :);

scatter3(ap2(:, 2), ap2(:, 3), ap2(:, 1), 4, 'm')

xlabel("C value")
ylabel("g value")
zlabel("accuracy")
