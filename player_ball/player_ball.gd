class_name PlayerBall
extends CharacterBody2D

#@export var ball_speed = 50

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var player_paddle: PlayerPaddle = %PlayerPaddle

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if(!collision):
		return
		
	print_debug("v before ",velocity)
	velocity = velocity.bounce(collision.get_normal())
	print_debug("v After ", velocity)
