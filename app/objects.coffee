class Base extends CANNON.MeshBody
  constructor: (args) ->
    args.mesh = @mesh
    args.material = new CANNON.Material
    super(args)
    @addShape @shape

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
  @mtl_url : 'models/reketfull24.mtl'
  @obj_url : 'models/reketfull24.obj'

  constructor: (args) ->
    @initModel(() =>
      super(args)
    )


  initModel: (callback) ->
    mtlLoader = new THREE.MTLLoader
    mtlLoader.load Racket.mtl_url, (materials) =>
      objLoader = new THREE.OBJLoader
      objLoader.setMaterials materials
      objLoader.load Racket.obj_url, (object) =>
        # object.traverse (child) ->
        #   if child.geometry?
        #     @geometry = child.geometry
        #     @material = child.material
        @mesh = object
        callback()

    @shape = new CANNON.Sphere 10

 @Game.Racket = Racket
