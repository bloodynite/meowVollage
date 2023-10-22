extends CharacterBody2D

var speed = 45
var player_chase: bool = false
var player:Node2D = null
var health = 300
var player_in_range_to_atack: bool = false
var can_take_damage: bool = true

func _physics_process(delta):
	deal_with_damage()
	
	if player_chase:
		position += (player.position - position)/speed
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
			health -= 20
			$take_damage_cooldown.start()
			can_take_damage = false
			print('slime health = ', health)
			if health <= 0:
				health = 0
				print('enemy die')
				self.queue_free()


func _on_take_damage_cooldown_timeout():
	can_take_damage = true
