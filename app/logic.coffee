renderer = undefined
scene = undefined
camera = undefined
chopper = undefined
#We will use separate shaders for Gouraud and Phong shading models.
vertexShader = undefined
fragmentShader = undefined
gouraudVertexShader = undefined
gouraudFragmentShader = undefined
phongVertexShader = undefined
phongFragmentShader = undefined
statusContainer = undefined
#HTML element, where we will display the shader name
shaderMode = 1
#We will use a point light that moves along a trajectory
lightPosition = undefined
lightTrajectory = undefined
#Viewer position in world space
viewerPosition = new (THREE.Vector3)(0.0, 0.0, 8.0)

test = () ->
  console.log "test"

millis = ->
  (new Date).getTime()

toRad = (degree) ->
  Math.PI * 2 * degree / 360

@onLoad = ->
  canvasContainer = document.getElementById('myCanvasContainer')
  width = 800
  height = 500
  #Load the Gouraud shader codes
  gouraudVertexShader = document.getElementById('gouraudVertexShader').textContent
  gouraudFragmentShader = document.getElementById('gouraudFragmentShader').textContent
  #Load the Phong shader codes
  phongVertexShader = document.getElementById('phongVertexShader').textContent
  phongFragmentShader = document.getElementById('phongFragmentShader').textContent
  #Status container element
  statusContainer = document.getElementById('statusContainer')
  renderer = new (THREE.WebGLRenderer)
  renderer.setSize width, height
  canvasContainer.appendChild renderer.domElement
  scene = new (THREE.Scene)
  #Setup the camera
  camera = new (THREE.PerspectiveCamera)(80, width / height, 1, 1000)
  camera.position.set viewerPosition.x, viewerPosition.y, viewerPosition.z
  camera.up = new (THREE.Vector3)(0, 1, 0)
  camera.lookAt new (THREE.Vector3)(0, -5, 0)
  scene.add camera
  #Set the initial shader
  changeShader()
  addHangar()
  chopper = addChopper()
  #Three.js has some classes for splines. We will look more closely at curves and splines in the Basic II module.
  #For now, know that this class creates a closed curved trajectory
  lightTrajectory = new (THREE.CatmullRomCurve3)([
    new (THREE.Vector3)(0, -4, 5)
    new (THREE.Vector3)(-2, 0, 3)
    new (THREE.Vector3)(-3, 4, 6)
    new (THREE.Vector3)(8, 2, 9)
  ])
  lightTrajectory.closed = true
  draw()
  window.addEventListener 'keydown', ((event) ->
    if event.keyCode == 37
      #Right arrow
      changeShader()
    if event.keyCode == 39
      #Left arrow
      changeShader()
    return
  ), false
  return

###*
# Function that switches the shader code.
###

changeShader = ->
  shaderMode = (shaderMode + 1) % 2
  if shaderMode == 0
    #Assign the Gouraud shader
    vertexShader = gouraudVertexShader
    fragmentShader = gouraudFragmentShader
    statusContainer.innerHTML = 'Gouraud shader'
  else
    #Assign the Phong shader
    vertexShader = phongVertexShader
    fragmentShader = phongFragmentShader
    statusContainer.innerHTML = 'Phong shader'
  #Traverse the scene graph and update the code for the corresponding materials.
  scene.traverse (object) ->
    if object.material != undefined and object.material instanceof THREE.ShaderMaterial
      object.material.vertexShader = vertexShader
      object.material.fragmentShader = fragmentShader
      object.material.needsUpdate = true
    return
  return

draw = ->
  requestAnimationFrame draw
  #This will sample the light trajectory curve and assign a point value at a given time to the light position.
  m = millis() / 4000
  lightPosition = lightTrajectory.getPoint(m - parseInt(m))
  #Traverse the scene and update the lightPosition variable value for the shaders.
  scene.traverse (object) ->
    if object.material != undefined and object.material instanceof THREE.ShaderMaterial
      #Send the light position transformed to camera space
      #object.material.uniforms.lightPosition.value = new THREE.Vector3().copy(lightPosition).applyMatrix4(camera.matrixWorldInverse);
    else
    return
  #Hopefully you have something like this for the blades rotation
  chopper.children[1].rotation.set 0, toRad(millis() / 10 % 360), 0
  renderer.render scene, camera
  return

addHangar = ->
  hangar = new (THREE.Object3D)
  halfPi = Math.PI / 2
  leftWall = createWall(0x555555)
  leftWall.position.set -10, 0, 0
  leftWall.rotation.set 0, halfPi, 0
  hangar.add leftWall
  rightWall = createWall(0x333333)
  rightWall.position.set 10, 0, 0
  rightWall.rotation.set 0, -halfPi, 0
  hangar.add rightWall
  backWall = createWall(0x444444)
  backWall.position.set 0, 0, -10
  hangar.add backWall
  ceiling = createWall(0x111111)
  ceiling.position.set 0, 10, 0
  ceiling.rotation.set halfPi, 0, 0
  hangar.add ceiling
  floor = createWall(0x222222)
  floor.position.set 0, -10, 0
  floor.rotation.set -halfPi, 0, 0
  hangar.add floor
  scene.add hangar
  return

###*
# Hopefully you have something similar.
# You can copy your chopper drawing code to replace this.
# Use a sphere as the body.
###

addChopper = ->
  `var chopper`
  chopper = new (THREE.Object3D)
  chopper.position.set 0, -5, 0
  body = createSphere(0xccccee)
  body.scale.set 3, 1, 1
  chopper.add body
  blades = new (THREE.Object3D)
  blade1 = createCube(0xcceecc)
  blade1.position.set 2.7, 1.2, 0
  blade1.scale.set 2.4, 0.1, 0.4
  blade1.rotation.set 0, toRad(180), 0
  blades.add blade1
  blade2 = createCube(0xcceecc)
  blade2.scale.set 2.4, 0.1, 0.4
  blade2.position.set -2.7, 1.2, 0
  blades.add blade2
  chopper.add blades
  scene.add chopper
  chopper

createWall = (colorCode) ->
  geometry = new (THREE.PlaneGeometry)(20, 20, 1)
  color = new (THREE.Color)(colorCode)
  material = createShaderMaterial(color)
  wall = new (THREE.Mesh)(geometry, material)
  wall

createCube = (colorCode) ->
  geometry = new (THREE.BoxGeometry)(2, 2, 2)
  color = new (THREE.Color)(colorCode)
  material = createShaderMaterial(color)
  cube = new (THREE.Mesh)(geometry, material)
  cube

createSphere = (colorCode) ->
  geometry = new (THREE.SphereGeometry)(1, 6, 6)
  #We create a sphere approximation. Radius = 1; widthSegments = heightSegments = 6.
  color = new (THREE.Color)(colorCode)
  material = createShaderMaterial(color)
  sphere = new (THREE.Mesh)(geometry, material)
  sphere

createShaderMaterial = (color) ->
  new (THREE.ShaderMaterial)(
    uniforms: {}
    vertexShader: vertexShader
    fragmentShader: fragmentShader)

# ---
# generated by js2coffee 2.2.0