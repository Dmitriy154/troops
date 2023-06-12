extends Node

#troop
signal updateTroop(state)

#UI
#signal menu_action_selected(action)

#Использование, любой скрипт может подписаться на эти события
#Events.connect('menu_action_selected', self, 'update_menu')
#вместо self любой узел через ... $Box, 'set_value')
