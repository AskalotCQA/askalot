import PlaygroundClassifier
from sklearn import preprocessing
import numpy as np
from sklearn.pipeline import Pipeline
from sklearn.ensemble import RandomForestClassifier
from Classifier import Classifier

PARAM_GRID = {
            "clf__n_estimators": [20, 60, 100],
            "clf__criterion": ["gini", "entropy"],
            "clf__max_depth": [2, 3, 4, 6, 8]
}

PARAM_GRID_BASELINE = {
            "clf__n_estimators": [20, 60, 100],
            "clf__criterion": ["gini", "entropy"],
            "clf__max_depth": [2, 3, 4, 6]
}


class WillignessClassifier(Classifier):
    base_clf = RandomForestClassifier(class_weight="balanced", n_jobs=-1, n_estimators=100, max_depth=5,
                                      criterion="entropy")
    scaler = preprocessing.RobustScaler()
    #sampler = RandomUnderSampler(random_state=42)
    param_grid = PARAM_GRID

    data_filename = '/media/dmacjam/Data disc1/git/Askalot-dev/askalot/recommendation/willingness-train.dat'

    def __init__(self, model_filename):
        self.model_filename = model_filename
        super(WillignessClassifier, self).__init__()


    def fit(self, baseline=False, cv=5):
        print 'Willingness classifier training, baseline: ', baseline
        self.load_training_data()

        if baseline:
            self.X = PlaygroundClassifier.discard_willigness_features(self.X)
            param_grid = PARAM_GRID_BASELINE
        else:
            param_grid = PARAM_GRID

        # Grid searching of best parameters
        self.grid_searching(param_grid, cv)

        # Report cv results
        self.kfold_validation(cv)

        # Train on whole dataset
        #self.X, self.Y = self.sampler.fit_sample(self.X, self.Y)
        self.clf.fit(self.X, self.Y)
        self.save_as_file()


