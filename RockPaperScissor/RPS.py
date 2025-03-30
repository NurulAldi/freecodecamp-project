# The example function below keeps track of the opponent's history and plays whatever the opponent played two plays ago. It is not a very good player so you will need to change the code to pass the challenge.
from random import choice

def player(prev_play, opponent_history=[], play_order=[{}]):

    if not prev_play:
        prev_play = 'P'

    opponent_history.append(prev_play)

    if len(opponent_history) > 5:
        last_five = "".join(opponent_history[-6:])
        
        if last_five in play_order[0]:
            play_order[0][last_five] += 1
        else:
            play_order[0][last_five] = 0

        potential_plays = [
            last_five[-5:] + "R",
            last_five[-5:] + "P",
            last_five[-5:] + "S",
        ]

        sub_order = {
            k: play_order[0][k]
            for k in potential_plays if k in play_order[0]
        }

        if sub_order:
            prediction = max(sub_order, key=sub_order.get)[-1:]

            ideal_response = {'P': 'S', 'R': 'P', 'S': 'R'}
            return ideal_response[prediction]
        
        return "S"
        
