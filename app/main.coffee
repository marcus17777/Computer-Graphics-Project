class @Game
  constructor: () ->
    objects = undefined
    cannonDebugRenderer = undefined


@Game.init = () ->
  console.log "init"
  @initThree()
  @initCannon()
  @initGUI()


  console.log @scene
  console.log @world


  if @settings.DEBUG
    @cannonDebugRenderer = new THREE.CannonDebugRenderer @scene, @world

  @objects = new CANNON.Group
  @initGeometry()




  @update()


@Game.update = () ->
  requestAnimationFrame () => @update()
  @updateGUI()
  @objects.update()
  @updatePhysics()
  # console.log @helper
  # console.log @helper.box.getSize()
  # console.log @racket.position
  if @settings.DEBUG
    @cannonDebugRenderer.update()
  @render()


@Game.addMeshBody = (obj) ->
  @world.add obj
  @scene.add obj.mesh
  @objects.add obj


@Game.initGeometry = () ->
  console.log @objects

  # Initialize sky
  # skyBoxGeometry = new THREE.CubeGeometry 10000, 10000, 10000
  # skyBoxMaterial = new THREE.MeshBasicMaterial color: 0x9999ff, side: THREE.BackSide
  # skyBox = new THREE.Mesh skyBoxGeometry, skyBoxMaterial
  # scene.add skyBox

  @scene.fog = new THREE.FogExp2 0x9999ff, 0.00025


  mass = 10
  size = 10
  height = 100
  damping = 0.01


  sphereShape = new CANNON.Sphere size


  sphereGeometry = new THREE.SphereGeometry size, 32, 16
  sphereMaterial = new THREE.MeshLambertMaterial color: 0x8888ff

  loader = new THREE.TextureLoader
  groundTexture = loader.load 'images/checkerboard.jpg'
  groundTexture.wrapS = groundTexture.wrapT = THREE.RepeatWrapping
  groundTexture.repeat.set 100, 100

  groundGeometry = new THREE.PlaneGeometry 10000, 10000, 1, 1
  groundMaterial = new THREE.MeshBasicMaterial map: groundTexture, side: THREE.DoubleSide
  groundMesh = new THREE.Mesh groundGeometry, groundMaterial
  console.log groundMesh

  groundMaterial = new CANNON.Material
  groundShape = new CANNON.Plane
  groundBody = new CANNON.MeshBody
    mesh: groundMesh
    mass: 0
    material: groundMaterial
  groundBody.addShape groundShape
  groundBody.quaternion.setFromAxisAngle new CANNON.Vec3(1, 0, 0), -Math.PI / 2

  this.addMeshBody groundBody


  ball = new @Ball
    radius: 10
    mass: 0.5
    callback: (obj) =>
      obj.position.set 0, 100, 0
      @addMeshBody obj

  # ball2 = new @Ball
  #   radius: 10
  #   mass: 1
  #   callback: (obj) =>
  #     obj.position.set 10, 500, 0
  #     @addMeshBody obj

  racket = new @Racket
    serving_force: 4000
    callback: (obj) =>
      obj.position.set 50, 100, 0
      @addMeshBody obj
      obj.quaternion.setFromVectors new CANNON.Vec3(-1, 1, 0), new CANNON.Vec3(0, -1, -1)
      obj.catch(ball)


      # @helper = new THREE.BoundingBoxHelper(racket.mesh, 0xff0000)
      # @helper.update()
      # @scene.add @helper
      # console.log @helper
      # @objects.add @helper

  @racket = racket


  racketbot = new @RacketBot



    serving_force: 4000
    callback: (obj) =>
      obj.setTrack ball
      obj.position.set 0, 200, 0
      @addMeshBody obj
      obj.quaternion.setFromVectors new CANNON.Vec3(-1, 1, 0), new CANNON.Vec3(0, -1, -1)



  table = new @Table
    callback: (obj) =>
      @addMeshBody obj


  tableball = new CANNON.ContactMaterial table, ball.material,
      friction: 0.0
      restitution: 1.0
  racketball = new CANNON.ContactMaterial racket, ball.material,
      friction: 0.0
      restitution: 1.0
  racketbotball = new CANNON.ContactMaterial racketbot, ball.material,
      friction: 0.0
      restitution: 1.0

  @world.addContactMaterial tableball
  @world.addContactMaterial racketball
  @world.addContactMaterial racketbotball








  self = @
  document.getElementById(@settings.containerID).addEventListener 'mousemove', (event) ->

    X = (event.pageX - this.offsetLeft) - this.offsetWidth / 2
    Y = (event.pageY - this.offsetTop) - this.offsetHeight / 2
    X = (X / this.offsetWidth) * 2 #- 1
    Y = -(Y / this.offsetHeight) * 2 #+ 1
    Z = -0
    pos = new THREE.Vector3 X, Y, Z

    pos.unproject(self.camera)
    dir = pos.clone().sub(self.camera.position).normalize()
    pos.add dir.clone().multiplyScalar(1000)

    racket.position.set pos.x, pos.y, pos.z

  document.getElementById(@settings.containerID).addEventListener 'mouseup', (event) ->
    if event.which == 1
      racket.serve(ball)
    else if event.which == 3
      racket.catch(ball)
