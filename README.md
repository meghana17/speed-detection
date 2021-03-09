# Speed Detection using motion blurred images

Conventional speed measurement techniques use radar or laser based devices. Here, a single image captured with vehicle motion is used for speed measurement using a motion blur model for a moving object in front of a still background. Due to the relative motion between the camera and a moving object during the camera exposure time, motion blur occurs in the dynamic region of the image. It provides a visual cue for the speed measurement of a moving object. An approximate target region is first segmented and blur parameters are estimated from the motion blurred subimage. The image is then deblurred and used to derive other parameters. Finally, the vehicle speed is calculated according to the imaging geometry, camera pose, and blur extent in the image. 

Our experiments have shown the estimated speeds within 5% of actual speeds for both local and highway traffic.

![speed2](https://user-images.githubusercontent.com/14092419/110535803-b76d0080-8146-11eb-8591-adf14dae3d0f.png)


### Future work
1. Regularized iterative restoration methods will be incorporated to increase the robustness of our algorithm
2. More work will be done on taking the picture with the vehicle’s license plate for both the assistance of image restoration and the identification of the moving vehicle. In this case, a camera model with objects moving non-parallel to the image plane will be considered.
