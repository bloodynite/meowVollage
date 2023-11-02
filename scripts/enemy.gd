extends CharacterBody2D

var speed = 45
var player_chase: bool = false
var player:Node2D = null
var initial_health = 300
var health = initial_health
var player_in_range_to_atack: bool = false
var can_take_damage: bool = true

func _physics_process(delta):
	deal_with_damage()
	update_health()
	
	if player_chase:
		position += (player.position - position)/speed
		var distance = player.position.distance_to(position)
		if distance < 10:
			$AnimatedSprite2D.play("atack")
		else:
			$AnimatedSprite2D.play("walk")
			if (player.position.x - position.x ) < 0:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("idle")
		
	move_and_collide(Vector2(0,0))


func _on_detection_area_body_entered(body):
	player = body
	player_chase = true


func _on_detection_area_body_exited(body):
	player = null
	player_chase = false

func enemy():
	pass


func _on_enemy_hitbox_body_entered(body):
	if body.has_method('player'):
		player_in_range_to_atack = true


func _on_enemy_hitbox_body_exited(body):
	if body.has_method('player'):
		player_in_range_to_atack = false

func deal_with_damage():
	if player_in_range_to_atack and Global.player_current_atack:
		if can_take_damage:
			$AnimatedSprite2D.play("hited")
			health -= 20
			$take_damage_cooldown.start()
			can_take_damage = false
			print('slime health = ', health)
			if health <= 0:
				health = 0
				$AnimatedSprite2D.play("death")
				self.queue_free()


func _on_take_damage_cooldown_timeout():
	can_take_damage = true

func update_health():
	var health_bar_ref = $healthBar
	health_bar_ref.max_value = initial_health
	health_bar_ref.value = health
	
	if health >= initial_health:
		health_bar_ref.visible = false
	else:
		health_bar_ref.visible = true
