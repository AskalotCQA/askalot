from gensim import corpora
import math

def sum_bows(bow1, bow2):
    '''
    Bow - list of (token_id, token_count) 2-tuples.
    For same token_ids sum token_count.
    :param bow1:
    :param bow2:
    :return:
    '''
    bow_dict = dict(bow1)
    for word in bow2:
        tokenid = word[0]
        count = word[1]
        if bow_dict.get(tokenid) is not None:
            bow_dict[tokenid] = bow_dict[tokenid] + count
        else:
            bow_dict[tokenid] = count
    return [(k, v) for k, v in bow_dict.iteritems()]


def compute_tfidf(tf_bow, vocabulary):
    '''
    Compute tf-idf bow from tf bow from vocabulary data.
    :param tf_bow:
    :param vocabulary:
    :return:
    '''
    assert isinstance(vocabulary, corpora.Dictionary)
    bow_dict = dict(tf_bow)
    bow_count = len(bow_dict)
    for tokenid, tf  in bow_dict.iteritems():
        bow_dict[tokenid] = tf/float(bow_count) * math.log(vocabulary.num_docs / vocabulary.dfs[tokenid])
    return [(k, v) for k, v in bow_dict.iteritems()]


def print_bow(vocabulary, bow):
    '''
    Pretty print of BOW: token id : word : count.
    :param vocabulary:
    :param bow:
    :return:
    '''
    assert isinstance(vocabulary, corpora.Dictionary)
    for word in bow:
        print str(word[0])+" : "+str(vocabulary[word[0]])+" : " + str(word[1])

