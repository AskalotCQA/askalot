from sklearn import preprocessing
from sklearn.ensemble import RandomForestClassifier
from Classifier import Classifier

PARAM_GRID = {
            "clf__n_estimators": [20, 60, 100],
            "clf__criterion": ["gini", "entropy"],
            "clf__max_depth": [2, 3, 4, 5, 6]
}

PARAM_GRID_BASELINE = {
            "clf__n_estimators": [20, 60, 100],
            "clf__criterion": ["gini", "entropy"],
            "clf__max_depth": [2, 3, 4]
}


class ExpertiseClassifier(Classifier):
    base_clf = RandomForestClassifier(class_weight="balanced", n_jobs=-1, n_estimators=30, max_depth=4,
                                      criterion="entropy")
    scaler = preprocessing.RobustScaler()
    #sampler = RandomOverSampler(random_state=42)

    data_filename = 'recommendation/expertise-train.dat'

    def __init__(self, model_filename):
        self.model_filename = model_filename
        super(ExpertiseClassifier, self).__init__()


    def fit(self, baseline=False, cv=10):
        print 'Expertise classifier training, baseline: ', baseline
        #self.X, self.Y = self.sampler.fit_sample(self.X, self.Y)
        self.load_training_data()

        if baseline:
            self.X = self.discard_expertise_features(self.X)
            param_grid = PARAM_GRID_BASELINE
        else:
            param_grid = PARAM_GRID

        # Grid searching of best parameters
        self.grid_searching(param_grid, cv)

        # Report cv results
        self.kfold_validation(cv)

        # Train on whole dataset
        self.clf.fit(self.X, self.Y)
        self.save_as_file()

