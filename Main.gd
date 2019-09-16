extends Node2D

var revealed_card = null
var buttons = []
var paused = false
var misses = 0

func _ready():
	$VictoryLabel.hide()
	randomize()	
	var cards = ["A", "B", "C", "D", "E", "F"]	
	cards = cards + cards
	cards.shuffle()	
	var button_scene = load("res://MatchButton.tscn")
	var tx = 200
	var ty = 70	
	var i = 0
	for x in range(4):
		for y in range(3):						
			var button = button_scene.instance()			
			button.rect_position.x = tx + 100*x 
			button.rect_position.y = ty + 100*y
			button.hidden_value = cards[i]			
			button.index = i
			i += 1
			add_child(button)
			button.connect("pressed", self, "reveal_card", [button])
			buttons.append(button)						

func hide_cards():
	for button in buttons:
		if button != null:
			button.text = "?"			

func reveal_card(button):
	if !paused:
		if button == revealed_card:
			pass
		elif revealed_card == null:
			revealed_card = button
			button.text = button.hidden_value
		elif revealed_card != button && revealed_card.hidden_value == button.hidden_value:
			revealed_card.queue_free()
			button.queue_free()
			buttons[button.index] = null
			buttons[revealed_card.index] = null
			revealed_card = null
			var count = 0
			for button in buttons:
				if button != null:
					count += 1
			if count == 0:
				$VictoryLabel.show()
				$RestartTimer.start()
		else:
			misses += 1
			$MissCounter.text = "Misses:\n" + str(misses)
			button.text = button.hidden_value
			revealed_card = null
			paused = true
			$RevealTimer.start()


func _on_RevealTimer_timeout():
	$RevealTimer.stop()
	hide_cards()
	paused = false

func _on_RestartTimer_timeout():
	get_tree().reload_current_scene()
