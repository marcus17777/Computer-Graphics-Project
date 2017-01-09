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
    @initModel()
    super(args)


  initModel: () ->
    radius = 10

    material = new THREE.MeshLambertMaterial color: 0x8888ff
    geometry = new THREE.SphereGeometry radius, 32, 16

    @shape = new CANNON.Sphere radius
    @mesh = new THREE.Mesh geometry, material

@Game.Ball = Ball



class Racket extends Base
  @url = "models/reketfull.json"

  constructor: (args) ->
    @initModel(() =>
      super(args)
    )
    @catched_objects = []

    @color = args.color || 0x1111ff
    @serving_force = args.serving_force || 0

  catch: (ball) ->
    console.log "catch"
    console.log ball
    console.log @catched_objects
    index = @catched_objects.indexOf ball

    if index == -1
      @catched_objects.push ball
      ball.last_mass = ball.mass
      ball.mass = 0
      ball.updateMassProperties()

      ball.velocity.setZero()
      ball.angularVelocity.setZero()

  serve: (ball) ->
    console.log "serve"
    console.log @serving_force
    console.log ball

    index = @catched_objects.indexOf ball

    if index != -1
      @catched_objects.splice index, 1
      ball.mass = ball.last_mass
      ball.last_mass = undefined
      ball.updateMassProperties()

      console.log window.Game.settings
      point = new CANNON.Vec3 0, 0, 1
      impulse = new CANNON.Vec3 0, 0, @serving_force * window.Game.settings.TIMESTEP
      ball.applyImpulse impulse, point




  update: () ->
    for obj in @catched_objects
      obj.position.copy this.position
      # obj.quaternion.copy this.quaternion
      # obj.velocity.set 0, 0, 0
      # obj.inertia.set 0, 0, 0
    super()

  initModel: (callback) ->
    # mtlLoader = new THREE.MTLLoader
    # mtlLoader.load Racket.mtl_url, (materials) =>
    #   objLoader = new THREE.OBJLoader
    #   objLoader.setMaterials materials
    #   objLoader.load Racket.obj_url, (object) =>
    #     # object.traverse (child) ->
    #     #   if child.geometry?
    #     #     @geometry = child.geometry
    #     #     @material = child.material
    #     @mesh = object
    #     callback()
    #
    # @shape = new CANNON.Sphere 10

    loader = new THREE.JSONLoader
    loader.load Racket.url, (geometry) =>
      material = new THREE.MeshLambertMaterial
        color: @color
        transparent: true
        opacity: 0.5

      mesh = new THREE.Mesh geometry, material
      # boxShape = new CANNON.Box(new CANNON.Vec3(3.4,0.1,2.1))
      # boxBody = new CANNON.Body({ mass: mass })
      # boxBody.position.set(0,50,0)
      # @scene.add boxBody
      # boxBody.addShape boxShape
      #

      mesh.scale.set 100, 100, 100


      # box = new THREE.Box3().setFromObject( mesh )
      # console.log( box.min, box.max, box.getSize() )
      mesh.geometry.computeBoundingBox()
      console.log mesh



      @shape = new CANNON.Box(new CANNON.Vec3 331 / 2, 9 / 2, 202/ 2)
      @shape.offset = new CANNON.Vec3 -25, 17, 0
      @mesh = mesh
      callback()




 @Game.Racket = Racket
