import sys
import DataManager
from TextualDictionary import TextualDictionary
from gensim import corpora, similarities
import Utils
from gensim import matutils

def compute_question_bow(question, textual_dictionary):
    # Preprocess question to BoW
    text = textual_dictionary.preprocess_document(question.text + question.title)
    assert isinstance(textual_dictionary.vocabulary, corpora.Dictionary)
    question_bow = textual_dictionary.vocabulary.doc2bow(text, allow_update=False)
    question_bow = Utils.compute_tfidf(question_bow, textual_dictionary.vocabulary)
    return question_bow


def compute_similarity(user_bow, question, textual_dictionary):
    question_bow = matutils.unitvec(compute_question_bow(question, textual_dictionary))

    similarity = 0
    if user_bow:
        #print 'Found user profile'
        user_bow = DataManager.load_bow_json(user_bow)
        user_bow = matutils.unitvec(Utils.compute_tfidf(user_bow, textual_dictionary.vocabulary))
        similarity_index = similarities.MatrixSimilarity([user_bow], num_features=len(textual_dictionary.vocabulary.keys()))
        sims = similarity_index[question_bow]
        similarity = sims[0]

    return similarity


if __name__ == '__main__':
    # Load dictionary
    textual_dictionary = TextualDictionary()
    if not textual_dictionary.load_vocabulary_from_file():
        sys.exit(1)

    # Retrieve question
    question_id = sys.argv[1]
    question = DataManager.get_question(question_id)

    # Retrieve user
    user_id = sys.argv[2]
    user = DataManager.get_author(user_id)

    # User BoW
    user_profile = DataManager.get_user_profile_property(user_id, 'BoW')

    similarity = 0
    if user_profile:
        similarity = compute_similarity(user_profile.text_value, question, textual_dictionary)

    print similarity

