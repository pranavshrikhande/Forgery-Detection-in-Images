function images = discover_images(dir_path, suffix_list, N_max, N_max_dir)
%function images = discover_images(dir_path, suffix_list, N_max=0, N_max_dir=0)
%
% Return all files in folders "dir_path" that end with the "suffix" string. 
%
% OPTIONAL PARAMETERS: 
% "N_max"     maximum number of selected files.
% "N_max_dir" maximum number of selected files in each folder.
%
% Author: Giovanni Chierchia.
% Last revised: 14.06.2013
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

% controllo dei parametri
if ischar(suffix_list) 
    suffix = { suffix_list };
elseif iscellstr(suffix_list)
    suffix = suffix_list;
else
    error('the "suffix" parameter must be a string or a cell of strings');
end
if ischar( dir_path ) 
    path = { dir_path };
elseif iscellstr( dir_path )
    path = dir_path;
else
    error('the "suffix" parameter must be a string or a cell of strings');
end

% parametri di default
if nargin < 3
    N_max = 0;
end
if nargin < 4
    N_max_dir = (N_max>0);
end

% immagini per singola directory
N_path = numel(path);
if (N_max ~= 0)
    if (N_max_dir~=0) && (N_max_dir*N_path<N_max),
        N_max_dir = ceil(N_max / N_path);
    end;
end

% scorri le directory
idx = 0;
for j=1:N_path

    if ~ischar( path{j} )
        error('path is not correct');
    end
    
    % elenca tutti i file nella directory
    files = dir( path{j} );

    % scorri i file
    count = 0;
    for i=1:numel(files)                          
    
        % nome del file
        filename = files(i).name;
    
        % scorri le estensioni
        for k = 1:numel(suffix)
            
            % prendi il file se ha l'estensione giusta
            sfx = length(suffix{k});
            if length(filename) >= sfx && strcmpi( filename(end-sfx+1:end), suffix{k} )
                idx = idx+1;
                images{idx} = fullfile( path{j}, filename );
                count = count + 1;
                break;
            end
            
        end
    
        % non prendere piu' di 'N_max' immagini
        if (N_max ~= 0) && (idx == N_max),
            break;
        end
        % non prendere piu' di 'N_max_dir' immagini per ogni directory
        if (N_max_dir~=0) && (count == N_max_dir),
            break;
        end
    
    end
    
    % non prendere piu' di 'N_max' immagini
    if (N_max ~= 0) && (idx == N_max),
        break;
    end
    
end

% assegna l'uscita se non sono state trovate immagini
if idx == 1
    images = {};
end