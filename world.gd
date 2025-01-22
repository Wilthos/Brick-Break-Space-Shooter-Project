extends Node2D

@export var game_stats: GameStats
@export var ball_speed = 50 

@onready var ship: Node2D = $Ship
@onready var score_label: Label = $ScoreLabel
@onready var player_ball: PlayerBall = $PlayerBall

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	player_ball.position = Vector2(80,200)
	#player_ball.position = Vector2(40,200)
	#player_ball.move_component.velocity = Vector2(0,50)
	player_ball.move_component.velocity = Vector2(randf_range(-1, 1), randf_range(-.1, -1)).normalized() * ball_speed
	update_score_label(game_stats.score)
	game_stats.score_changed.connect(update_score_label)
	
	ship.tree_exiting.connect(func():
		await get_tree().create_timer(1.0).timeout # Quick code for a timer
		get_tree().change_scene_to_file("res://menus/game_over.tscn")
	)
	
	# Game over if the ball loses all health
	player_ball.tree_exiting.connect(func():
		await get_tree().create_timer(1.0).timeout # Quick code for a timer
		get_tree().change_scene_to_file("res://menus/game_over.tscn")
	)

func update_score_label(new_score: int) -> void:
	score_label.text = "Score: " + str(new_score)
