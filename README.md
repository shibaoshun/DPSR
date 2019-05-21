
# [Deep prior-based sparse representation model for diffraction imaging: A plug-and-play method]
Authors： Baoshun Shi, Qiusheng Lian,  Huibin Chang

A coded diffraction imaging method is proposed by using the proposed DPSR model in this paper. A demo code for sub-pixel resolution diffraction imaging is provided in this package. This paper is submitted to the journal “IEEE Transactions on Computational Imaging”. Software copyright registration number： 2019SR0452742.
If you use this code, please contact me. 
The email address is  shibaoshun@ysu.edu.cn.

# Requirements and Dependencies
- MATLAB R2018b
- [Cuda](https://developer.nvidia.com/cuda-toolkit-archive)-8.0 & [cuDNN](https://developer.nvidia.com/cudnn) v-6.1
- [MatConvNet](http://www.vlfeat.org/matconvnet/)

Run the following m function to test the model.
-Demo_sub_pixel_resolution_Imaging


#Note
-1. If you use the FFDnet denoiser, you must add the correct path of the MatConvNet toolbox into the demo code. MatConvNet must be compiled before it can be used.

-2. Since the noise is random, the PSNR may be perturbed. This phenomenon is reasonable for non-convex problems.

