from TextualDictionary import TextualDictionary
import sys
import DataManager
from gensim import corpora

def update_vocabulary(question, textual_dictionary):
    # Preprocess question to BoW
    text = textual_dictionary.preprocess_document(question.text +' '+question.title)
    assert isinstance(textual_dictionary.vocabulary, corpora.Dictionary)
    question_bow = textual_dictionary.vocabulary.doc2bow(text, allow_update=True)


if __name__ == '__main__':
    # Load dictionary
    textualDictionary = TextualDictionary()
    if not textualDictionary.load_vocabulary_from_file():
        sys.exit(1)

    # Retrieve question
    question_id = sys.argv[1]
    question = DataManager.get_question(question_id)


    # Update vocabulary with a question
    if question:
        #print 'Updating user profile based on answer'
        update_vocabulary(question, textualDictionary)
        #textualDictionary.save_vocabulary_as_file()

    textualDictionary.save_vocabulary_as_file()
