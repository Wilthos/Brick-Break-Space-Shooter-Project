class_name Brick
extends RigidBody2D

@onready var stats_component: StatsComponent = $StatsComponent
@onready var score_component: ScoreComponent = $ScoreComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
#@onready var scale_component: ScaleComponent = $ScaleComponent
@onready var flash_component: FlashComponent = $FlashComponent
@onready var shake_component: ShakeComponent = $ShakeComponent
@onready var variable_pitch_audio_stream_player: VariablePitchAudioStreamPlayer = $VariablePitchAudioStreamPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


var max_brick_health_flag = true
var max_brick_health = 0 

func _ready() -> void:
	# Get Max Health of the Brick and store for brick status textures
	#print_debug(max_brick_health_flag)
	#print_debug(max_brick_health)
	if stats_component:
		max_brick_health = stats_component.health
		max_brick_health_flag = false
		# this should only run once
	#print_debug(max_brick_health_flag)
	#print_debug(max_brick_health)
	
	stats_component.no_health.connect(func():
		score_component.adjust_score()
		)
		
	hurtbox_component.hurt.connect(func(hitbox: HitboxComponent):
		#scale_component.tween_scale()
		flash_component.flash()
		shake_component.tween_shake()
		variable_pitch_audio_stream_player.play_with_variance()
		#print("Green Enemy Health: ", stats_component.health)
	)
	

func _process(delta: float) -> void:
	# Change the way a brick will look depending on its health levels
	if ((stats_component.health/max_brick_health) <= (2./3.) && (stats_component.health/max_brick_health) > (1./3.)):
		animated_sprite_2d.play("half")
	elif (stats_component.health/max_brick_health) <= (1./3.):
		animated_sprite_2d.play("min")
		

func get_size():
	#print(collision_shape_2d.shape.get_rect().size)
	return collision_shape_2d.shape.get_rect().size
	
func get_width():
	return get_size().x
