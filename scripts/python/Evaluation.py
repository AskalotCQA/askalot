import numpy as np


def success(predicted_users_ids, true_ids, n=10):
    if np.in1d(true_ids, predicted_users_ids[:n]).sum() > 0:
        return 1
    else:
        return 0


def get_relevances(actual, predicted, k=10):
    if len(predicted)>k:
        predicted = predicted[:k]

    relevances = []
    for p in predicted:
        if p in actual:
            relevances.append(1)
        else:
            relevances.append(0)

    return relevances


def precision_at_k(actual, predicted, k=10):
    if len(predicted)>k:
        predicted = predicted[:k]

    num_hits = 0.0
    for p in predicted:
        if p in actual:
            num_hits += 1.0

    if not actual:
        return 0.0

    return num_hits / min(len(actual), k)

def reciprocal_rank(actual, predicted, k=10):
    #if len(predicted)>k:
    #    predicted = predicted[:k]

    for i,p in enumerate(predicted):
        if p in actual:
            return float(1)/(i+1)
    return 0

def apk(actual, predicted, k=10):
    """
    Computes the average precision at k.
    This function computes the average prescision at k between two lists of
    items.
    Parameters
    ----------
    actual : list
             A list of elements that are to be predicted (order doesn't matter)
    predicted : list
                A list of predicted elements (order does matter)
    k : int, optional
        The maximum number of predicted elements
    Returns
    -------
    score : double
            The average precision at k over the input lists
    """
    if len(predicted)>k:
        predicted = predicted[:k]

    score = 0.0
    num_hits = 0.0

    for i,p in enumerate(predicted):
        if p in actual and p not in predicted[:i]:
            num_hits += 1.0
            score += num_hits / (i+1.0)

    if not actual:
        return 0.0

    return score / min(len(actual), k)


def dcg_score(relevances, k=10):
    relevances = relevances[:k]
    gains = 2 ** relevances - 1

    # highest rank is 1 so +2 instead of +1
    discounts = np.log2(np.arange(len(relevances)) + 2)
    return np.sum(gains / discounts)


def ndcg_score(actual, predicted, k=10):
    relevances = np.array(get_relevances(actual, predicted, k))
    dcg = dcg_score(relevances, k)

    order = np.argsort(relevances)[::-1]
    best_relevances = np.take(relevances, order[:k])
    best = dcg_score(best_relevances, k)

    if best > 0:
        return dcg / best
    return 0


if __name__ == '__main__':
    print ndcg_score(np.array([5,3,4]), np.array([1,2,3,4,6,7,8,5,9,10,11,12]), k=10)
