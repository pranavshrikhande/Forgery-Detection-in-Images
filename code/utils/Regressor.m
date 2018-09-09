classdef Regressor
% Regressor 
% Class to train and use a regression model.
% Kinds of models:
%  - 'linear'        = Constant and linear terms (DEFAULT)
%  - 'interaction'   = Constant, linear, and interaction terms
%  - 'quadratic'     = Constant, linear, interaction, and squared terms
%  - 'purequadratic' = Constant, linear, and squared terms
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Copyright (c) 2016 Image Processing Research Group of University Federico II of Naples ('GRIP-UNINA').
% All rights reserved.
% this software should be used, reproduced and modified only for informational and nonprofit purposes.
% 
% By downloading and/or using any of these files, you implicitly agree to all the
% terms of the license, as specified in the document LICENSE.txt
% (included in this package) and online at
% http://www.grip.unina.it/download/LICENSE_OPEN.txt
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    properties(SetAccess = private)
        model = 'linear';
        weights = [];
    end
    
    methods
                
        function obj = Regressor(model, weights)
        % obj = Regressor()
        % obj = Regressor(model)
        % obj = Regressor(model, weights)
        %
        % Builder of a object to train and use a regression model.    
        %  I "model" indicates the model type:
        %       - 'linear'        = Constant and linear terms (DEFAULT)
        %       - 'interaction'   = Constant, linear, and interaction terms
        %       - 'quadratic'     = Constant, linear, interaction, and squared terms
        %       - 'purequadratic' = Constant, linear, and squared terms
        %
            if exist('model', 'var')
                obj.model = model;
            end
            if exist('weights', 'var')
                obj.weights = weights;
            end
        end
        
        
        function [obj,err] = train(obj, x, y)
        % obj = train(obj, x, y)
        % Train the regression model.
        %
        % INPUTS:
        %   - "x" matrix NxM with the input vectors along the rows.
        %   - "y" vector Nx1 with the output of each vector.
        %
            fx = x2fx(x, obj.model);
            [obj.weights,bint,err] = regress(y, fx);
        end
        
        function y = exec(obj, x)
        % y = exec(obj, x)
        % Applay the model.
        %
        %  INPUT:
        %   - "x" matrix NxM with the input vectors along the rows.
        % OUTPUT:
        %   - "y" vector Nx1 with the output of each vector.
        %
            fx = x2fx(x, obj.model);
            y = fx * obj.weights;
        end
        
    end
    
end