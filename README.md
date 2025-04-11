README

this MLModelEval App has 3 ml models which are pre trained
In this app, the user is allowed to select n number of images from their gallery or from online api which is free
then after we will iterate through the n images, one after other
where for each iteration, the image will be displayed, below to it, 3 card views for each ml model to show their prediction n accuracy.
At the bottom of the screen we will have 4 buttons 
One for each ml model and one which says "None"
These 4 buttons are for user to vote which one came close to predicting the right answer
This voting will be done for each iteration 
At the end we will move to the results page where we will display the winner model 

Steps to install:
1. Clone the repo
2. Download the ml models for apple ml library (because of size, they were not allowed to be pushed)
3. Put the ml models into directory - MLModels
4. Run the app 

Ml models used:
Yolov3FP16
MobileNetV2
ResNet-50
