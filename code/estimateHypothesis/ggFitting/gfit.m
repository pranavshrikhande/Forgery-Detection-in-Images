function y = gfit(x,show)
%function y = gfit(x)
%
% Estimate the parameters (m,a,b) of Gaussian distribution.
% where:
%   - m = position factor (mean).
%   - a =    scale factor.
%   - b =    shape factor (fixed at 2). 
%
%
% Author: Giovanni Chierchia.
% Last revised: 01.06.2010
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

% parametri di default
if nargin < 2
    show = [];
end

% controllo dei parametri
if numel(x) ~= length(x)
    error('l''ingresso deve essere un vettore riga o colonna');
end
if ~isempty(show) && ~ischar(show)
    error('il parametro "show" deve essere una stringa');
end

% stima MME del valor medio
m = mean(x);

% stima MME del fattore di forma
sigma2 = mean( (x-m).^2 );

% costruisci l'uscita
y = [m, sqrt(2*sigma2), 2];

% visualizza
if ~isempty(show)
    
    % istogramma
    [bins midpoint] = hist(x, 100);
    bar( midpoint, bins, 'BarWidth', 1, 'FaceColor', [.76 .87 .78], 'EdgeColor', [.94 .94 .94] );
    xlabel('Valore dei campioni'); ylabel('Numero di occorrenze'); 
    line( midpoint, bins, 'Marker', 'x', 'LineStyle', 'none' );

    % fitting della PDF
    width = midpoint(2) - midpoint(1);
    hist_area = width * sum(bins);
    x = midpoint(1):0.0001:midpoint(end);
    line( x, hist_area * ggpdf(x, y(1), y(2), y(3)), 'Color', 'r', 'LineWidth', 2 );
    
    % titolo e legenda
    title(show); box on;
    %legend( {'Istogramma', 'Numero di occorrenze', 'Stima della pdf'} );
    
end