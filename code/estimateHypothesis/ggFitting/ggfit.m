function y = ggfit(x,opt,show)
%function y = ggfit(x,opt)
%
% Estimate the parameters (m,a,b) of Generalized Gaussian distribution.
% where:
%   - m = position factor (mean).
%   - a =    scale factor.
%   - b =    shape factor. 
%
% The "opt" input can be:
%   - 'mme' = estimation through the method of moments (DEFAULT)
%   - 'mle' = estimation through the maximum likelihood method.
%
% REFERENCES:
%  [1] Fridrich, "Digital Camera Identification from Sensor Pattern Noise"
%  [2] Dominguez-Molina, "A practical procedure to estimate the shape 
%      parameter in the generalized Gaussian distribution"
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
if nargin < 2 || isempty(opt)
    opt = 'mme';
end
if nargin < 3
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
num = mean( abs(x-m) );
den = mean( (x-m).^2 );
b = ggr_inv( num^2 / den );

% stima MME del coefficiente di scala
a = num * gamma( 1 / b ) / gamma( 2 / b );

% costruisci l'uscita
if strcmpi( 'mme', opt )
    y = [m a b];
elseif strcmpi( 'mle', opt )
    y = mle( x, 'pdf', @ggpdf, 'start', [m a b], 'lower', [-Inf 0 0] );
else
    error('opzione non riconoscita');
end

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





function y = ggr_inv(x)
%        y = ggr_inv(x)
%
% Approssimazione dell'inversa del "Rapporto Gaussiano Generalizzato":
%
%                       y = M^-1(x)
%
% con 'x' che varia in [0,3/4), dove: 
%
%            M(y) = gamma(2/y)^2 / (gamma(1/y) * gamma(3/y))
%
% con 'y' che varia in [0,Inf).
%
%
% RIFERIMENTI:
%  [1] J. Armando Dom�nguez-Molina, A practical procedure to estimate the 
%      shape parameter in the generalized Gaussian distribution


% controllo dei parametri
if numel(x) ~= length(x)
    error('l''ingresso deve essere un vettore riga o colonna');
end
if any(x >= 0.75)
    error('la funzione � definita nell''intervallo [0,3/4)');
end

% coefficienti
a = [-0.535707356, 1.168939911, -0.1516189217];
b = [0.9694429, 0.8727534, 0.07350824];
c = [0.3655157, 0.6723532, 0.033834];

% inizializza l'uscita
y = zeros( size(x) );

% approssimazione del primo tratto
idx = find( 0 <= x & x < 0.131246 );
x1 = x(idx);
y(idx) = 2 * log( 27/16 ) ./ log( 3 ./ (4 * x1.^2) );

% approssimazione del secondo tratto
idx = find( 0.131246 <= x & x < 0.448994 );
x2 = x(idx);
y(idx) = 0.5 * ( - a(2) + sqrt(a(2)^2 - 4*a(1)*a(3) + 4*a(1)*x2) ) / a(1);

% approssimazione del terzo tratto
idx = find( 0.448994 <= x & x < 0.671256 );
x3 = x(idx);
y(idx) = 0.5 * ( b(1) - b(2)*x3 - sqrt((b(1) - b(2)*x3).^2 - 4*b(3)*x3.^2) ) ./ (b(3) * x3);

% approssimazione dell'ultimo tratto
idx = find( 0.671256 <= x & x < 0.75 );
x4 = x(idx);
y(idx) = 0.5 * ( c(2) - sqrt(c(2)^2 + 4*c(3)*log((3-4*x4)/(4*c(1)))) ) / c(3);





function y = ggr_fun(x)
%        y = ggr_fun(x)
%
% Approssimazione del "Rapporto Gaussiano Generalizzato":
%
%           M(x) = gamma(2/x)^2 / (gamma(1/x) * gamma(3/x))
%
% con 'x' che varia in [0,inf).
%
%
% RIFERIMENTI:
%  [1] J. Armando Dom�nguez-Molina - A practical procedure to estimate the 
%      shape parameter in the generalized Gaussian distribution


% controllo dei parametri
if numel(x) ~= length(x)
    error('l''ingresso deve essere un vettore riga o colonna');
end

% coefficienti
a = [-0.535707356, 1.168939911, -0.1516189217];
b = [0.9694429, 0.8727534, 0.07350824];
c = [0.3655157, 0.6723532, 0.033834];

% approssimazione del primo tratto
idx = find( 0 <= x & x < 0.2771981 );
x1 = x(idx);
y(idx) = 3.^(0.5 * (x1-6) ./ x1) .* 2.^((4-x1) ./ x1);
y( isnan(y) ) = 0;

% approssimazione del secondo tratto
idx = find( 0.2771981 <= x & x < 0.828012 );
x2 = x(idx);
y(idx) = a(1) * x2.^2 + a(2) * x2 + a(3);

% approssimazione del terzo tratto
idx = find( 0.828012 <= x & x < 2.631718 );
x3 = x(idx);
y(idx) = b(1) * x3 ./ (1 + b(2) * x3 + b(3) * x3.^2);

% approssimazione dell'ultimo tratto
idx = find( 2.631718 <= x );
x4 = x(idx);
y(idx) = 3/4 - c(1) * exp( - c(2) * x4 + c(3) * x4.^2);





function ggpdf_test

% genera i dati
y1 = normrnd(1, 3, [1 1000]);    % y1 ~ N(1,3)
y2 = exprnd(1, [1 1000]);        % y2 ~ exp(1)

% stima la PDF gaussiana
[MM ML] = ggpdf_estimator(y1);
x = -5:0.01:5; 
figure; plot(x,normpdf(x,1,3)); 
line(x, ggpdf(x,MM(1),MM(2),MM(3)), 'color', 'r'); 
line(x, ggpdf(x,ML(1),ML(2),ML(3)), 'color', 'g');

% stima la PDF esponenziale
[MM ML] = ggpdf_estimator(y2);
x = -5:0.01:5; 
figure; plot(x,exppdf(x,1)); 
line(x, ggpdf(x,MM(1),MM(2),MM(3)), 'color', 'r'); 
line(x, ggpdf(x,ML(1),ML(2),ML(3)), 'color', 'g');