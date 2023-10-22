extends Node

var player_current_atack: bool = false

var current_scene = "world"
var transition_scene = false

var player_exit_cliffside_pos_x = 700
var player_exit_cliffside_pos_y = 128

var player_start_pos_x = 72
var player_start_pos_y = 260

var game_first_load = true

func finish_change_scene():
	if transition_scene:
		transition_scene = false
		if current_scene == 'world':
			current_scene = 'cliff_side'
		else:
			current_scene = 'world'
