from ExpertiseClassifier import ExpertiseClassifier
from WillingnessClassifier import WillignessClassifier
import numpy as np

class Ensemble(object):

    def __init__(self, exp_model_filename, will_model_filename, baseline):
        self.baseline = baseline
        self.exp_clf = ExpertiseClassifier(exp_model_filename)
        self.will_clf = WillignessClassifier(will_model_filename)

    def fit(self):
        self.exp_clf.fit(self.baseline, cv=6)
        self.will_clf.fit(self.baseline, cv=10)

    def predict(self, X_exp, X_will):
        exp_predictions = self.exp_clf.predict(X_exp)
        will_predictions = self.will_clf.predict(X_will)

        indices = [ind for ind, (i, j) in enumerate(zip(exp_predictions, will_predictions))]
        probabilities = exp_predictions[indices] * will_predictions[indices]

        # Sort descending based on probabilies array
        i = np.array(probabilities).argsort()[::-1]
        indices = np.array(indices)[i]
        return indices, exp_predictions, will_predictions
