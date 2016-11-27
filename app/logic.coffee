scene = undefined
camera = undefined
renderer = undefined

screen_width = 800
screen_height = 600

viewerPosition = new THREE.Vector3(0.0, 0.0, 8.0)


millis = () ->
  new Date.getTime()

toRad = (degrees) ->
  Math.PI * 2 * degree / 360

@onLoad = () ->
  appContainer = document.getElementById("appContainer")

  scene = new THREE.Scene
  renderer = new THREE.WebGLRenderer
  renderer.setSize(screen_width, screen_height)
  appContainer.appendChild(renderer.domElement)
  camera = new THREE.PerspectiveCamera(80, screen_width / screen_height, 1, 1000)
  camera.position.set(viewerPosition.x, viewerPosition.y, viewerPosition.z)
  camera.up = new THREE.Vector3(0, 1, 0)
  camera.lookAt(new THREE.Vector3(0, -5, 0))
  scene.add camera

  render;

render = () ->
  requestAnimationFrame render
  renderer.render scene, camera
