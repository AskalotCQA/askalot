import PlaygroundClassifier
from sklearn import preprocessing
import numpy as np
from sklearn.pipeline import Pipeline
from sklearn.ensemble import RandomForestClassifier
from imblearn.under_sampling import RandomUnderSampler
from Classifier import Classifier


class WillignessClassifier(Classifier):
    base_clf = RandomForestClassifier(class_weight="balanced", n_jobs=-1, n_estimators=100, max_depth=5,
                                      criterion="entropy")
    scaler = preprocessing.RobustScaler()
    sampler = RandomUnderSampler(random_state=42)

    save_filename = '/media/dmacjam/Data disc1/git/Askalot-dev/askalot/tmp/willingness-classifier.pkl'
    data_filename = '/media/dmacjam/Data disc1/git/Askalot-dev/askalot/tmp/willingness-train.dat'

    def __init__(self):
        super(WillignessClassifier, self).__init__()
        #self.X, self.Y = self.sampler.fit_sample(self.X, self.Y)



    def fit(self, cv=5):
        if self.load_from_file():
            return
        self.clf.named_steps['clf'] = PlaygroundClassifier.grid_searching(self.clf.named_steps['clf'], self.X, self.Y, cv=cv)

        # Compute cv results
        PlaygroundClassifier.kfold_validation(self.clf, self.X, self.Y, self.sampler, splits_count=cv)

        # Train on whole dataset
        self.X, self.Y = self.sampler.fit_sample(self.X, self.Y)
        self.clf.fit(self.X, self.Y)
        self.save_as_file()


