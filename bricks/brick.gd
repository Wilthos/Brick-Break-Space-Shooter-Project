class_name Brick
extends Node2D

@onready var stats_component: StatsComponent = $StatsComponent
@onready var score_component: ScoreComponent = $ScoreComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var scale_component: ScaleComponent = $ScaleComponent
@onready var flash_component: FlashComponent = $FlashComponent
@onready var shake_component: ShakeComponent = $ShakeComponent
@onready var variable_pitch_audio_stream_player: VariablePitchAudioStreamPlayer = $VariablePitchAudioStreamPlayer


func _ready() -> void:
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
