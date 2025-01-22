class_name PlayerBall
extends CharacterBody2D

@export var ball_speed = 50
@onready var player_paddle: PlayerPaddle = $Anchor/PlayerPaddle
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var stats_component: StatsComponent = $StatsComponent

func _ready() -> void:
	hurtbox_component.hurt.connect(func(hitbox: HitboxComponent):
		#position = Vector2(80,200)
		position = Vector2(40,200)
		#print(ship.position)
		#velocity = Vector2(randf_range(-1, 1), randf_range(-.1, -1)).normalized() * ball_speed
		velocity = Vector2(0,50)
		#print("Ball Health: ", stats_component.health)
	)
	stats_component.no_health.connect(queue_free)
	
	# Delete the ball from memory if it exits the bottom of the screen
	#visible_on_screen_notifier_2d.screen_exited.connect(queue_free)

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if(!collision):
		return
		
	#print_debug("v before ",velocity)
	velocity = velocity.bounce(collision.get_normal())
	#print_debug("v After ", velocity)
