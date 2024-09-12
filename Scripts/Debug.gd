extends Label
var debug_queue: Dictionary = {}
var output: String
var line: String
# Function to update the label text
func dupdate():
	if debug_queue.size()>0:
		output = ""
		for item in debug_queue.keys():
			output += "\n" + str(item) + ":\t" + str(debug_queue[item])
		text = output
func dpush(key,val):
	debug_queue[key] = val
func dpop(key):
	if debug_queue.has(key):
		debug_queue.erase(key)
