//package autobot;

import com.cycling74.max.*;
import java.awt.*;
import java.awt.event.InputEvent;
import java.awt.event.KeyEvent;

public class Autobot extends MaxObject {
  
   private Robot rob;
   
   public Autobot() {
      declareInlets(new int[] {DataTypes.MESSAGE});
      declareOutlets(new int[] {DataTypes.MESSAGE});
      setInletAssist(0, "Messages for robot");
      setOutletAssist(0, "Out");
      this.createInfoOutlet(false);
      try { 
         rob = new Robot();
         rob.setAutoDelay(10);
      } catch (AWTException awte) {
         bail(awte.toString());
      }
   }
      
   private int getMouseButtonMask(int button) {
      int mask = 0;
      if (button == 1)
         mask = InputEvent.BUTTON1_MASK;
      else if (button == 2)
         mask = InputEvent.BUTTON2_MASK;
      else if (button == 3)
         mask = InputEvent.BUTTON3_MASK;
      return mask;
   }
   
   public void getpixelcolor(int x, int y) {
      outlet(0, "rgb", rob.getPixelColor(x, y).getColorComponents(null));
   }
   
   public void keypress(int i) {
      try {
         rob.keyPress(i);
         rob.keyRelease(i);
      } catch (IllegalArgumentException iae) {
         error(iae.getMessage());
      }
   }
   
   public void keydown(int i) {
      try {
         rob.keyPress(i);
      } catch (IllegalArgumentException iae) {
         error(iae.getMessage());
      }
   }
   
   public void keyup(int i) {
      try {
         rob.keyRelease(i);
      } catch (IllegalArgumentException iae) {
         error(iae.getMessage());
      }
   }
   
   public void modshift(boolean b) {
      if (b)
         rob.keyPress(KeyEvent.VK_SHIFT);
      else
         rob.keyRelease(KeyEvent.VK_SHIFT);
   }
   
   public void modctrl(boolean b) {
      if (b)
         rob.keyPress(KeyEvent.VK_CONTROL);
      else
         rob.keyRelease(KeyEvent.VK_CONTROL);
   }
   
   public void modalt(boolean b) {
      if (b)
         rob.keyPress(KeyEvent.VK_ALT);
      else
         rob.keyRelease(KeyEvent.VK_ALT);
   }
   
   public void mousemove(int x, int y) {
      rob.mouseMove(x, y);
   }

   public void mousemoverelative(int x, int y) {
       Point location = MouseInfo.getPointerInfo().getLocation();
       location.translate(x, y);
       rob.mouseMove((int)location.getX(), (int)location.getY());
   }
   
   public void mousewheel(int amount) {
      rob.mouseWheel(amount);
   }
   
   public void mouseclick(int i) {
      if (i >= 1 && i <=3) {
         rob.mousePress(getMouseButtonMask(i));
         rob.mouseRelease(getMouseButtonMask(i));
      }
   }
   
   public void mousebuttondown(int i) {
      if (i >= 1 && i <=3)
         rob.mousePress(getMouseButtonMask(i));
   }
   
   public void mousebuttonup(int i) {
      if (i >= 1 && i <=3)
         rob.mouseRelease(getMouseButtonMask(i));
   }
      
   public void getmouselocation() {
      Point location = MouseInfo.getPointerInfo().getLocation();
      int[] ans = new int[] {(int)location.getX(), (int)location.getY()};
      outlet(0, "location", ans);
   }
   
   public void cursorvisible(boolean b) {
      if (b)
         MaxSystem.showCursor();
      else
         MaxSystem.hideCursor();
   }
   
}


