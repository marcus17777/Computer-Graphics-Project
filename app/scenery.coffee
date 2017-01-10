# Standard global variables
@Game.scene = undefined
@Game.camera = undefined
@Game.renderer = undefined
@Game.controls = undefined
@Game.stats = undefined
@Game.keyboard = new THREEx.KeyboardState
@Game.clock = new THREE.Clock
@Game.gui = undefined

# Custom variables
@Game.viewerPosition = new THREE.Vector3(0.0, 0.0, 8.0)


@Game.initGUI = () ->
  # Stats: FPS counter and more
  @stats = new Stats
  @stats.domElement.style.position = 'absolute'
  @stats.domElement.style.bottom = '0px'
  @stats.domElement.style.zIndex = 100
  document.getElementById(@settings.containerID).appendChild @stats.domElement


  # GUI: For easy variable changing and overall control of the application
  gui = new dat.GUI
  settings = gui.addFolder 'Settings'
  settings.add @settings, 'TIMESTEP'
  # settings.open()


  @gui = gui

@Game.initThree = () ->
  # Scene initialization
  @scene = new THREE.Scene

  # Camera initialization
  VIEW_ANGLE = @settings.VIEW_ANGLE
  ASPECT = @settings.SCREEN_WIDTH / @settings.SCREEN_HEIGHT
  NEAR = @settings.NEAR
  FAR = @settings.FAR

  @camera = new THREE.PerspectiveCamera VIEW_ANGLE, ASPECT, NEAR, FAR
  @camera.position.set 0, 400, 1700
  # camera.position.set 0, -150, 400
  @camera.lookAt @scene.position
  @scene.add @camera

  @projector = new THREE.Projector

  # Renderer initialization
  @renderer = new THREE.WebGLRenderer antialias: true
  @renderer.setSize @settings.SCREEN_WIDTH, @settings.SCREEN_HEIGHT

  document.getElementById(@settings.containerID).appendChild @renderer.domElement

  # Window handlers
  THREEx.WindowResize @renderer, @camera
  THREEx.FullScreen.bindKey charCode: 'm'.charCodeAt(0)

  # Controls for moving around using mouse.
  if @settings.DEBUG
    @controls = new THREE.OrbitControls @camera, @renderer.domElement

  # Light source for our world
  light = new THREE.PointLight 0xffffff
  # light = new THREE.AmbientLight 0x111111
  light.position.set 0, 250, 0
  @scene.add light

  light2 = new THREE.PointLight 0xffffff
  # light = new THREE.AmbientLight 0x111111
  light2.position.set -200, 250, 0
  @scene.add light2


@Game.render = () ->
  @renderer.render @scene, @camera

@Game.updateGUI = () ->
  @delta = @clock.getDelta

  if @settings.DEBUG
    @controls.update()
  @stats.update()
