void camera_init()
{
  cam = new PeasyCam(this, 1500);
  cam.lookAt(600, 500, 600);
  cam.setSuppressRollRotationMode();
  cam.setWheelScale(0.5);
  cam.setResetOnDoubleClick(false);
  cam.rotateX(radians(0));
  cam.rotateY(radians(30));
  cam.rotateZ(radians(0));
  cam.setMinimumDistance(150);
}
