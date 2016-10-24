import logging
import sys
import BowBuilder
import DataManager
from TextualDictionary import TextualDictionary

# Set up gensim logging
logging.basicConfig(format='%(asctime)s : %(levelname)s : %(message)s', level=logging.INFO)

if __name__ == '__main__':
    # Idea:
    # Process all of posts - create dictionary - later it will be called with add_documents
    # Create BOW for every user of all his posts and every question

    questions_yield = DataManager.get_questions_for_course(sys.argv[1])
    answers_yield = DataManager.get_answers_for_course(sys.argv[1])

    # Create vocabulary
    textualDictionary = TextualDictionary()
    if not textualDictionary.load_vocabulary_from_file():
        textualDictionary.build_vocabulary(questions_yield)
        #textualDictionary.build_vocabulary(answers_yield)

    # Create user BOW
    #questions = DataManager.get_questions_for_course(sys.argv[1])
    #BowBuilder.persist_for_questions(textualDictionary, questions)
    #answers_yield = DataManager.get_answers_for_course(sys.argv[1])
    #BowBuilder.persist_for_users(textualDictionary, answers_yield)

    #print BowBuilder.sum_bows([(1, 3), (2,1), (3,2)], [(1,2), (2,1),(4,1)])    # test sum bows

    DataManager.close_connection()