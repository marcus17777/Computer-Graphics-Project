@world = undefined

@initCannon = () ->
  @world = new CANNON.World
  world.gravity.set(
    @settings.GRAVITY.x
    @settings.GRAVITY.y
    @settings.GRAVITY.z
  )

  world.broadphase = new CANNON.NaiveBroadphase
  world.solver.iterations = 10

  # shape = new CANNON.Box new CANNON.Vec3 1, 1, 1
  # body = new CANNON.Body mass: 1
  # body.addShape shape
  # body.angularVelocity.set 0, 10, 0
  # body.angularDamping = 0.5
  # world.addBody body

  physicsMaterial = new CANNON.Material "slipperyMaterial"
  physicsContactMaterial = new CANNON.ContactMaterial(physicsMaterial,
                                                      physicsMaterial,
                                                      0.0, # friction coefficient
                                                      0.3 # restitution
                                                      )
  # We must add the contact materials to the world
  world.addContactMaterial physicsContactMaterial




@updatePhysics = () ->
  @world.step @settings.TIMESTEP



class CANNON.MeshBody extends CANNON.Body
  constructor: (args) ->
    super(args)
    this.mesh = args.mesh

  addMesh: (mesh) ->
    this.mesh = mesh

  update: () ->
    this.mesh.position.copy this.position
    this.mesh.quaternion.copy this.quaternion
