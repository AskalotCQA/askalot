from sklearn import preprocessing
from sklearn.ensemble import RandomForestClassifier
from Classifier import Classifier

PARAM_GRID = {
            "clf__n_estimators": [100],
            "clf__criterion": ["gini"],
            "clf__max_depth": [4],
            "clf__oob_score": [True],
            "clf__class_weight": ["balanced"]
}

PARAM_GRID_BASELINE = {
            "clf__n_estimators": [100],
            "clf__criterion": ["gini"],
            "clf__max_depth": [4],
            "clf__oob_score": [True],
            "clf__class_weight": ["balanced"]
}


class ExpertiseClassifier(Classifier):
    base_clf = RandomForestClassifier(class_weight="balanced", n_jobs=-1, n_estimators=30, max_depth=4,
                                      criterion="entropy", oob_score=True)
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
        print 'OOB Score:', self.clf.named_steps['clf'].oob_score_
        print 'Features importances: ', self.clf.named_steps['clf'].feature_importances_
        self.save_as_file()


    def predict(self, baseline, input):
        if baseline:
            input = self.discard_expertise_features(input)
        return self.clf.predict_proba(input)[:, 1]

