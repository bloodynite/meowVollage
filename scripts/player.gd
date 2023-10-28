extends CharacterBody2D

const speed: int = 80
var current_dir: String = "none"
var enemy_in_range_to_atack: bool = false
var enemy_atack_cooldown: bool = true
var health: int = 300
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
	
	if health <= 0:
		player_alive = false #add game over
		health = 0
		print('you die')
		self.queue_free()
	
func player_movement(delta):
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
	elif Input.is_action_just_pressed("ui_accept"):
		print('Interactuando')
		var actionables = actionable_finder.get_overlapping_areas()
		print(actionables.size())
		if actionables.size() > 0:
			print('actionable')
			actionables[0].action()
			return
#			DialogueManager.show_example_dialogue_balloon(load('res://dialogs/main.dialogue'), 'beared_guy')
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
	if enemy_in_range_to_atack and enemy_atack_cooldown == true:
		
		health -= 20
		enemy_atack_cooldown = false
		$attack_cooldown.start()
		print(' hola')


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
	healthBarRef.value = health
	
	if health >= 100:
		healthBarRef.visible = false
	else:
		healthBarRef.visible = true

func _on_regen_timer_timeout():
<<<<<<< Updated upstream
	if health < 100:
		health += 20
	elif health > 100:
		health = 100
	elif health <= 0:
		health = 0
=======
	if current_health < Global.player_initial_health:
		current_health += Global.player_regeneration
		print('regenerating: ', current_health)
		if current_health > Global.player_initial_health:
			current_health = Global.player_initial_health
	elif current_health <= 0:
		current_health = 0

>>>>>>> Stashed changes
