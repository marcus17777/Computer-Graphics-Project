class Ball extends CANNON.MeshBody
  @sphereMaterial = new THREE.MeshLambertMaterial color: 0x8888ff
  @sphereGeometry = new THREE.SphereGeometry 1, 32, 16
  @sphereShape = new CANNON.Sphere 1

  constructor: (args) ->
    super(
      args,
      material: new CANNON.Material
    )
    @mesh = new THREE.Mesh Ball.sphereGeometry, Ball.sphereMaterial
    [X, Y, Z] = args.position or [0, 0, 0]
    @position.set X, Y, Z

    @addShape Ball.sphereShape
    # @linearDamping =

  update: () ->
    @checkbounds()
    super()

  checkbounds: () ->
    # should check if ball is in bounds of game board.

@Game.Ball = Ball


class Racket extends CANNON.MeshBody
  constructor: () ->

  update: () ->
    super.update()

  serve: () ->
