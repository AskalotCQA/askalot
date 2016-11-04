import numpy as np


def success(predicted_users_ids, true_id, n=10):
    if true_id in predicted_users_ids[:n]:
        return 1
    else:
        return 0


def true_rank(predicted_users_ids, true_id):
    indices = np.where(predicted_users_ids == true_id)[0]
    if indices.size > 0:
        return indices[0]+1
    else:
        return 0