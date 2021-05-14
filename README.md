# A-Collection-Of-Underwater-Image-Restoration-And-Enhancement-With-Mean-Squared-Error-Measuring
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

	**Description of functions:**

•	Underwater.m

If you are using MATLAB you need to comment the 'pkg load image' command (other lines are ok – this is an Octave Command). Then, an underwater image is loaded. You can use any underwater image you have. 

The process starts with degrading the red channel of the reference image. At this point, medium transmission using UDCP is computed for input underwater image. Then, the red channel of the input image J(x) is multiplied by the medium transmission t(x).

I(x) = J(x) t(x)

The result of the above equation would be an underwater image I(x) that has more haze and greenish/bluish tone. The purpose of doing this is to have a reference red channel and a degraded one in order to calculate mean square error after restoring the degraded red channel. In our case, we have provided a few high quality underwater images where the red channel was perfect (it has wide range of intensities). This way leads to have a reference and a degraded red channel image.

If you don’t want to degrade your underwater image, just uncomment the line with this command (im(:,:,1) = imref(:,:,1)) to undo what's done so far. If you bypass the degradation, your input image is restored in the next steps as it is. The reason behind this is to be able to calculate mean squared error between the main red channel and the degraded red channel. This way avoids requiring visual inspection of the restored image. Before any restoration, 'underwater.m' calculates the mean squared error between the initial and the degraded red channel as well as printing the MSE at command line. Then, when the restoration process completed, we can compute the MSE to compare the efficiency of the restoration method.

•	mediumtransmissionMat (im, gs, method)

This function calculates the medium transmission matrix with available methods provided in scientific papers. 

The first input argument is the input underwater image in unity (0-1) range and double data type. The second argument is the grid size for local patch. The patch will be a square with gs as its length/width. The 3rd argument for medium transmission calculation (e.g. 1 is UDCP and 2 is IATP).

Values for 3rd argument:

1	=	UDCP [2]

2	=	IATP [3]


•	saliency_detection(img,method)


Saliency detection is an effective way to determine objects and separate them from the background. Machine vision systems extract general purpose saliency as facing unpredictable and innumerable categories of visual patterns. The main idea behind the use of saliency extraction is that it is been experientially found that the salient regions of the medium transmission estimated by IATP or UDCP are relatively accurate.

Saliency detectors have long been used in machine vision systems. There are numerous proposed saliency detectors in scientific journals. Therefore, we are trying to evaluate some of them in function altogether. The saliency detection function provided in our source code, contains a few popular saliency detectors that you can choose them by specifying a number (e.g. 1,2,…) to the 2nd argument.

Option	      Reference	

1		      [4]

2		      [5]



•	myevaluations(im,imref,method)

This function holds all the methods and their variants. The first input is the degraded red channel in case you want to measure the mean squared error instead of visual inspection. Since the red channel of the first input is artificially degraded, we can measure the difference between the restored and the reference images. In this case, the reference image must be perfect. Otherwise you can copy the reference/initial image in the first argument to bypass error measurement.

**Method 1.01:**

The work that is done in this Method 1.01 and its variants is described in [1]. This variant computations process can be charted as below: 

•	Normalized UDCP Medium Transmission Matrix

•	Normalized Saliency Map for UDCP Matrix

•	4-Level Gaussian Pyramid for Normalized Saliency Map

•	4-Level Residual Pyramid for Normalized UDCP Matrix

•	Normalized IATP Medium Transmission Matrix

•	Normalized Saliency Map for IATP Matrix

•	4-Level Gaussian Pyramid for Normalized Saliency Map

•	4-Level Residual Pyramid for Normalized IATP Matrix

•	Multiplying UDCP Saliency Pyramid by UDCP Residual Pyramid to Build UDCP Pyramid

•	Reconstructing UDCP Pyramid to Build Refined UDCP Matrix + Normalization

•	Scene Depth by Log (Refined UDCP Matrix)/Log (0.8) Eq.16 [1]

•	Final UDCP Matrix by 0.85^ (Scene Depth) Eq.17 [1]

•	Get Restored Red Channel Intensities with Final UDCP Matrix Eq.18 [1]

•	Multiplying IATP Saliency Pyramid by IATP Residual Pyramid to Build IATP Pyramid

•	Reconstructing IATP Pyramid to Build Refined IATP Matrix + Normalization

•	Scene Depth by Log (Refined IATP Matrix)/Log (0.8) Eq.16 [1]

•	Final IATP Matrix by 0.85^ (Scene Depth) Eq.17 [1]

•	Get Restored Red Channel Intensities with Final IATP Matrix Eq.18 [1]

•	Joint UDCP + IATP Pyramids as Summation of Corresponding Pyramids

•	Reconstructing Joint UDCP + IATP Pyramid to Build Joint UDCP + IATP Matrix + Normalization

•	Scene Depth by Log (Joint UDCP + IATP Matrix)/Log (0.8) Eq.16 [1]

•	Final Joint UDCP + IATP Matrix by 0.85^ (Scene Depth) Eq.17 [1]

•	Get Restored Red Channel Intensities with Final Joint UDCP + IATP Matrix Eq.18 [1]


**Method 1.02:**

Since Residual pyramid contains negative values, each pyramid will have negative values too. In this case, the pyramids are normalized to unity 0-1 before reconstructing medium transmission matrix from.

•	Normalized UDCP Medium Transmission Matrix

•	Normalized Saliency Map for UDCP Matrix

•	4-Level Gaussian Pyramid for Normalized Saliency Map

•	4-Level Residual Pyramid for Normalized UDCP Matrix

•	Normalized IATP Medium Transmission Matrix

•	Normalized Saliency Map for IATP Matrix

•	4-Level Gaussian Pyramid for Normalized Saliency Map

•	4-Level Residual Pyramid for Normalized IATP Matrix

•	Multiplying UDCP Saliency Pyramid by UDCP Residual Pyramid to Build UDCP Pyramid + Normalizing 

•	Reconstructing UDCP Pyramid to Build Refined UDCP Matrix + Normalization

•	Scene Depth by Log (Refined UDCP Matrix)/Log (0.8) Eq.16 [1]

•	Final UDCP Matrix by 0.85^ (Scene Depth) Eq.17 [1]

•	Get Restored Red Channel Intensities with Final UDCP Matrix Eq.18 [1]

•	Multiplying IATP Saliency Pyramid by IATP Residual Pyramid to Build IATP Pyramid + Normalization

•	Reconstructing IATP Pyramid to Build Refined IATP Matrix + Normalization

•	Scene Depth by Log (Refined IATP Matrix)/Log (0.8) Eq.16 [1]

•	Final IATP Matrix by 0.85^ (Scene Depth) Eq.17 [1]

•	Get Restored Red Channel Intensities with Final IATP Matrix Eq.18 [1]

•	Joint UDCP + IATP Pyramids as Summation of Corresponding Pyramids + Normalization 

•	Reconstructing Joint UDCP + IATP Pyramid to Build Joint UDCP + IATP Matrix + Normalization

•	Scene Depth by Log (Joint UDCP + IATP Matrix)/Log (0.8) Eq.16 [1]

•	Final Joint UDCP + IATP Matrix by 0.85^ (Scene Depth) Eq.17 [1]

•	Get Restored Red Channel Intensities with Final Joint UDCP + IATP Matrix Eq.18 [1]



**Method 1.03:**

This method normalizes the pyramids before reconstruction. It also doesn't normalize the medium transmission matrix after it is generated by pyramid reconstruction step.


•	Normalized UDCP Medium Transmission Matrix

•	Normalized Saliency Map for UDCP Matrix

•	4-Level Gaussian Pyramid for Normalized Saliency Map

•	4-Level Residual Pyramid for Normalized UDCP Matrix

•	Normalized IATP Medium Transmission Matrix

•	Normalized Saliency Map for IATP Matrix

•	4-Level Gaussian Pyramid for Normalized Saliency Map

•	4-Level Residual Pyramid for Normalized IATP Matrix

•	Multiplying UDCP Saliency Pyramid by UDCP Residual Pyramid to Build UDCP Pyramid + Normalizing 

•	Reconstructing UDCP Pyramid to Build Refined UDCP Matrix

•	Scene Depth by Log (Refined UDCP Matrix)/Log (0.8) Eq.16 [1]

•	Final UDCP Matrix by 0.85^ (Scene Depth) Eq.17 [1]

•	Get Restored Red Channel Intensities with Final UDCP Matrix Eq.18 [1]

•	Multiplying IATP Saliency Pyramid by IATP Residual Pyramid to Build IATP Pyramid + Normalization

•	Reconstructing IATP Pyramid to Build Refined IATP Matrix 

•	Scene Depth by Log (Refined IATP Matrix)/Log (0.8) Eq.16 [1]

•	Final IATP Matrix by 0.85^ (Scene Depth) Eq.17 [1]

•	Get Restored Red Channel Intensities with Final IATP Matrix Eq.18 [1]

•	Joint UDCP + IATP Pyramids as Summation of Corresponding Pyramids + Normalization

•	Reconstructing Joint UDCP + IATP Pyramid to Build Joint UDCP + IATP Matrix

•	Scene Depth by Log (Joint UDCP + IATP Matrix)/Log (0.8) Eq.16 [1]

•	Final Joint UDCP + IATP Matrix by 0.85^ (Scene Depth) Eq.17 [1]

•	Get Restored Red Channel Intensities with Final Joint UDCP + IATP Matrix Eq.18 [1]



**Method 1.04:**

This method is almost completely alike to method 1.01. the only difference is in saliency detection algorithm. This is another saliency detection algorithm which is highly slow.

•	Normalized UDCP Medium Transmission Matrix

•	Normalized Saliency Map for UDCP Matrix

•	4-Level Gaussian Pyramid for Normalized Saliency Map

•	4-Level Residual Pyramid for Normalized UDCP Matrix

•	Normalized IATP Medium Transmission Matrix

•	Normalized Saliency Map for IATP Matrix

•	4-Level Gaussian Pyramid for Normalized Saliency Map

•	4-Level Residual Pyramid for Normalized IATP Matrix

•	Multiplying UDCP Saliency Pyramid by UDCP Residual Pyramid to Build UDCP Pyramid

•	Reconstructing UDCP Pyramid to Build Refined UDCP Matrix + Normalization

•	Scene Depth by Log (Refined UDCP Matrix)/Log (0.8) Eq.16 [1]

•	Final UDCP Matrix by 0.85^ (Scene Depth) Eq.17 [1]

•	Get Restored Red Channel Intensities with Final UDCP Matrix Eq.18 [1]

•	Multiplying IATP Saliency Pyramid by IATP Residual Pyramid to Build IATP Pyramid

•	Reconstructing IATP Pyramid to Build Refined IATP Matrix + Normalization

•	Scene Depth by Log (Refined IATP Matrix)/Log (0.8) Eq.16 [1]

•	Final IATP Matrix by 0.85^ (Scene Depth) Eq.17 [1]

•	Get Restored Red Channel Intensities with Final IATP Matrix Eq.18 [1]

•	Joint UDCP + IATP Pyramids as Summation of Corresponding Pyramids

•	Reconstructing Joint UDCP + IATP Pyramid to Build Joint UDCP + IATP Matrix + Normalization

•	Scene Depth by Log (Joint UDCP + IATP Matrix)/Log (0.8) Eq.16 [1]

•	Final Joint UDCP + IATP Matrix by 0.85^ (Scene Depth) Eq.17 [1]

•	Get Restored Red Channel Intensities with Final Joint UDCP + IATP Matrix Eq.18 [1]


**Method 1.05:**

This method is almost completely alike to method 1.02. the only difference is in saliency detection algorithm. This is another saliency detection algorithm which is highly slow.

•	Normalized UDCP Medium Transmission Matrix

•	Normalized Saliency Map for UDCP Matrix

•	4-Level Gaussian Pyramid for Normalized Saliency Map

•	4-Level Residual Pyramid for Normalized UDCP Matrix

•	Normalized IATP Medium Transmission Matrix

•	Normalized Saliency Map for IATP Matrix

•	4-Level Gaussian Pyramid for Normalized Saliency Map

•	4-Level Residual Pyramid for Normalized IATP Matrix

•	Multiplying UDCP Saliency Pyramid by UDCP Residual Pyramid to Build UDCP Pyramid + Normalizing 

•	Reconstructing UDCP Pyramid to Build Refined UDCP Matrix + Normalization

•	Scene Depth by Log (Refined UDCP Matrix)/Log (0.8) Eq.16 [1]

•	Final UDCP Matrix by 0.85^ (Scene Depth) Eq.17 [1]

•	Get Restored Red Channel Intensities with Final UDCP Matrix Eq.18 [1]

•	Multiplying IATP Saliency Pyramid by IATP Residual Pyramid to Build IATP Pyramid + Normalization

•	Reconstructing IATP Pyramid to Build Refined IATP Matrix + Normalization

•	Scene Depth by Log (Refined IATP Matrix)/Log (0.8) Eq.16 [1]

•	Final IATP Matrix by 0.85^ (Scene Depth) Eq.17 [1]

•	Get Restored Red Channel Intensities with Final IATP Matrix Eq.18 [1]

•	Joint UDCP + IATP Pyramids as Summation of Corresponding Pyramids + Normalization 

•	Reconstructing Joint UDCP + IATP Pyramid to Build Joint UDCP + IATP Matrix + Normalization

•	Scene Depth by Log (Joint UDCP + IATP Matrix)/Log (0.8) Eq.16 [1]

•	Final Joint UDCP + IATP Matrix by 0.85^ (Scene Depth) Eq.17 [1]

•	Get Restored Red Channel Intensities with Final Joint UDCP + IATP Matrix Eq.18 [1]



**Method 1.06:**

This method normalizes the pyramids before reconstruction. It also doesn't normalize the medium transmission matrix after it is generated by pyramid reconstruction step.


•	Normalized UDCP Medium Transmission Matrix

•	Normalized Saliency Map for UDCP Matrix

•	4-Level Gaussian Pyramid for Normalized Saliency Map

•	4-Level Residual Pyramid for Normalized UDCP Matrix

•	Normalized IATP Medium Transmission Matrix

•	Normalized Saliency Map for IATP Matrix

•	4-Level Gaussian Pyramid for Normalized Saliency Map

•	4-Level Residual Pyramid for Normalized IATP Matrix

•	Multiplying UDCP Saliency Pyramid by UDCP Residual Pyramid to Build UDCP Pyramid + Normalizing 

•	Reconstructing UDCP Pyramid to Build Refined UDCP Matrix

•	Scene Depth by Log (Refined UDCP Matrix)/Log (0.8) Eq.16 [1]

•	Final UDCP Matrix by 0.85^ (Scene Depth) Eq.17 [1]

•	Get Restored Red Channel Intensities with Final UDCP Matrix Eq.18 [1]

•	Multiplying IATP Saliency Pyramid by IATP Residual Pyramid to Build IATP Pyramid + Normalization

•	Reconstructing IATP Pyramid to Build Refined IATP Matrix 

•	Scene Depth by Log (Refined IATP Matrix)/Log (0.8) Eq.16 [1]

•	Final IATP Matrix by 0.85^ (Scene Depth) Eq.17 [1]

•	Get Restored Red Channel Intensities with Final IATP Matrix Eq.18 [1]

•	Joint UDCP + IATP Pyramids as Summation of Corresponding Pyramids + Normalization

•	Reconstructing Joint UDCP + IATP Pyramid to Build Joint UDCP + IATP Matrix

•	Scene Depth by Log (Joint UDCP + IATP Matrix)/Log (0.8) Eq.16 [1]

•	Final Joint UDCP + IATP Matrix by 0.85^ (Scene Depth) Eq.17 [1]

•	Get Restored Red Channel Intensities with Final Joint UDCP + IATP Matrix Eq.18 [1]




[1] 	Underwater Image Restoration Based On a New Underwater Image Formation Model

[2]   P. L. J. Drews, Jr., E. R. Nascimento, S. S. C. Botelho, and M. F. M. Campos, ‘‘Underwater depth estimation and image restoration based on single images,’’ IEEE Comput. Graph. Appl., vol. 36, no. 2, pp. 24–35, Mar./Apr. 2016.

[3]   N. Carlevaris-Bianco, A. Mohan, and R. M. Eustice, ‘‘Initial results in underwater single image dehazing,’’ in Proc. IEEE Conf. OCEANS, Sep. 2010, pp. 1–8.

[4]	http://ivrg.epfl.ch/supplementary_material/RK_CVPR09/index.html

[5]	https://www.epfl.ch/labs/ivrl/research/saliency/salient-region-detection-and-segmentation/

 
