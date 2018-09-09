function Y = color2gray( X )
% convert a color image to a grayscale image.

Nb = size(X,3);
if Nb == 1
    Y = X;
elseif Nb == 3
    Y = 0.3 * X(:,:,1) + 0.6 * X(:,:,2) + 0.1 * X(:,:,3);
else
    Y = mean(X, 3);
    warning('La matrice d''ingresso possiede %d canali', Nb);
end