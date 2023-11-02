extends Node

var player_current_atack: bool = false
var player_initial_health =  300
var player_atack_damage = 30
var player_regeneration = 20

var enemy_atack_damage = 20
var enemy_initial_health = 100

var current_scene = "world"
var transition_scene = false

var player_exit_cliffside_pos_x = 330
var player_exit_cliffside_pos_y = 25

var player_start_pos_x = 142
var player_start_pos_y = 245

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
