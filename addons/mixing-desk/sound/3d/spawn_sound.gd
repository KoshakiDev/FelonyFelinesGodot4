extends AudioStreamPlayer3D

func setup():
	connect("finished",Callable(self,"finished"))
	
func finished():
	queue_free() 