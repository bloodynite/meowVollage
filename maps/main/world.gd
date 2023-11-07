extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer.visible = false
	if Global.game_first_load:
		$player.position.x = Global.player_start_pos_x
		$player.position.y = Global.player_start_pos_y
	else:
		$player.position.x = Global.player_exit_cliffside_pos_x
		$player.position.y = Global.player_exit_cliffside_pos_y
		if Global.is_key_found:
			$key.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	change_scene()
	if Global.is_key_found:
		$CanvasLayer.visible = true
	if Global.is_key_quest_complete:
		$CanvasLayer.visible = false


func _on_cliff_side_transition_body_entered(body):
	if body.has_method('player'):
		Global.transition_scene = true


func _on_cliff_side_transition_body_exited(body):
		if body.has_method('player'):
			Global.transition_scene = false

func change_scene():
	if Global.transition_scene:
		if Global.current_scene == 'world':
			Global.game_first_load = false
			get_tree().change_scene_to_file("res://maps/cliff_side/cliff_side.tscn")
			Global.finish_change_scene()
