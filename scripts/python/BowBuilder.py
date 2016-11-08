import json
import DataManager
from TextualDictionary import TextualDictionary
import UpdateUserProfile


def persist_for_questions(textual_dictionary, questions):
    '''
    Persist BoW for each question to question profile.
    '''
    print("===============================================================")
    print("Creating BoW for questions.\n")
    assert isinstance(textual_dictionary, TextualDictionary)
    for question in questions:
        text = textual_dictionary.preprocess_document(question.text + question.title)
        bow = textual_dictionary.vocabulary.doc2bow(text)
        bow_json = json.dumps(dict(bow))
        DataManager.insert_question_profile(question, 'BoW', bow_json)


def persist_for_users(textual_dictionary, answers):
    '''
    Persist for each user as aggregation of all user's answers and answered questions texts.
    :param textual_dictionary:
    :param answers:
    '''
    print("===============================================================")
    print("Creating BoW for users.\n")
    assert isinstance(textual_dictionary, TextualDictionary)
    for answer in answers:
        UpdateUserProfile.update_user_profile(textual_dictionary, answer)



