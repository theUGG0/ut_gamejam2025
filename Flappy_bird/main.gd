extends Node
@export var pipe : PackedScene
var game_running : bool
var game_o 
var score
var scroll
const SCROLL_SP : int=4
var screen_size : Vector2i
var pipes : Array
var ground : int
const PIPE_D : int = 100
const PIPE_R : int = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	ground = $Ground.get_node('Sprite2D').texture.get_height()
	new_game()

func new_game():
	game_running = false
	game_o = false
	score = 0
	scroll = 0
	pipes.clear()
	generate_pipes()
	$Lind.reset()

func _input(event):
	if game_o == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if game_running == false:
					start_game()
				else:
					if $Lind.flying:
						$Lind.flap()
						check_top()
				
func start_game():
	game_running = true
	$Lind.flying = true
	$Lind.flap()
	$Score.text = 'SCORE: 0'
	$Timer.start()

func _process(delta: float) -> void:
	if game_running:
		scroll += SCROLL_SP
		if scroll >= screen_size.x:
			scroll = 0
		$Ground.position.x = -scroll
		for pipe in pipes:
			pipe.position.x -= SCROLL_SP
	if $Lind.position.y > screen_size.y:
		stop_game()


func _on_timer_timeout() -> void:
	generate_pipes() # Replace with function body.

func generate_pipes():
	var pipe = pipe.instantiate()
	pipe.position.x = screen_size.x + PIPE_D
	pipe.position.y = (screen_size.y - ground)/2 + randi_range(-PIPE_R, PIPE_R)
	pipe.hit.connect(bird_hit)
	pipe.scored.connect(scored)
	add_child(pipe)
	pipes.append(pipe)
func scored():
	score += 1
	$Score.text = 'SCORE: '+str(score)
func bird_hit():
	$Lind.falling = true
	stop_game()

func check_top():
	if $Lind.position.y <0:
		$Lind.falling= true
		stop_game()

func stop_game():
	$Timer.stop()
	$Lind.flying = false
	game_running = false
	game_o = true
	
	await get_tree().create_timer(2).timeout
	
	var player_prize = null
	if score > 20:
		player_prize = "flappy_bird_big"
	elif score > 10:
		player_prize = "flappy_bird_small"

	GameManager.finish_game("flappy_bird", score, player_prize)

func on_ground_hit():
	$Lind.falling = false
	print('siin')
	stop_game()
