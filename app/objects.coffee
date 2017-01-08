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
  @url = "models/reketfull.json"

  constructor: (args) ->
    @initModel(() =>
      super(args)
    )


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
      material = new THREE.MeshLambertMaterial color: 0x1111ff
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



      @shape = new CANNON.Box(new CANNON.Vec3(142, 5, 101))
      @mesh = mesh
      callback()




 @Game.Racket = Racket
