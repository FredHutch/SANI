function [assignment,total_cost]=gethungdist(source,target)

n_source_points = size(source, 1);
    n_target_points = size(target, 1);
    
    D = NaN(n_source_points, n_target_points);
    
    % Build distance matrix
    for i = 1 : n_source_points
        
        % Pick one source point
        current_point = source(i, :);
        
        % Compute square distance to all target points
        diff_coords = target - repmat(current_point, n_target_points, 1);
        square_dist = sum(diff_coords.^2, 2);
        
        % Store them
        D(i, :) = square_dist;
        
    end

    [ target_indices, total_cost, assignment ] = munkres(D);