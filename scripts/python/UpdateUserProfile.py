import DataManager
from TextualDictionary import TextualDictionary
import Utils
import json
import sys


def update_user_profile(textual_dictionary, answer):
    '''
    Update user profile based on answer and answered question.
    :param textual_dictionary:
    :param answer:
    :return:
    '''
    assert isinstance(textual_dictionary, TextualDictionary)
    question = DataManager.get_question(answer.question_id)
    text = textual_dictionary.preprocess_document(answer.text + question.title + question.text)
    # Allow update set to true/false
    bow = textual_dictionary.vocabulary.doc2bow(text, allow_update=True)

    # Load and update user profile if exist
    user_profile = DataManager.get_user_profile_property(answer.author_id, 'BoW')

    if user_profile:
        print 'Found user profile'
        user_bow = DataManager.load_bow_json(user_profile.text_value)
        bow = Utils.sum_bows(user_bow, bow)
        DataManager.update_user_profile(answer.author_id, 'BoW', json.dumps(dict(bow)))
        #Utils.print_bow(textual_dictionary.vocabulary, bow)
    else:
        print 'Creating user profile'
        DataManager.insert_user_profile(answer.author_id, 'BoW', json.dumps(dict(bow)))
        #Utils.print_bow(textual_dictionary.vocabulary, bow)


if __name__ == '__main__':
    # Load dictionary
    textualDictionary = TextualDictionary()
    if not textualDictionary.load_vocabulary_from_file():
        sys.exit(1)

    # Retrieve new answer
    answer_id = sys.argv[1]
    answer = DataManager.get_answer(answer_id)


    # Update user profile based on answer and question.
    if answer:
        print 'Updating user profile based on answer'
        update_user_profile(textualDictionary, answer)
        #textualDictionary.save_vocabulary_as_file()

    textualDictionary.save_vocabulary_as_file()
    DataManager.commit_and_close_connection()
