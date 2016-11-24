from sklearn import preprocessing
import numpy as np
from sklearn.pipeline import Pipeline
from sklearn.ensemble import RandomForestClassifier
from Classifier import Classifier

PARAM_GRID = {
            "clf__n_estimators": [60, 100, 200],
            "clf__criterion": ["gini", "entropy"],
            "clf__max_depth": [2, 3, 4, 6, 8],
            "clf__oob_score": [True],
            "clf__class_weight": ["balanced"]
}

PARAM_GRID_BASELINE = {
            "clf__n_estimators": [60, 100, 200],
            "clf__criterion": ["gini", "entropy"],
            "clf__max_depth": [2, 3, 4, 6],
            "clf__oob_score": [True],
            "clf__class_weight": ["balanced"]
}


class WillignessClassifier(Classifier):
    base_clf = RandomForestClassifier(class_weight="balanced", n_jobs=-1, n_estimators=100, max_depth=5,
                                      criterion="entropy", oob_score=True)
    scaler = preprocessing.RobustScaler()
    #sampler = RandomUnderSampler(random_state=42)
    param_grid = PARAM_GRID

    data_filename = 'recommendation/willingness-train.dat'

    def __init__(self, model_filename):
        self.model_filename = model_filename
        super(WillignessClassifier, self).__init__()


    def fit(self, baseline=False, cv=5):
        print 'Willingness classifier training, baseline: ', baseline
        self.load_training_data()

        if baseline:
            self.X = self.discard_willigness_features(self.X)
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
        print 'OOB Score:', self.clf.named_steps['clf'].oob_score_
        print 'Features importances: ', self.clf.named_steps['clf'].feature_importances_
        self.save_as_file()


