extends Control

const SAVE_PATH = "user://save.cfg"
const TEST_SAVE_PATH = "res://save.cfg"

@export var game_stats: GameStats

var save_path = TEST_SAVE_PATH

@onready var score_value: Label = %ScoreValue
@onready var high_score_value: Label = %HighScoreValue



func _ready() -> void:
	load_highscore()
	if game_stats.score > game_stats.highscore:
		game_stats.highscore = game_stats.score
		save_highscore()
	score_value.text = str(game_stats.score)
	high_score_value.text = str(game_stats.highscore)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		# Reset Level Values
		game_stats.score = 0
		game_stats.enemy_destroyed_count = 0
		game_stats.damage_taken = 0
		game_stats.enemy_passed_count = 0
		game_stats.maxcombo = 0
		game_stats.combo_count = 0
		get_tree().change_scene_to_file("res://world.tscn")

func load_highscore() -> void:
	var config = ConfigFile.new()
	var error = config.load(save_path)
	if error != OK: return
	game_stats.highscore = config.get_value("game", "highscore")
	
func save_highscore() -> void:
	var config = ConfigFile.new()
	config.set_value("game","highscore", game_stats.highscore)
	config.save(save_path)
	
