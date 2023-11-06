extends StaticBody2D
var player_in_area = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play('idle')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_front_area_body_entered(body):
	if body.has_method('player'):
		$AnimatedSprite2D.play("front")
		player_in_area = true
		print('Player entra front')


func _on_left_area_body_entered(body):
	if body.has_method('player'):
		$AnimatedSprite2D.play("left")
		player_in_area = true
		print('Player entra left')

func _on_right_area_body_entered(body):
	if body.has_method('player'):
		$AnimatedSprite2D.play("right")
		player_in_area = true
		print('Player entra right')

func _on_back_area_body_entered(body):
	if body.has_method('player'):
		$AnimatedSprite2D.play("back")
		player_in_area = true
		print('Player entra back')

func _on_exit_area_body_entered(body):
	if player_in_area:
		print('Player ha salido del area')
		$AnimatedSprite2D.play('idle')
		player_in_area = false
