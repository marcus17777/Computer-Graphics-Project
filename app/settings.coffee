@Game.settings = {

  DEBUG: false

  # Appcontainer: an element in html document that holds our 3D application
  containerID : 'appContainer'

  ## Three.js options
  # Screen specific options
  SCREEN_WIDTH : window.innerWidth
  SCREEN_HEIGHT : window.innerHeight

  # Camera specific options
  VIEW_ANGLE : 45
  NEAR : 0.1
  FAR : 10000


  ## Cannon.js options
  GRAVITY : {
    'x' : 0
    'y' : -9.8
    'z' : 0
  }
  TIMESTEP : 1 / 10  #1 / 60

}
