extends Node

var quests = {}

func add_quest(quest):
	if quest.id not in quests:
		quests[quest.id] = quest
		print("Quest added:", quest.title)
