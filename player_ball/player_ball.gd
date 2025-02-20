class_name PlayerBall
extends CharacterBody2D


const VELOCITY_LIMIT = 50

@export var ball_speed = 40
@export var speed_multiplier = 1.0


var last_collider_id

#@onready var player_paddle: PlayerPaddle = $Anchor/PlayerPaddle
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var stats_component: StatsComponent = $StatsComponent
@onready var move_component: MoveComponent = $MoveComponent

func _ready() -> void:
	# Make sure the actor start with full health
	stats_component.health = stats_component.max_health
	
	hurtbox_component.hurt.connect(func(hitbox: HitboxComponent):
		position = Vector2(80,200)
		#position = Vector2(40,200)
		#print(ship.position)
		move_component.velocity = Vector2(randf_range(-1, 1), randf_range(-.1, -1)).normalized() * ball_speed
		#move_component.velocity = Vector2(0,50)
		#print("Ball Health: ", stats_component.health)
	)
	stats_component.no_health.connect(queue_free)
	
	# Delete the ball from memory if it exits the bottom of the screen
	#visible_on_screen_notifier_2d.screen_exited.connect(queue_free)

func _physics_process(delta):
	var collision = move_and_collide(move_component.velocity * delta)
	
	if(!collision):
		return
		
	var collider = collision.get_collider()

	#if (collider is Brick):
	if (collider is Brick or collider is PlayerPaddle):
		#print_debug("Velocity Before: ", move_component.velocity)
		ball_collision(collider)
		#print_debug("Velocity After: ", move_component.velocity)
	else:
		move_component.velocity = move_component.velocity.bounce(collision.get_normal())


func ball_collision(collider):
	#print_debug("Collider: ", collider)
	#var ball_width = collision_shape_2d.shape.get_rect().size.x
	var ball_center_x = global_position.x
	var collider_width = collider.get_width()
	var collider_center_x = collider.global_position.x
	
	var velocity_xy = move_component.velocity.length()
	
	#print_debug("velocity_xy: ",velocity_xy)
	#print_debug("collider_width: ",collider_width)
	#print_debug("collider_center_x: ", collider_center_x)
	#print_debug("ball_center_x: ", ball_center_x)

#	 // Calculate the position of the ball relative to the center of
#	// the paddle, and express this as a number between -1 and +1.
#	// (Note: collisions at the ends of the paddle may exceed this
#	// range, but that is fine.)
	var collision_x = ((ball_center_x - (collider_center_x)) / (collider_width / 2))
	#print_debug("collision_x: ", collision_x)
	
	var new_velocity = Vector2(0,0)
	
#	  // Let the new X speed be proportional to the ball position on
#	// the paddle.  Also make it relative to the original speed and
#	// limit it by the influence factor defined above.
	new_velocity.x = velocity_xy * collision_x 

	if collider.get_rid() == last_collider_id && collider is Brick:
		#print_debug(new_velocity.x)
		new_velocity.x = new_velocity.rotated(randf_range(-45, 45)).x * 10
		#print_debug(new_velocity.x)
	else:
		last_collider_id = collider.get_rid()
	
# // Finally, based on the new X speed, calculate the new Y speed
#    // such that the new overall speed is the same as the old.  This
#    // is another application of the Pythagorean theorem.  The new
#    // Y speed will always be nonzero as long as the X speed is less
#    // than the original overall speed.

	#print_debug(velocity_xy)
	#print_debug(new_velocity.x)
	new_velocity.y = sqrt(absf(velocity_xy*velocity_xy - new_velocity.x * new_velocity.x)) * (-1 if move_component.velocity.y > 0 else 1)
	#print_debug("new_velocity.y: ",new_velocity.y)
	#var speed_multiplier = speed_up_factor if collider is Paddle else 1
	move_component.velocity = (new_velocity *  speed_multiplier).limit_length(VELOCITY_LIMIT)
	#print(velocity)
