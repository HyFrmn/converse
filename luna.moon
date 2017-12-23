require "moon.all"
json = require "json"
actions = require "actions"

file = io.open("dialog.json", "r")
json_data = file\read("*all")
file\close!
encoded=json_data
dialog_data = json.decode(encoded)

-- prompting
-- responding
PROMPTING=0
RESPONDING=1

class Dialog
	new: (data) =>
		@name = data.name
		@responses = data.responses
		@prompts = data.prompts
		@blackboard = {}
		@current_prompts
		@current_choices = nil
		@state = PROMPTING

	get_prompts: =>
		results = {}
		if @current_prompts == nil
			@current_prompts = @prompts
		for name, prompt in pairs(@current_prompts)
			include = true
			if prompt.conditions != nil
				include = false
				for condition in *prompt.conditions
					key, compare, val = unpack condition
					if compare == "is"
						if val == "truthy"
							if @blackboard[key]==true
								include=true
						else
							if @blackboard[key]==false or @blackboard[key]==nil
								include=true
			if include
				table.insert results, prompt
		@current_choices = results
		return @current_choices

	get_choice: (choice) =>
		r = @current_choices[choice].response
		response =  @responses[r]
		if response.actions != nil
			for action in *response.actions
				if actions[action[1]] != nil
					actions[action[1]](@, action)
		@current_choices = nil
		@current_prompts = response.prompts
		return response

main = ->
	d = Dialog(dialog_data)
	while true
		results = d\get_prompts!
		choice = 1
		for prompt in *results
			print choice .. ". " .. prompt.text
			choice += 1

		choice = nil
		success = false
		while success == false
			choice = io.read("*n")
			if choice != nil
				success = true
			else
				print "Invalid input, please try again."
				io.read()

		response = d\get_choice(choice)
		print response.text

main!
