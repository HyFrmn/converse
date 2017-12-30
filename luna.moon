require "moon.all"
actions = require "actions"

-- prompting
-- responding
PROMPTING=0
RESPONDING=1

class Actor
    new: (id, name) =>
        @id = id
        @name = name

class Dialog
    new: (actor, copy, nxt) =>
        @actor = actor
        @copy = copy
        @id = -1
        @next = nxt

class Choice extends Dialog
    new: (actor, copy, choices) =>
        super(actor, copy)
        @_choices = choices

    choices: =>
        return @_choices

class Interaction
    new: (conversation, first) =>
        @conversation = conversation
        @current = conversation.start

    next: (choice=-1) =>
        id = nil
        if type(@current) == Choice
            c = @current\choices()[choice]
            id = c.node
        else
            id = @current.next
        @current = nil
        if id != nil
            @current = @conversation.nodes[id]

class Conversation
    new: () =>
        @actors = {}
        @nodes = {}
        @memory = {}
        @start = nil

    Load: (data) ->
        c = Conversation()
        for a in *data.actors
            actor = Actor(a.id, a.name)
            c.actors[a.id] = actor
        for id, node in pairs(data.nodes)
            if node.choices != nil
                n = Choice(c.actors[node.actor], node.copy, node.choices)
                c.nodes[id] = n
                n.id = id
            else
                n = Dialog(c.actors[node.actor], node.copy, node.next)
                c.nodes[id] = n
                n.id = id
        c.start = c.nodes[data.start]
        return c

    new_interaction: =>
        return Interaction(@, @start)

-- Example Usage
main = ->
    narrator = Actor("")
    pc = Actor("Arnold")
    wit1 = Actor("Delores")
    wit2 = Actor("Mavie")
    wit3 = Actor("Teddy")


    a = Dialog(wit1, "I saw a man run out of the bank and down the street.")
    b = Dialog(wit2, "Some one wearing a red shirt knocked me down on my way into the bank.")
    c = Dialog(wit3, "I saw some one in a red shirt, ride out of town west. They were riding a black horse with white spots.")

    choice = Choice(pc, "Who would you like to talk to?", {
        {a, "Interview witness 1"}
        {b, "Interview witness 2"}
        {c, "Interview witness 3"}
        {nil, "Exit"}
    })

    a.next = choice
    b.next = choice
    c.next = choice

    i = Interaction(choice)





{
    :main
    :Actor
    :Choice
    :Dialog
    :Interaction
    :Conversation
}
