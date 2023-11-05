extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play('looking')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_front_area_body_entered(body):
	$AnimatedSprite2D.play("front")


func _on_left_area_body_entered(body):
	$AnimatedSprite2D.play("left")


func _on_right_area_body_entered(body):
	$AnimatedSprite2D.play("right")


func _on_back_area_body_entered(body):
	$AnimatedSprite2D.play("back")

func _on_exit_area_body_exited(body):
	$AnimatedSprite2D.play('looking')
