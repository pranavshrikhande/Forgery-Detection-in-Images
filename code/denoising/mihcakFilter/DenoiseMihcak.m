function [image_noisefee,image_noise] = DenoiseMihcak(Img,sigma,wname,L)
    [image_noise,image_noisefee] = NoiseExtractMihcak(Img,sigma,wname,L);
    