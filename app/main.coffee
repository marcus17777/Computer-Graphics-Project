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


  if @settings.DEBUG
    cannonDebugRenderer = new THREE.CannonDebugRenderer @scene, @world

  objects = new CANNON.Group
  initGeometry()

  update()


update = () ->
  requestAnimationFrame update
  updateGUI()
  objects.update()
  updatePhysics()
  if @settings.DEBUG
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


  # sphereGeometry = new THREE.SphereGeometry 50, 32, 16
  # sphereMaterial = new THREE.MeshLambertMaterial color: 0x8888ff
  # sphereMesh = new THREE.Mesh sphereGeometry, sphereMaterial
  #
  # # sphereMesh.position.set(2, 2, 2)
  # sphere = new CANNON.MeshBody
  #   mesh: sphereMesh
  #   mass: 0.1
  #   # material: new CANNON.Material
  # sphere.addShape new CANNON.Sphere 50
  # sphere.position.set 100, 100, -50
  # # sphere.linearDamping = 0.1
  # # sphere.velocity.set 0, 0, 0
  #
  # @world.addBody sphere
  # @scene.add sphere.mesh
  # objects.add sphere
  #
  #
  # # Initialize floor
  # loader = new THREE.TextureLoader
  # floorTexture = loader.load 'images/checkerboard.jpg'
  # floorTexture.wrapS = floorTexture.wrapT = THREE.RepeatWrapping
  # floorTexture.repeat.set 10, 10
  #
  # floorGeometry = new THREE.PlaneGeometry 1000, 1000, 1, 1
  # floorMaterial = new THREE.MeshBasicMaterial map: floorTexture, side: THREE.DoubleSide
  # floorMesh = new THREE.Mesh floorGeometry, floorMaterial
  #
  # floor = new CANNON.Body
  #   mesh: floorMesh
  #   mass: 0
  #   # material: new CANNON.Material
  # floor.addShape new CANNON.Plane
  #
  # floor.quaternion.setFromAxisAngle(new CANNON.Vec3(1, 0, 0), Math.PI / 2)
  #
  # @world.addBody floor
  # # @scene.add floor.mesh
  # # objects.add floor


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
  scene.add groundMesh

  groundMaterial = new CANNON.Material
  groundShape = new CANNON.Plane
  groundBody = new CANNON.MeshBody
    mesh: groundMesh
    mass: 0
    material: groundMaterial
  groundBody.addShape groundShape
  groundBody.quaternion.setFromAxisAngle new CANNON.Vec3(1, 0, 0), -Math.PI / 2
  # groundBody.position.set(0, 0, 0)

  world.addBody groundBody
  objects.add groundBody

  # Shape on plane
  mat1 = new CANNON.Material
  mesh1 = new THREE.Mesh sphereGeometry, sphereMaterial
  shapeBody1 = new CANNON.MeshBody
    mass: mass
    material: mat1
    mesh: mesh1
  shapeBody1.addShape sphereShape
  shapeBody1.position.set 3*size, height, size
  shapeBody1.linearDamping = damping
  world.addBody shapeBody1
  objects.add shapeBody1
  scene.add mesh1
  # demo.addVisual(shapeBody1)

  mat2 = new CANNON.Material
  mesh2 = new THREE.Mesh sphereGeometry, sphereMaterial
  shapeBody2 = new CANNON.MeshBody
    mass: mass
    material: mat2
    mesh: mesh2
  shapeBody2.addShape sphereShape
  shapeBody2.position.set 0, height, size
  shapeBody2.linearDamping = damping
  world.addBody shapeBody2
  objects.add shapeBody2
  scene.add mesh2
  # demo.addVisual(shapeBody2)

  mat3 = new CANNON.Material
  mesh3 = new THREE.Mesh sphereGeometry, sphereMaterial
  shapeBody3 = new CANNON.MeshBody
    mass: mass
    material: mat3
    mesh: mesh3
  shapeBody3.addShape sphereShape
  shapeBody3.position.set -3*size - 5, height, size
  shapeBody3.linearDamping = damping
  world.addBody shapeBody3
  objects.add shapeBody3
  scene.add mesh3
  # demo.addVisual(shapeBody3)

  # Create contact material behaviour
  mat1_ground = new CANNON.ContactMaterial groundMaterial, mat1,
    friction: 0.0
    restitution: 0.0
  mat2_ground = new CANNON.ContactMaterial groundMaterial, mat2,
    friction: 0.0
    restitution: 0.7
  mat3_ground = new CANNON.ContactMaterial groundMaterial, mat3,
    friction: 0.0
    restitution: 0.9

  world.addContactMaterial mat1_ground
  world.addContactMaterial mat2_ground
  world.addContactMaterial mat3_ground
