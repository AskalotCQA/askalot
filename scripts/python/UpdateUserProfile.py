import DataManager
from TextualDictionary import TextualDictionary
import Utils
import json
import sys


def process_answer(answer, textual_dictionary):
    question = DataManager.get_question(answer.question_id)
    return textual_dictionary.preprocess_document(answer.text +' '+ question.title +' '+ question.text)


def process_comment(comment, textual_dictionary):
    return textual_dictionary.preprocess_document(comment.text)


def update_user_profile(textual_dictionary, answer):
    '''
    Update user profile based on answer and answered question and updates total vocabulary.
    :param textual_dictionary:
    :param answer:
    :return:
    '''
    assert isinstance(textual_dictionary, TextualDictionary)
    if hasattr(answer, "question_id"):
        text = process_answer(answer, textual_dictionary)
    else:
        text = process_comment(answer, textual_dictionary)

    # Update with reply text only
    textual_dictionary.vocabulary.add_documents([textual_dictionary.preprocess_document(answer.text)])
    bow = textual_dictionary.vocabulary.doc2bow(text, allow_update=False)

    if len(bow) == 0:
        return

    # Load and update user profile if exist
    user_profile = DataManager.get_user_profile_property(answer.author_id, 'BoW')

    if user_profile:
        print 'Found'
        user_bow = DataManager.load_bow_json(user_profile.text_value)
        bow = Utils.sum_bows(user_bow, bow)
        DataManager.update_user_profile(answer.author_id, 'BoW', json.dumps(dict(bow)))
        #Utils.print_bow(textual_dictionary.vocabulary, bow)
    else:
        print 'Creating'
        DataManager.insert_user_profile(answer.author_id, 'BoW', json.dumps(dict(bow)))
        #Utils.print_bow(textual_dictionary.vocabulary, bow)


if __name__ == '__main__':
    # Load dictionary
    textualDictionary = TextualDictionary()
    if not textualDictionary.load_vocabulary_from_file():
        sys.exit(1)

    type = sys.argv[2]

    if type=="-c":
        answer = DataManager.get_comment(sys.argv[1])
    elif type =="-a":
        # Retrieve new answer
        answer = DataManager.get_answer(sys.argv[1])


    # Update user profile based on answer and question.
    if answer:
        #print 'Updating user profile based on answer'
        update_user_profile(textualDictionary, answer)
        #textualDictionary.save_vocabulary_as_file()

    textualDictionary.save_vocabulary_as_file()
    DataManager.commit_and_close_connection()
