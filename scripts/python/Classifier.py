from sklearn.externals import joblib
import numpy as np
import PlaygroundClassifier
from sklearn.pipeline import Pipeline
import os



class Classifier(object):
    threshold = 0.5

    def __init__(self):
        self.X, self.Y = PlaygroundClassifier.get_training_data(self.data_filename)
        self.clf = Pipeline([('scaler', self.scaler), ('clf', self.base_clf)])
        self.X = np.array(self.X)
        self.Y = np.array(self.Y)

    def predict(self, input):
        predictions = self.clf.predict_proba(input)[:, 1]
        #predictions[predictions > self.threshold] = 1
        #predictions[predictions <= self.threshold] = 0
        return predictions

    def save_as_file(self):
        joblib.dump(self.clf, self.save_filename)

    def load_from_file(self):
        if os.path.isfile(self.save_filename):
            #print("Loading %s.\n" % (self.save_filename))
            self.clf = joblib.load(self.save_filename)
            return True
        else:
            return False