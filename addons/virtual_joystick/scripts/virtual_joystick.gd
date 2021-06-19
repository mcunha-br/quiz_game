tool
extends Node2D

signal movement(movement)

export(Texture) var border = null setget set_border
export(Texture) var stick = null setget set_stick

var joystick = Sprite.new()
var touch = TouchScreenButton.new()
var radius := Vector2(32, 32)
var boundary := 64
var ongoing_drag := -1
var return_accel := 20
var threshold := 10


func set_border(value) -> void:
	border = value if value else load("res://addons/virtual_joystick/sprites/joystick.png")
	update()
	
func set_stick(value) -> void:	
	stick = value if value else load("res://addons/virtual_joystick/sprites/stick.png")
	update()

func _draw() -> void:
	if get_child_count() == 0:
		add_child(joystick)
		
	if joystick.get_child_count() == 0:
		joystick.add_child(touch)
		
	joystick.texture = border
	touch.normal = stick
		

func _ready() -> void:
	update()


func _process(delta: float) -> void:
	if ongoing_drag == -1:
		var pos_difference = (Vector2.ZERO - radius) - touch.position
		touch.position += pos_difference * return_accel * delta
		

func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag or ( event is InputEventScreenTouch and event.is_pressed()):
		var event_dist_from_center = (event.position - global_position).length()

		if event_dist_from_center <= boundary * global_scale.x or event.get_index() == ongoing_drag:
			touch.global_position = event.position - radius * global_scale
			
			if get_button_pos().length() > boundary:
				touch.position = get_button_pos().normalized() * boundary - radius

			ongoing_drag = event.get_index()
			emit_signal("movement", get_button_pos().normalized())

	if event is InputEventScreenTouch and not event.is_pressed() and event.get_index() == ongoing_drag:
		ongoing_drag = -1
		emit_signal("movement", Vector2.ZERO)
		



func get_button_pos() -> Vector2:
	return touch.position + radius
	
func get_value() -> Vector2:
	if get_button_pos().length() > threshold:
		return get_button_pos().normalized()
		
	return Vector2.ZERO

