from Utils import sum_bows
from TextualDictionary import TextualDictionary
from mock import Mock
from UpdateQuestion import update_vocabulary
from gensim import corpora


def test_sum_bows():
    assert sum_bows([(1, 3), (2,1), (3,2)], [(1,2), (2,1),(4,1)]) == [(1,5),(2,2), (3,2), (4,1)]


def test_text_preprocessing():
    textual_dict = TextualDictionary()
    assert textual_dict.is_valid_word('and') == False
    assert textual_dict.is_valid_word('it') == False
    assert textual_dict.is_valid_word('software') == True
    assert textual_dict.preprocess_document('I have two questions, first is related to some cars and second to travelling') \
        == ['two', 'question', 'first', 'relat', 'car', 'second', 'travel']


def test_update_dictionary():
    textual_dict = TextualDictionary()
    textual_dict.vocabulary = Mock(spec=corpora.Dictionary)
    question = Mock()
    question.text = 'Hello, this is my question'
    question.title = 'A question'
    update_vocabulary(question, textual_dict)
    textual_dict.vocabulary.doc2bow.assert_called_with(['hello', 'question', 'question'], allow_update=True)
