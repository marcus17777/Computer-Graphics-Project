class Logic
  constructor: () ->
    @Game = window.Game
    @settings = @Game.settings

    @rounds = []
    @ball_bounds = new THREE.Box3 new THREE.Vector3(-2048, -2048, -2048), new THREE.Vector3(2048, 2048, 2048)

    # @server = ['player', 'opponent'].randomChoice()
    @server = 'opponent'

  @property 'current_round',
    get: -> @rounds.last()

  @property 'next_server',
    get: ->
      if @server == 'player'
        console.log 'opponent'
        server = 'opponent'
      else if @server == 'opponent'
        console.log 'player'
        server = 'player'
      return server

  @property 'server_obj',
    get: ->
      @[@server]


  newRound: () ->
    @server = @next_server
    if @server == 'opponent'
      @ball.position.copy @opponent.initPosition

    @server_obj.catch @ball
    @rounds.push new Round

  endRound: () ->
    if !@current_round.winner?
      @current_round.end(@ball.last_touch)
      @newRound()


  run: () ->
    @initEventHandlers()
    @ball.setbounds @ball_bounds, () =>
      @endRound()

    @newRound()

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
      target = @server_obj
      if event.which == 1
        target.serve(@ball)
      # else if event.which == 3
      #   target.catch(@ball)


    @ball.addEventListener 'collide', (event) =>
      switch event.body
        when @player
          @ball.last_touch = 'player'
        when @opponent
          @ball.last_touch = 'opponent'
        when @environment
          @endRound()


@Game.Logic = Logic


class Round
  @score: {}

  constructor: () ->
    @winner = undefined

  end: (winner) ->
    Round.score[winner] = (Round.score[winner] || 0) + 1
    @winner = winner

  @property 'total_rounds',
    get: -> Object.values(Round.score).reduce (a, b) -> a + b

  @get_score: (key) ->
    return Round.score[key] || 0
