import logging
import sys
import DataManager
from TextualDictionary import TextualDictionary
from gensim import corpora, similarities
import Utils

# Set up gensim logging
logging.basicConfig(format='%(asctime)s : %(levelname)s : %(message)s', level=logging.INFO)

filename = '/media/dmacjam/Data disc1/git/Askalot-dev/askalot/tmp/return-values.dat'

if __name__ == '__main__':
    # Retrieve question
    question_id = sys.argv[1]
    question = DataManager.get_question(question_id)

    # Retrieve user
    user_id = sys.argv[2]
    user = DataManager.get_author(user_id)

    # Load dictionary
    textualDictionary = TextualDictionary()
    if not textualDictionary.load_vocabulary_from_file():
        sys.exit(1)

    # Preprocess question to BoW
    text = textualDictionary.preprocess_document(question.text + question.title)
    assert isinstance(textualDictionary.vocabulary, corpora.Dictionary)
    question_bow = textualDictionary.vocabulary.doc2bow(text)
    print 'TF BoW: ',question_bow
    question_bow = Utils.compute_tfidf(question_bow, textualDictionary.vocabulary)
    print 'TF-IDF BoW: ', question_bow

    # User BoW
    user_profile = DataManager.get_user_profile(user_id, 'BoW')
    similarity = 0
    if user_profile:
        print 'Found user profile'
        user_bow = DataManager.load_bow_json(user_profile.text_value)
        print len(textualDictionary.vocabulary.keys())
        similarity_index = similarities.MatrixSimilarity([user_bow], num_features=len(textualDictionary.vocabulary.keys()))
        sims = similarity_index[question_bow]
        similarity = sims[0]

    print 'Writing similarity: ', similarity
    with open(filename, 'w') as f:
        f.write(str(similarity))


