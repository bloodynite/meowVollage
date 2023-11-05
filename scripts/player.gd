extends CharacterBody2D

const speed = 80
var current_health = Global.player_initial_health
var current_dir: String = "none"
var enemy_in_range_to_atack: bool = false
var enemy_atack_cooldown: bool = true
var player_alive: bool = true
var attack_in_progress: bool = false

var is_player_in_quest_area = false

@onready var actionable_finder: Area2D = $Direction/ActionableFinder

func _ready():
	$AnimatedSprite2D.play("front_idle")

func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()
	current_camera()
	update_heath()
	
	if current_health <= 0:
		$AnimatedSprite2D.play("death")
		player_alive = false #add game over
		current_health = 0
		print('you die')
		self.queue_free()
		get_tree().change_scene_to_file('res://UI/game_over.tscn')
		
	
	
func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_accept"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			print('actionable')
			actionables[0].action()
			return

func player_movement(delta):
	if !Global.is_in_dialog:
		if Input.is_action_pressed("ui_right"):
			$Direction.position.y = 0
			$Direction.position.x = 5
			$Direction.rotation = 0
			$Direction.rotation = -90
			current_dir = 'right'
			play_animation(1)
			velocity.x = speed
			velocity.y = 0
		elif Input.is_action_pressed("ui_left"):
			$Direction.position.y = 0
			$Direction.position.x = -5
			$Direction.rotation = 0
			$Direction.rotation = 90
			current_dir = 'left'
			play_animation(1)
			velocity.x = -speed
			velocity.y = 0
		elif Input.is_action_pressed("ui_up"):
			$Direction.rotation = 0
			$Direction.position.y = -15
			$Direction.position.x = 0
			current_dir = 'up'
			play_animation(1)
			velocity.x = 0
			velocity.y = -speed
		elif Input.is_action_pressed("ui_down"):
			$Direction.position.y = 0
			$Direction.position.x = 0
			$Direction.rotation = 0
			current_dir = 'down'
			play_animation(1)
			velocity.x = 0
			velocity.y = speed
		else: 
			play_animation(0)
			velocity.x = 0
			velocity.y = 0
			
		move_and_slide()
	
func play_animation(movement):
	var dir = current_dir
	var animation:AnimatedSprite2D = $AnimatedSprite2D
	
	if dir == 'right':
		animation.flip_h = false
		if movement == 1:
			animation.play('side_walk')
		elif movement == 0:
			if attack_in_progress == false:
				animation.play('side_idle')
	elif dir == 'left':
		animation.flip_h = true
		if movement == 1:
			animation.play('side_walk')
		elif movement == 0:
			if attack_in_progress == false:
				animation.play('side_idle')
	elif dir == 'down':
		if movement == 1:
			animation.play('front_walk')
		elif movement == 0:
			if attack_in_progress == false:
				animation.play('front_idle')
	elif dir == 'up':
		if movement == 1:
			animation.play('back_walk')
		elif movement == 0:
			if attack_in_progress == false:
				animation.play('back_idle')

func player():
	pass

func _on_player_hitbox_body_entered(body):
	if body.has_method('enemy'):
		enemy_in_range_to_atack = true

func _on_player_hitbox_body_exited(body):
	if body.has_method('enemy'):
		enemy_in_range_to_atack = false

func enemy_attack():
	if enemy_in_range_to_atack and enemy_atack_cooldown:
		current_health -= Global.enemy_atack_damage
		enemy_atack_cooldown = false
		$attack_cooldown.start()
		print('Players health: ' , current_health)


func _on_attack_cooldown_timeout():
	enemy_atack_cooldown = true

func attack():
	var dir = current_dir
	if Input.is_action_just_pressed("attack"):
		Global.player_current_atack = true
		attack_in_progress = true
		if dir == 'right':
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_atack")
			$deal_attack.start()
		if dir == 'left':
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_atack")
			$deal_attack.start()
		if dir == 'down':
			$AnimatedSprite2D.play("front_atack")
			$deal_attack.start()
		if dir == 'up':
			$AnimatedSprite2D.play("back_atack")
			$deal_attack.start()


func _on_deal_attack_timeout():
	$deal_attack.stop()
	Global.player_current_atack = false
	attack_in_progress = false

func current_camera():
	if Global.current_scene == 'world':
		$world_camera.enabled = true
		$cliff_camera.enabled = false
	elif Global.current_scene == 'cliff_side':
		$world_camera.enabled = false
		$cliff_camera.enabled = true

func update_heath():
	var healthBarRef = $healthBar
	healthBarRef.max_value = Global.player_initial_health
	healthBarRef.value = current_health
	healthBarRef.modulate = Color(0,1,0,1)
	
	if current_health >= Global.player_initial_health:
		healthBarRef.visible = false
	else:
		healthBarRef.visible = true
		#si la vida es mayor que la 75% del total se pinta verde
		if current_health > ((Global.player_initial_health/4)*3):
			healthBarRef.modulate = 'GREEN'
		#si la vida es mayor a 25% y es menor a 75% pinta amarillo
		elif current_health >= (Global.player_initial_health/4) and current_health <= ((Global.player_initial_health/4)*3):
			healthBarRef.modulate = 'YELLOW'
		#si la vida es menor/igual que 25% se pinta roja
		elif current_health < (Global.player_initial_health/4):
			healthBarRef.modulate = 'DARKRED'

func _on_regen_timer_timeout():
	if current_health < Global.player_initial_health:
		current_health += Global.player_regeneration
		print('regenerating: ', current_health)
		if current_health > Global.player_initial_health:
			current_health = Global.player_initial_health
	elif current_health <= 0:
		current_health = 0

func _on_area_2d_body_entered(body):
	if body.has_method('is_key'):
		DialogueManager.show_example_dialogue_balloon(load("res://dialogues/main.dialogue"), 'pick_key')
		Global.is_key_found = true
		body.queue_free()


func _on_animated_sprite_2d_animation_finished():
	print('termino')


func _on_animated_sprite_2d_animation_changed():
	var animacion = $AnimatedSprite2D.animation
	print(animacion)
	if animacion == 'front_walk':
		print('si es')
		
