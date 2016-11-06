import PlaygroundClassifier
from sklearn import preprocessing
import numpy as np
from sklearn.ensemble import RandomForestClassifier
from imblearn.over_sampling import RandomOverSampler
from Classifier import Classifier
from sklearn.linear_model import SGDClassifier


class ExpertiseClassifier(Classifier):
    base_clf = RandomForestClassifier(class_weight="balanced", n_jobs=-1, n_estimators=30, max_depth=4,
                                      criterion="entropy")
    scaler = preprocessing.RobustScaler()
    sampler = RandomOverSampler(random_state=42)

    save_filename = '/media/dmacjam/Data disc1/git/Askalot-dev/askalot/tmp/expertise-classifier.pkl'
    data_filename = '/media/dmacjam/Data disc1/git/Askalot-dev/askalot/tmp/expertise-train.dat'

    def __init__(self):
        super(ExpertiseClassifier, self).__init__()
        #self.X, self.Y = self.sampler.fit_sample(self.X, self.Y)


    def fit(self, cv=10):
        if self.load_from_file():
            return
        self.clf.named_steps['clf'] = PlaygroundClassifier.grid_searching(self.clf.named_steps['clf'], self.X, self.Y, cv=cv)

        # Compute cv results
        PlaygroundClassifier.kfold_validation(self.clf, self.X, self.Y, self.sampler, splits_count=cv)

        # Train on whole dataset
        self.X, self.Y = self.sampler.fit_sample(self.X, self.Y)
        self.clf.fit(self.X, self.Y)
        self.save_as_file()

