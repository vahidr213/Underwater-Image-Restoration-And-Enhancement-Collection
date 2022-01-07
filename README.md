# A-Collection-Of-Underwater-Image-Restoration-And-Enhancement-With-Mean-Squared-Error-Measuring
**How To Use**

•	Underwater.m
Run this file to see the results.
Use vector 'method' to add or remove any numbered algorithm from the list of evaluations.
You can use any underwater image you have. The file is ready to be used with only a few settings like the address of the input image and the folder to save the result. You can enable or disable the option for saving the result on the disk.



	**Introduction**

Underwater images typically exhibit color distortion and low contrast as a result of the exponential decay that light suffers as it travels. Moreover, colors associated to different wavelengths have different attenuation rates, being the red wavelength the one that attenuates the fastest.

To restore underwater images, red channel prior is used which is a concept captured from dark channel prior. The Red Channel method can be interpreted as a variant of the Dark Channel method used for images degraded by the atmosphere when exposed to haze.

The aim of underwater image restoration and enhancement is to improve the visual quality of images captured under different underwater scenes. In recent years, this research area has attracted increased attention since improving the visibility, contrast, and colors of underwater images is of significance for many computer applications. Nevertheless, enhancing and restoring underwater image from a single image is still challenging due to the complicated underwater environment. 

The received light by a camera suffers from color deviation due to the wavelength dependent light absorption. In general, the red light first disappears with the distance from objects, followed by the orange light, yellow light, purple light, yellow-green light, green light and blue light. This is the main reason why most underwater images are dominated by the bluish or greenish tone. Therefore, to improve the visual quality of underwater image, a method which can remove the effects of back scattering light and wavelength dependent light absorption is needed.

The possibility of improving underwater images by just using image processing techniques is very appealing due to the low cost of implementation when compared with more sophisticated techniques. These methodologies enjoy a wide range of applications, from marine biology and archaeology to ecological research. The improvement of unmanned vehicles (ROV) navigation capabilities is also a very important field of application.

	**Methodologies**

Inspired by the observation that the existing number of open source methodologies on underwater image restoration and enhancement are limited, here we have obtained a combination of a couple of available methods with other proposed methods to weigh each combination whether alone or combined. As others, we were curious to find out the effect of small variants of each main method. 

Therefore, the materials provided here are a survey on underwater restoration and enhancement methods and their variants for researchers and students in order to avoid starting from scratch.

The provided source code is compiled with octave without problem. In case you have MATLAB software, you may possibly need to change some functions with their MATLAB counterparts ( the source code is is mostly compatible with MATLAB).

