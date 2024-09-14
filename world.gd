extends Node2D
func _ready():
	$Rain_screen/ColorRect.hide()

func _on_timer_timeout():
	$Rain_screen/AnimationPlayer.play("fade_to_normal")
	Rain.start = true
	$Rain_screen/rain.play()
	$Rain_screen/AnimationPlayer.play("fade_to_rain")
	$Rain_screen/Timer.start()


func _on_rain_stop_timeout():
	$Rain_screen/AnimationPlayer.play("fade_to_normal")
	$Rain_screen/AnimationPlayer.play("rain_to_nothing")
	Rain.start = false
	$Rain_screen/music_off.start()
	$CharacterBody2D/Timer.start()


func _on_music_off_timeout():
	$Rain_screen/rain.stop()
