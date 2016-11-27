objects = undefined
cannonDebugRenderer = undefined

@init = () ->
  console.log "init"
  @settings.init()
  @initThree()
  @initCannon()
  @initGUI()

  console.log @scene
  console.log @world
  cannonDebugRenderer = new THREE.CannonDebugRenderer @scene, @world

  objects = new CANNON.Group
  initGeometry()

  update()


update = () ->
  requestAnimationFrame update
  updateGUI()
  objects.update()
  updatePhysics()
  cannonDebugRenderer.update()
  render()


initGeometry = () ->
  console.log objects

  # Initialize sky
  # skyBoxGeometry = new THREE.CubeGeometry 10000, 10000, 10000
  # skyBoxMaterial = new THREE.MeshBasicMaterial color: 0x9999ff, side: THREE.BackSide
  # skyBox = new THREE.Mesh skyBoxGeometry, skyBoxMaterial
  # scene.add skyBox

  @scene.fog = new THREE.FogExp2 0x9999ff, 0.00025

  # Initialize floor
  loader = new THREE.TextureLoader
  floorTexture = loader.load 'images/checkerboard.jpg'
  floorTexture.wrapS = floorTexture.wrapT = THREE.RepeatWrapping
  floorTexture.repeat.set 10, 10

  floorGeometry = new THREE.PlaneGeometry 1000, 1000, 1, 1
  floorMaterial = new THREE.MeshBasicMaterial map: floorTexture, side: THREE.DoubleSide
  floorMesh = new THREE.Mesh floorGeometry, floorMaterial

  floor = new CANNON.MeshBody
    mesh: floorMesh
    mass: 0
    material: new CANNON.Material
  floor.addShape new CANNON.Plane

  floor.quaternion.setFromAxisAngle(new CANNON.Vec3(1, 0, 0), Math.PI / 2)

  world.addBody floor
  scene.add floor.mesh
  objects.add floor




  sphereGeometry = new THREE.SphereGeometry 50, 32, 16
  sphereMaterial = new THREE.MeshLambertMaterial color: 0x8888ff
  sphereMesh = new THREE.Mesh sphereGeometry, sphereMaterial

  # sphereMesh.position.set(2, 2, 2)

  sphere = new CANNON.MeshBody
    mesh: sphereMesh
    mass: 0.0000001
    material: new CANNON.Material
  sphere.addShape new CANNON.Sphere 50
  sphere.position.set 100, 100, -50
  sphere.linearDamping = 0.1


  world.addBody sphere
  scene.add sphere.mesh
  objects.add sphere
