extends AudioStreamPlayer

func setup():
	connect("finished",Callable(self,"finished"))
	
func finished():
	queue_free() 
