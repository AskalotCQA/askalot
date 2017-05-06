from nltk.corpus import stopwords
from nltk.stem.snowball import SnowballStemmer
from gensim import corpora, utils
import os

MIN_APPEARANCE = 1
MIN_WORD_LENGTH = 2
VOCABULARY_FILENAME = 'recommendation/vocabulary.dat'


class TextualDictionary(object):
    '''
    Class represents corpus dictionary.
    '''

    stemmer = SnowballStemmer('english')
    stop = stopwords.words('english')

    vocabulary = corpora.Dictionary()

    def build_vocabulary(self, textual_objects):
        '''
        Building vocabulary using gensim.
        :return:
        '''
        print("===============================================================")
        print("Building vocabulary by dictionary in gensim.\n")
        corpus = []

        for textual_object in textual_objects:
            text = textual_object.text
            if hasattr(textual_object, 'title'):
                text += textual_object.title
            text = self.preprocess_document(text)
            corpus.append(text)
        self.vocabulary.add_documents(corpus)
        print self.vocabulary
        self.save_vocabulary_as_file()

    def preprocess_document(self, text):
        words = [self.preprocess_word(word) for word in utils.tokenize(text, lowercase=True, deacc= True)]
        return [word for word in words if self.is_valid_word(word)]

    def preprocess_word(self, word):
        '''
        Preprocess word - stemming.
        :param word:
        :return:
        '''
        return self.stemmer.stem(word)

    def is_valid_word(self, word):
        '''
        Check if word is valid - discard short words, stop words
        :param word:
        :return:
        '''
        if len(word) < MIN_WORD_LENGTH or word in self.stop:
            return False
        return True

    def save_vocabulary_as_file(self):
        #print("Saving vocabulary to file.\n")
        self.vocabulary.save(VOCABULARY_FILENAME)


    def load_vocabulary_from_file(self):
        if os.path.isfile(VOCABULARY_FILENAME):
            #print("===============================================================")
            #print("Loading vocabulary from file.\n")
            self.vocabulary = corpora.Dictionary.load(VOCABULARY_FILENAME)
            assert isinstance(self.vocabulary, corpora.Dictionary)
            return True
        else:
            return False