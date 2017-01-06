@Game ||= {}


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
  if @settings.DEBUG
    @cannonDebugRenderer.update()
  @render()


@Game.initGeometry = () ->
  console.log @objects

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
  size = 1
  height = 100
  damping = 0.01
  sphereShape = new CANNON.Sphere size

  # reket = new CANNON.Trimesh

  sphereGeometry = new THREE.SphereGeometry size, 32, 16
  sphereMaterial = new THREE.MeshLambertMaterial color: 0x8888ff

  loader = new THREE.TextureLoader
  groundTexture = loader.load 'images/checkerboard.jpg'
  groundTexture.wrapS = groundTexture.wrapT = THREE.RepeatWrapping
  groundTexture.repeat.set 100, 100

  groundGeometry = new THREE.PlaneGeometry 10000, 10000, 1, 1
  groundMaterial = new THREE.MeshBasicMaterial map: groundTexture, side: THREE.DoubleSide
  groundMesh = new THREE.Mesh groundGeometry, groundMaterial
  @scene.add groundMesh

  groundMaterial = new CANNON.Material
  groundShape = new CANNON.Plane
  groundBody = new CANNON.MeshBody
    mesh: groundMesh
    mass: 0
    material: groundMaterial
  groundBody.addShape groundShape
  groundBody.quaternion.setFromAxisAngle new CANNON.Vec3(1, 0, 0), -Math.PI / 2
  # groundBody.position.set(0, 0, 0)

  @world.addBody groundBody
  @objects.add groundBody

<<<<<<< HEAD

  console.log @

  ball = new @Ball size: 10, mass: 10, position: [0, 100, 0]
  @objects.add ball
  @world.add ball
  @scene.add ball.mesh

  # # Shape on plane
  # mat1 = new CANNON.Material
  # mesh1 = new THREE.Mesh sphereGeometry, sphereMaterial
  # shapeBody1 = new CANNON.MeshBody
  #   mass: mass
  #   material: mat1
  #   mesh: mesh1
  # shapeBody1.addShape sphereShape
  # shapeBody1.position.set 3*size, height, size
  # shapeBody1.linearDamping = damping
  # @world.addBody shapeBody1
  # @objects.add shapeBody1
  # @scene.add mesh1
  #
  # mat2 = new CANNON.Material
  # mesh2 = new THREE.Mesh sphereGeometry, sphereMaterial
  # shapeBody2 = new CANNON.MeshBody
  #   mass: 0
  #   material: mat2
  #   mesh: mesh2
  # shapeBody2.addShape sphereShape
  # shapeBody2.position.set 0, height, size
  # shapeBody2.linearDamping = damping
  # @world.addBody shapeBody2
  # @objects.add shapeBody2
  # @scene.add mesh2
  #
=======
  # bunnyBody = new CANNON.Body({ mass: 1 })
  # console.log window
  # for i in [0..window.bunny.length - 1] by 1
  #   console.log window.bunny[i]
  #   rawVerts = window.bunny[i].verts
  #   rawFaces = window.bunny[i].faces
  #   rawOffset = window.bunny[i].offset
  #
  #   verts=[]
  #   faces=[]
  #   offset=[]
  #
  # for i in [0..rawVerts.length] by 1
  #   verts.push(new CANNON.Vec3( rawVerts[i]  ,rawVerts[i+1],  rawVerts[i+2]))
  #
  #
  #
  # for i in [0..rawFaces.length] by 1
  #   faces.push([rawFaces[i],rawFaces[i+1],rawFaces[i+2]])
  #
  #
  # offset = new CANNON.Vec3(rawOffset[0],rawOffset[1],rawOffset[2])
  #
  #
  # bunnyPart = new CANNON.ConvexPolyhedron(verts,faces)
  #
  #
  # bunnyBody.addShape(bunnyPart,offset)


  bunnyBody = new (CANNON.MeshBody)(mass: 0)
  geom = new THREE.Geometry()
  i = 0
  while i < bunny.length
    rawVerts = bunny[i].verts
    rawFaces = bunny[i].faces
    rawOffset = bunny[i].offset
    verts = []
    faces = []
    offset = undefined
    # Get vertices
    j = 0
    while j < rawVerts.length
      verts.push new (CANNON.Vec3)(rawVerts[j], rawVerts[j + 1], rawVerts[j + 2])
      geom.vertices.push(new THREE.Vector3 rawVerts[j], rawVerts[j + 1], rawVerts[j + 2])
      j += 3
    # Get faces
    j = 0
    while j < rawFaces.length
      faces.push [
        rawFaces[j]
        rawFaces[j + 1]
        rawFaces[j + 2]
      ]
      geom.faces.push( new THREE.Face3( rawFaces[j], rawFaces[j + 1], rawFaces[j + 2] ) )
      j += 3
    # Get offset
    offset = new (CANNON.Vec3)(rawOffset[0], rawOffset[1], rawOffset[2])
    # Construct polyhedron
    bunnyPart = new (CANNON.ConvexPolyhedron)(verts, faces)
    # Add to compound
    bunnyBody.addShape bunnyPart, offset
    i++


  buianasd = new THREE.Mesh( geom, new THREE.MeshLambertMaterial color: 0x8888ff )
  bunnyBody.mesh = buianasd
  bunnyBody.position.set 0, 100, 0
  buianasd.scale.set 100, 100, 100
  @scene.add(buianasd)
  @world.addBody bunnyBody
  @objects.add bunnyBody





  # mesh = null
  #
  # reket_url = "models/reketfull.json"
  # loader = new THREE.JSONLoader
  # loader.load reket_url, (geometry) =>
  #   material = new THREE.MeshLambertMaterial color: 0x8888ff
  #   mesh = new THREE.Mesh geometry, material
  #   mesh.position.set 0, 100, 0
  #   @scene.add mesh
  #   console.log mesh
  #
  #   client = new window.HttpClient()
  #   client.get "models/reketfull.json", (response) =>
  #     json = JSON.parse response
  #
  #     console.log json
  #
  #     reketBody = new CANNON.MeshBody
  #       mass: 1
  #       mesh: mesh
  #
  #
  #     verts = []
  #     faces = []
  #
  #     console.log new CANNON.Vec3 0, 2, 3
  #
  #
  #     for j in[0..json.vertices.length] by 3
  #       verts.push(new CANNON.Vec3(json.vertices[j],
  #                                   json.vertices[j+1],
  #                                   json.vertices[j+2]))
  #
  #     # get faces
  #     for j in[0..json.faces.length] by 3
  #       faces.push(json.faces[j], json.faces[j+1], json.faces[j+2])
  #
  #     reketParts = new CANNON.ConvexPolyhedron(verts, faces)
  #
  #     reketBody.addShape(reketParts)
  #     @objects.add reketBody
  #     @world.add reketBody
  #

  # reket = undefined
  #
  #
  # mtlLoader = new THREE.MTLLoader()
  # mtlLoader.crossOrigin = 'Anonymous'
  # mtlLoader.load 'models/reketfull24.mtl', (materials) =>
  #   objLoader = new (THREE.OBJLoader)
  #   objLoader.crossOrigin = 'Anonymous'
  #   objLoader.setMaterials materials
  #   objLoader.load 'models/reketfull24.obj', (object) =>
  #     object.position.x = -60
  #     object.rotation.x = -20
  #     object.scale.x = 30
  #     object.scale.y = 30
  #     object.scale.z = 30
  #     reket = object
  #     reket.position.y = 30
  #     reket.position.x = 30
  #     reket.position.z = 30
  #
  #     console.log @world
  #
  #     @scene.add (reket)
  #     console.log reket
  #     console.log reket.geometry





  # reketBody = new CANNON.Body({mass : 1 })
  # for i in [0..reket.length] by 1
  #   rawVerts = reket[i].verts
  #   rawFaces = reket[i].faces
  #   rawOffset = reket[i].offset
  # verts = []
  # faces = []
  #
  #
  # console.log rawVerts
  # # get vertices
  # for j in[0..rawVerts.length] by 3
  #   verts.push(new CANNON.Vec3(rawVerts[j],
  #                               rawVerts[j+1],
  #                               rawVerts[j+2]))
  #
  # # get faces
  # for j in[0..rawFaces.length] by 3
  #   faces.push(rawFaces[j], rawFaces[j+1], rawFaces[j+2])
  #
  # offset = new CANNON.Vec3(rawOffset[0], rawOffset[1], rawOffset[2])
  #
  # reketParts = new CANNON.ConvexPolyhedron(verts, faces)
  #
  # reketBody.addShape(reketParts, offset)




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
  @world.addBody shapeBody1
  @objects.add shapeBody1
  @scene.add mesh1

  mat2 = new CANNON.Material
  mesh2 = new THREE.Mesh sphereGeometry, sphereMaterial
  shapeBody2 = new CANNON.MeshBody
    mass: 1
    material: mat2
    mesh: mesh2
  shapeBody2.addShape sphereShape
  shapeBody2.position.set 0, height, size
  shapeBody2.linearDamping = damping
  @world.addBody shapeBody2
  @objects.add shapeBody2
  @scene.add mesh2

>>>>>>> 2965a717c84d552746c346ac3d527a1a389a8174
  # mat3 = new CANNON.Material
  # mesh3 = new THREE.Mesh sphereGeometry, sphereMaterial
  # shapeBody3 = new CANNON.MeshBody
  #   mass: mass
  #   material: mat3
  #   mesh: mesh3
  # shapeBody3.addShape sphereShape
  # shapeBody3.position.set -3*size - 5, height, size
  # shapeBody3.linearDamping = damping
  # @world.addBody shapeBody3
  # @objects.add shapeBody3
  # @scene.add mesh3

  # Create contact material behaviour
<<<<<<< HEAD
  # mat1_ground = new CANNON.ContactMaterial groundMaterial, mat1,
  #   friction: 0.0
  #   restitution: 0.0
  # mat2_ground = new CANNON.ContactMaterial groundMaterial, mat2,
  #   friction: 0.0
  #   restitution: 0.7
=======
  mat1_ground = new CANNON.ContactMaterial groundMaterial, mat1,
    friction: 0.0
    restitution: 0.99
  mat2_ground = new CANNON.ContactMaterial groundMaterial, mat2,
    friction: 0.0
    restitution: 0.7
>>>>>>> 2965a717c84d552746c346ac3d527a1a389a8174
  # mat3_ground = new CANNON.ContactMaterial groundMaterial, mat3,
  #   friction: 0.0
  #   restitution: 0.9

  # @world.addContactMaterial mat1_ground
  # @world.addContactMaterial mat2_ground
  # @world.addContactMaterial mat3_ground

<<<<<<< HEAD
  # self = @
  # document.getElementById(@settings.containerID).addEventListener 'mousemove', (event) ->
  #   # mouseX = (event.clientX - window.)
  #   # shapeBody1.position.set
  #
  #   X = (event.pageX - this.offsetLeft) - this.offsetWidth / 2
  #   Y = (event.pageY - this.offsetTop) - this.offsetHeight / 2
  #   # Z = 0.5
  #   X = (X / this.offsetWidth) * 2 #- 1
  #   Y = -(Y / this.offsetHeight) * 2 #+ 1
  #   Z = -0
  #   pos = new THREE.Vector3 X, Y, Z
  #   console.log pos
  #
  #   pos.unproject(self.camera)
  #   dir = pos.clone().sub(self.camera.position).normalize()
  #   pos.add dir.clone().multiplyScalar(10)
  #
  #   console.log 'mousemove [#{X}, #{Y}, #{Z}]'
  #   console.log pos
  #   # console.log @camera
  #   # console.log pos
  #   # pos.project @camera
  #   # shapeBody2.position.x = X
  #   # shapeBody2.position.y = -Y
  #   # shapeBody2.position.z = Z
  #   shapeBody2.position.set pos.x, pos.y, pos.z
=======





  # document.getElementById(@settings.containerID).addEventListener 'mousemove', (event) ->
  #   # mouseX = (event.clientX - window.)
  #   # shapeBody1.position.set
  #   X = (event.pageX - this.offsetLeft) - this.offsetWidth / 2
  #   Y = event.pageY - this.offsetTop - this.offsetHeight / 2
  #   console.log 'mousemove [' + X + ', ' + Y + ']'
  #   mesh.position.x = X
  #   mesh.position.y = -Y
>>>>>>> 2965a717c84d552746c346ac3d527a1a389a8174
