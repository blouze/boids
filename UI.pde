import controlP5.*;
ControlP5 cp5;

class UI {
  UI(PApplet parent) {
    cp5 = new ControlP5(parent);
    cp5.setColorCaptionLabel(0);
    
    cp5.addSlider("ALIGNMENT")
      .setPosition(10, 10)
      .setRange(0, 5);
    
    cp5.addSlider("COHESION")
      .setPosition(10, 30)
      .setRange(0, 5);
    
    cp5.addSlider("SEPARATION")
      .setPosition(10, 50)
      .setRange(0, 5);
    
    cp5.addSlider("LOCAL_DIST")
      .setPosition(10, 70)
      .setRange(0, 100);
    
    cp5.addSlider("TRAILS")
      .setPosition(10, 90)
      .setRange(0.5, 0.8);
    
    cp5.setAutoDraw(false);  
  }
}
