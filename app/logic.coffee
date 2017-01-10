


class Logic
  constructor: () ->
    @Game = window.Game
    @settings = @Game.settings

    @rounds = []

  @property 'current_round',
    get: -> @rounds.last()

  newRound: () ->
    @rounds.push new Round

  run: () ->
    @initEventHandlers()
    @newRound()

    console.log @rounds
    console.log @current_round

  addPlayer: (obj) ->
    @player = obj

  addOpponent: (obj) ->
    @opponent = obj

  addBall: (obj) ->
    @ball = obj
    console.log @ball

  addEnvironment: (obj) ->
    @environment = obj

  addTable: (obj) ->
    @table = obj

  initEventHandlers: () ->
    self = @
    document.getElementById(@settings.containerID).addEventListener 'mousemove', (event) ->

      X = (event.pageX - this.offsetLeft) - this.offsetWidth / 2
      Y = (event.pageY - this.offsetTop) - this.offsetHeight / 2
      X = (X / this.offsetWidth) * 2 #- 1
      Y = -(Y / this.offsetHeight) * 2 #+ 1
      Z = -0
      pos = new THREE.Vector3 X, Y, Z

      pos.unproject(self.Game.camera)
      dir = pos.clone().sub(self.Game.camera.position).normalize()
      pos.add dir.clone().multiplyScalar(1000)

      self.player.position.set pos.x, pos.y, pos.z

    document.getElementById(@settings.containerID).addEventListener 'mouseup', (event) =>
      target = @opponent
      if event.which == 1
        target.serve(@ball)
      else if event.which == 3
        target.catch(@ball)


    @ball.addEventListener 'collide', (event) =>
      switch event.body
        when @player
          console.log 'player'
        when @opponent
          console.log 'opponent'
        when @environment
          console.log 'fell off'


@Game.Logic = Logic

class Round
  constructor: () ->
    @
