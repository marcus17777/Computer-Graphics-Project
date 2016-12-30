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
  document.getElementById(@settings.containerID).append @stats.domElement


  # GUI: For easy variable changing and overall control of the application
  @gui = new dat.GUI
  @gui_parameters = {}
  @gui.open()


  # Light source for our world
  light = new THREE.PointLight 0xffffff
  # light = new THREE.AmbientLight 0x111111
  light.position.set 0, 250, 0
  @scene.add light


@Game.initThree = () ->
  # Scene initialization
  @scene = new THREE.Scene

  # Camera initialization
  VIEW_ANGLE = @settings.VIEW_ANGLE
  ASPECT = @settings.SCREEN_WIDTH / @settings.SCREEN_HEIGHT
  NEAR = @settings.NEAR
  FAR = @settings.FAR

  @camera = new THREE.PerspectiveCamera VIEW_ANGLE, ASPECT, NEAR, FAR
  @camera.position.set 0, 150, 400
  # camera.position.set 0, -150, 400
  @camera.lookAt @scene.position
  @scene.add @camera

  # Renderer initialization
  @renderer = new THREE.WebGLRenderer antialias: true
  @renderer.setSize @settings.SCREEN_WIDTH, @settings.SCREEN_HEIGHT

  document.getElementById(@settings.containerID).appendChild @renderer.domElement

  # Window handlers
  THREEx.WindowResize @renderer, @camera
  THREEx.FullScreen.bindKey charCode: 'm'.charCodeAt(0)

  # Controls for moving around using mouse.
  @controls = new THREE.OrbitControls @camera, @renderer.domElement

@Game.render = () ->
  @renderer.render @scene, @camera

@Game.updateGUI = () ->
  @delta = @clock.getDelta

  @controls.update()
  @stats.update()
