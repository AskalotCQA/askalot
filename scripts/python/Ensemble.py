from ExpertiseClassifier import ExpertiseClassifier
from WillingnessClassifier import WillignessClassifier
import numpy as np

class Ensemble(object):

    def __init__(self, exp_model_filename, will_model_filename, baseline):
        self.baseline = baseline
        self.exp_clf = ExpertiseClassifier(exp_model_filename)
        self.will_clf = WillignessClassifier(will_model_filename)


    def fit(self):
        self.exp_clf.fit(self.baseline, cv=10)
        self.will_clf.fit(self.baseline, cv=6)

    def predict(self, X_exp, X_will):
        exp_predictions = self.exp_clf.predict(X_exp)
        will_predictions = self.will_clf.predict(X_will)
        #print 'Exp pred: ', exp_predictions
        #print 'Will pred:', will_predictions
        rec_user_ids = []
        rec_users_probs = []
        #for ind, (exp_prob,will_prob) in enumerate(zip(exp_predictions, will_predictions)):
        #    if exp_prob > 0.5 and will_prob > 0.5:
        #        rec_user_ids.append(ind)


        indices = [ind for ind, (i, j) in enumerate(zip(exp_predictions, will_predictions))]
        suma = exp_predictions[indices] * will_predictions[indices]
        i = np.array(suma).argsort()[-200:][::-1]
        indices = np.array(indices)[i]
        #suma, indices = zip(*sorted(zip(suma, indices)))
        #print 'Exp probs:', np.take(exp_predictions, indices)
        #print 'Will probs:', np.take(will_predictions, indices)
        return indices, exp_predictions, will_predictions
