


Game.logic = () ->


class Round
  constructor: () ->
    

@Game.score = () ->
	
	scoreTable = [0,0]
	player1Score = scoreTable[0]
	player2Score = scoreTable[1]
	
	scoreboard = document.getElementById("scoreContainer")
	
	scoreDiv1 = document.getElementById("player1")
	scoreDiv2 = document.getElementById("player2")
	
	player1 = document.createTextNode(player1Score)
	player2 = document.createTextNode(player2Score)
	
	scoreDiv1.innerText = player1.textContent
	scoreDiv2.innerText = player2.textContent
	
	scoreboard.addEventListener 'click', (event) ->
		player1Score += 1
		
		scoreDiv1.innerText = player1Score
		scoreDiv2.innerText = player2Score
		
		scoreTable[0] = player1Score
		scoreTable[1] = player2Score
		
		
	console.log scoreTable
	


