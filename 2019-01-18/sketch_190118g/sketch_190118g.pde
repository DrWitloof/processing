
size(225,225);

PImage sunflower = loadImage("sunflower.jpg");
PImage dog = loadImage("dog.jpg");

background(dog);

// The image retains its original state.
tint(255,255,0,130);  
image(sunflower,(width-sunflower.width)/2,(height-sunflower.height)/2);
