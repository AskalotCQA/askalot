import logging
import sys
import Utils
import DataManager
from TextualDictionary import TextualDictionary
from gensim import corpora, similarities
import RoutingOptimization
import numpy as np

# Set up gensim logging
logging.basicConfig(format='%(asctime)s : %(levelname)s : %(message)s', level=logging.INFO)


if __name__ == '__main__':
    # Retrieve new question
    question_id = sys.argv[1]
    question = DataManager.get_question(question_id)

    # Load dictionary
    textualDictionary = TextualDictionary()
    if not textualDictionary.load_vocabulary_from_file():
        sys.exit(1)
    print 'Num docs processed by vocabulary ', textualDictionary.vocabulary.num_docs

    # Preprocess question to BoW
    print 'Preprocessing question to BoW representation'
    text = textualDictionary.preprocess_document(question.text + question.title)
    assert isinstance(textualDictionary.vocabulary, corpora.Dictionary)
    question_bow = textualDictionary.vocabulary.doc2bow(text)
    print 'TF BoW: ',question_bow
    question_bow = Utils.compute_tfidf(question_bow, textualDictionary.vocabulary)
    print 'TF-IDF BoW: ', question_bow

    # Filter users - all users that have user profile
    print 'Computing similarity index for all user profiles'
    user_profiles = DataManager.get_all_user_profiles_property('BoW')
    user_profiles_matrix = []
    user_ids = []   # mapping user profiles id to user_id
    for user_profile in user_profiles:
        user_bow = DataManager.load_bow_json(user_profile.text_value)
        user_bow = Utils.compute_tfidf(user_bow, textualDictionary.vocabulary)
        user_profiles_matrix.append(user_bow)
        user_ids.append(user_profile.user_id)
    similarity_index = similarities.MatrixSimilarity(user_profiles_matrix)
    print 'Number of users with user profiles is '+str(len(user_ids))

    # Compute probabilities of users given question - vector * matrix
    print 'Computing cosine similarity question(vector) X users(matrix)'
    similarity_index.num_best = 20
    sims = similarity_index[question_bow]
    optimization_values = []
    chosen_users = []
    probabilities = []
    for i, sim in enumerate(sims):
        print 'User #'+str(i+1)+" is "+str(user_ids[sim[0]])+" with P = "+str(sim[1])
        probabilities.append(sim[1])
        user = DataManager.get_author(user_ids[sim[0]])
        chosen_users.append(user)
        optimization_value = RoutingOptimization.optimization_value(user, question)
        optimization_values.append(optimization_value)
        print optimization_value

    # TODO if chosen users length is zero, route to teacher

    # Normalize probabilities and optimization values
    optimization_values = np.array(optimization_values)
    optimization_values = optimization_values / float(optimization_values.max())
    probabilities = np.array(probabilities)
    probabilities = probabilities / probabilities.max()

    total_probabilities = probabilities - optimization_values

    sorted_total_prob = np.array(total_probabilities)
    print "After optimization"
    for i, index in enumerate(np.argsort(sorted_total_prob)[::-1]):
        print 'User #'+str(i+1)+" is "+str(chosen_users[index].id)+" with P = "+str(total_probabilities[index])


