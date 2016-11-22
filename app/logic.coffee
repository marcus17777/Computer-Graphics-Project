scene = undefined
camera = undefined
renderer = undefined
cube = undefined


class Cube extends THREE.Mesh
  constructor: () ->
    geometry = new THREE.BoxGeometry(1, 1, 1)
    material = new THREE.MeshBasicMaterial(color: 0x00ff00)
    super(geometry, material)

    @speed = {
      'x': 0.01,
      'y': 0.01,
      'z': 0.0,
    }

  update: (ms) ->
    this.translateX(@speed.x)
    this.translateY(@speed.y)
    this.translateZ(@speed.z)
    # this.rotation.x += 0.01
    # this.rotation.y += 0.01




render = ->
  requestAnimationFrame render
  cube.update 1
  renderer.render scene, camera
  return

@onLoad = () ->
  scene = new THREE.Scene
  camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000)
  renderer = new THREE.WebGLRenderer

  scene.updateMatrixWorld true

  renderer.setSize window.innerWidth, window.innerHeight
  document.body.appendChild renderer.domElement
  # geometry = new THREE.BoxGeometry(1, 1, 1)
  # material = new THREE.MeshBasicMaterial(color: 0x00ff00)
  # cube = new THREE.Mesh(geometry, material)
  cube = new Cube
  scene.add cube
  camera.position.z = 10
  render()
