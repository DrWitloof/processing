/**
 * Robot Screenshots (v2.23)
 * by  Amnon (2014/Nov/11)
 * mod GoToLoop
 *
 * Forum.Processing.org/two/discussion/8025/
 * take-a-screen-shot-of-the-screen#Item_8
 */
 
import java.awt.Rectangle;
import java.awt.Robot;
import java.awt.AWTException;
 
PImage screenshot;
Rectangle dimension;
Robot robot;
 
void setup() {
  size(600, 350);
 
  smooth(3);
  frameRate(.5);
 
  colorMode(RGB);
  imageMode(CORNER);
  background((color) random(#000000));
 
  screenshot = createImage(displayWidth, displayHeight, ARGB);
  dimension  = new Rectangle(displayWidth, displayHeight);
 
  try {
    robot = new Robot();
  }
  catch (AWTException cause) {
    println(cause);
    exit();
  }
}
 
void draw() {
  image(grabScreenshot(screenshot, dimension, robot), 0, 0, width, height);
}
 
static final PImage grabScreenshot(PImage img, Rectangle dim, Robot bot) {
  //return new PImage(bot.createScreenCapture(dim));
 
  bot.createScreenCapture(dim).getRGB(0, 0
    , dim.width, dim.height
    , img.pixels, 0, dim.width);
 
  img.updatePixels();
  return img;
}
