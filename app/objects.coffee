class Base extends CANNON.MeshBody
  constructor: (args) ->
    args.mesh = @mesh
    args.material = new CANNON.Material
    super(args)
    @addShape @shape, @shape.offset

    if args.callback?
      args.callback(@)


class Ball extends Base
  constructor: (args) ->
    @radius = args.radius

    @initModel()
    super(args)

    @angularDamping = 0.1



  setStatic: (bool) ->
    if bool
      @last_mass = @mass
      @mass = 0
      @velocity.set 0, 0, 0
      @angularVelocity.set 0, 0, 0
      @updateMassProperties()
    else
      @mass = @last_mass
      @last_mass = undefined
      @updateMassProperties()



  initModel: () ->
    material = new THREE.MeshLambertMaterial color: 0x8888ff
    geometry = new THREE.SphereGeometry @radius, 32, 16

    @shape = new CANNON.Sphere @radius
    @mesh = new THREE.Mesh geometry, material

@Game.Ball = Ball



class Racket extends Base
  @url = "models/reketfull.json"
  @scale = 100.0

  constructor: (args) ->
    args.mass = 0

    @initModel(() =>
      super(args)
    )
    @catched_objects = []

    @color = args.color || 0x1111ff
    @serving_force = args.serving_force || 0

  catch: (ball) ->
    # console.log "catch"
    # console.log ball
    # console.log @catched_objects
    index = @catched_objects.indexOf ball

    if index == -1
      @catched_objects.push ball
      ball.setStatic true


  serve: (ball) ->
    # console.log "serve"
    # console.log @serving_force
    # console.log ball

    index = @catched_objects.indexOf ball

    if index != -1
      @catched_objects.splice index, 1
      ball.setStatic false

      point = new CANNON.Vec3 0, 0, 0
      impulse = new CANNON.Vec3 0, 0, @serving_force * window.Game.settings.TIMESTEP
      ball.applyImpulse impulse, point




  update: () ->
    for obj in @catched_objects
      obj.position.copy this.position
    super()

  initModel: (callback) ->
    loader = new THREE.JSONLoader
    loader.load Racket.url, (geometry) =>
      material = new THREE.MeshLambertMaterial
        color: @color
        transparent: true
        opacity: 1

      mesh = new THREE.Mesh geometry, material
      mesh.geometry.computeBoundingBox()
      boundingBoxSize = mesh.geometry.boundingBox.getSize()

      scale_coe = Racket.scale
      mesh.scale.set scale_coe, scale_coe, scale_coe

      offset = new THREE.Vector3
      offset.subVectors mesh.geometry.boundingBox.max, mesh.geometry.boundingBox.min
      offset.multiplyScalar 0.5
      offset.add mesh.geometry.boundingBox.min
      offset.applyMatrix4 mesh.matrixWorld
      offset.multiplyScalar scale_coe

      ShapeBoxSize = (new CANNON.Vec3 boundingBoxSize.x, boundingBoxSize.y, boundingBoxSize.z).scale scale_coe / 2

      @shape = new CANNON.Box ShapeBoxSize
      @shape.offset = new CANNON.Vec3 offset.x, offset.y, offset.z
      @mesh = mesh
      callback()

 @Game.Racket = Racket





 class Table extends Base
   @dimensions: [1024, 10, 1024]

   constructor: (args) ->
     args.mass = 0
     @initModel()
     super(args)

   initModel: () ->
     # Setting size
     [width, height, length] = Table.dimensions

     material = new THREE.MeshLambertMaterial color: 0x00ff00
     geometry = new THREE.BoxGeometry width, height, length

     @shape = new CANNON.Box(new CANNON.Vec3 width/2, height/2, length/2)
     @mesh = new THREE.Mesh geometry, material

@Game.Table = Table



class RacketBot extends Racket
  constructor: (args) ->
    super(args)

    @color = args.color || 0xff0000
    @tracking = undefined

  update: () ->
    if @tracking?
      position = new CANNON.Vec3().copy @tracking.position
      position.z = this.position.z
      this.position.copy position
    super()

  setTrack: (obj) ->
    @tracking = obj

  removeTrack: () ->
    @tracking = undefined

@Game.RacketBot = RacketBot
