scene = undefined
camera = undefined
renderer = undefined
group = undefined


class Cube extends THREE.Mesh
  constructor: () ->
    geometry = new THREE.BoxGeometry(1, 1, 1)
    material = new THREE.MeshFaceMaterial([
         new THREE.MeshBasicMaterial(color: 0x09dcff),
         new THREE.MeshBasicMaterial(color: 0x13de69),
         new THREE.MeshBasicMaterial(color: 0x88a3f4),
         new THREE.MeshBasicMaterial(color: 0x8042cd),
         new THREE.MeshBasicMaterial(color: 0x649c60),
         new THREE.MeshBasicMaterial(color: 0x772c13),
    ])
    super(geometry, material)

    @speed = {
      'x': 0.0,
      'y': 0.0,
      'z': 0.0,
    }

    @rotation_speed = {
      'x': 0.0,
      'y': 0.0,
      'z': 0.0,
    }

  update: (ms) ->
    this.position.x += @speed.x
    this.position.y += @speed.y
    this.position.z += @speed.z
    this.rotation.x += @rotation_speed.x
    this.rotation.y += @rotation_speed.y
    this.rotation.z += @rotation_speed.z

  setpos: (x, y, z) ->
    this.position.x = x
    this.position.y = y
    this.position.z = z


class Group
  constructor: () ->
    @objects = []

  add: (obj) ->
    @objects.push obj

  update: (ms) ->
    for obj in @objects
      obj.update ms

  addToScene: (scene) ->
    for obj in @objects
      scene.add obj





render = ->
  requestAnimationFrame render
  group.update 1
  renderer.render scene, camera
  return

@onLoad = () ->
  scene = new THREE.Scene
  camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000)
  renderer = new THREE.WebGLRenderer

  renderer.setSize window.innerWidth, window.innerHeight
  document.body.appendChild renderer.domElement

  group = new Group

  cube = new Cube
  cube2 = new Cube

  cube.setpos 5,5,0
  cube.rotation_speed.x = 0.01

  cube2.speed.x = 0.01
  cube2.rotation_speed.y = 0.1
  cube2.setpos -5,5,0
  #cube2.rotation_speed.y = -0.01


  group.add cube
  group.add cube2

  group.addToScene scene

  camera.position.z = 10
  render()
