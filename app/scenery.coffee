# Standard global variables
@scene = undefined
camera = undefined
renderer = undefined
controls = undefined
stats = undefined
keyboard = new THREEx.KeyboardState
clock = new THREE.Clock
gui = undefined

# Custom variables
viewerPosition = new THREE.Vector3(0.0, 0.0, 8.0)


@initGUI = () ->
  # Stats: FPS counter and more
  stats = new Stats
  stats.domElement.style.position = 'absolute'
  stats.domElement.style.bottom = '0px'
  stats.domElement.style.zIndex = 100
  @settings.container.appendChild stats.domElement


  # GUI: For easy variable changing and overall control of the application
  gui = new dat.GUI
  gui_parameters = {

  }
  gui.open()


  # Light source for our world
  light = new THREE.PointLight 0xffffff
  # light = new THREE.AmbientLight 0x111111
  light.position.set 0, 250, 0
  scene.add light


@initThree = () ->
  # Scene initialization
  @scene = new THREE.Scene

  # Camera initialization
  camera = new THREE.PerspectiveCamera @settings.VIEW_ANGLE, @settings.ASPECT, @settings.NEAR, @settings.FAR
  # camera.position.set 0, 150, 400
  camera.position.set 0, -150, 400
  # camera.lookAt scene.position
  scene.add camera

  # Renderer initialization
  renderer = new THREE.WebGLRenderer antialias: true
  renderer.setSize @settings.SCREEN_WIDTH, @settings.SCREEN_HEIGHT

  @settings.container.appendChild renderer.domElement

  # Window handlers
  THREEx.WindowResize renderer, camera
  THREEx.FullScreen.bindKey charCode: 'm'.charCodeAt(0)

  # Controls for moving around using mouse.
  controls = new THREE.OrbitControls camera, renderer.domElement

@render = () ->
  renderer.render scene, camera

@updateGUI = () ->
  delta = clock.getDelta

  controls.update()
  stats.update()
