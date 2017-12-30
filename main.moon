luna = require "luna"
import Choice, Dialog, Conversation from luna

json = require "lib/json"
yaml   = require "yaml"

main = ->
  --file = io.open("dialog.json", "r")
  --json_data = file\read("*all")
  --file\close!
  --encoded=json_data
  --dialog_data = json.decode(encoded)

  file = io.open("demo.yml", "r")
  yaml_data = file\read("*all")
  file\close!
  encoded=yaml_data
  dialog_data = yaml.load(encoded)
  c = luna.Conversation.Load(dialog_data)

  i = c\new_interaction!
  while i.current != nil
      if type(i.current) == Choice
          print string.format("%s:\n    %s", i.current.actor.name, i.current.copy)
          results = i.current\choices!
          choice = 1
          for prompt in *results
              print string.format("        %d. %s", choice, prompt.copy)
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
          os.execute("clear")
          i\next(choice)
      else
          print string.format("%s:\n    %s", i.current.actor.name, i.current.copy)
          i\next()
main!
