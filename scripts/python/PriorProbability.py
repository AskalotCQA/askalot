import math
import numpy as np

class PriorProbability(object):
    features_weights = np.array([1, 1, 1])

    def __init__(self, user):
        self.user = user


    def get_feature_answers(self):
        return (1 - 1 / float(1 + self.user.answers_count + self.user.comments_count))
        #return math.log(1+self.user.answers_count + self.user.comments_count)


    def get_feature_questions(self):
        return (1 - 1 / float(1+self.user.questions_count))
        #return math.log(1+self.user.questions_count)


    def get_feature_votes(self):
        return (1 - 1/float(1+self.user.votes_count))
        #return math.log(1+self.user.votes_count)

    def get_feature_last_answer(self):
        return 0


    def get_probability(self):
        features = np.array([self.get_feature_answers(), self.get_feature_questions(), self.get_feature_votes()])
        return self.features_weights * features



