import Classifier
from sklearn import preprocessing
import numpy as np
from sklearn.pipeline import Pipeline
from sklearn.ensemble import RandomForestClassifier
from imblearn.over_sampling import RandomOverSampler
import os


class BinaryClassifier(object):

    def __init__(self, base_clf, dataset_filename, save_filename, threshold=0.5):
        self.X, self.Y = Classifier.get_training_data(dataset_filename)
        self.threshold = threshold
        self.save_filename = save_filename
        self.base_clf = base_clf
        scaler = preprocessing.RobustScaler()
        self.clf = Pipeline([('scaler', scaler), ('clf', self.base_clf)])
        self.X = np.array(self.X)
        self.Y = np.array(self.Y)
        self.sampler = RandomOverSampler(random_state=42)


    def fit(self, cv=4):
        #self.clf = Classifier.grid_searching(self.clf, self.X, self.Y, param_grid, cv=cv)
        Classifier.kfold_validation(self.clf, self.X, self.Y, self.sampler, splits_count=cv, threshold=0.50)
        self.X, self.Y = self.sampler.fit_sample(self.X, self.Y)
        self.clf.fit(self.X, self.Y)

        self.save_as_file()


    def predict(self, input):
        predictions = self.clf.predict_proba(input)[:, 1]
        predictions[predictions > self.threshold] = 1
        predictions[predictions <= self.threshold] = 0
        return predictions

    def save_as_file(self):
        Classifier.save_as_file(self.clf, self.save_filename)

    def load_from_file(self):
        if os.path.isfile(self.save_filename):
            print("Loading %s.\n" % (self.save_filename))
            self.clf = Classifier.load_from_file(self.save_filename)
            return True
        else:
            return False

