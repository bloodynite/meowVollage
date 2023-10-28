extends Node

var player_current_atack: bool = false

var current_scene = "world"
var transition_scene = false

var player_exit_cliffside_pos_x = 327
var player_exit_cliffside_pos_y = 20

var player_start_pos_x = 72
var player_start_pos_y = 260

var game_first_load = true

var is_key_found = false
var is_key_given = false
var is_key_quest_complete = false
var is_key_quest_active = false

var is_in_dialog = false
var is_player_in_quest_area = false

func finish_change_scene():
	if transition_scene:
		transition_scene = false
		if current_scene == 'world':
			current_scene = 'cliff_side'
		else:
			current_scene = 'world'
