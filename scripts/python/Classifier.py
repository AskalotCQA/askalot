from sklearn.externals import joblib
import numpy as np
from sklearn.pipeline import Pipeline
import os
from sklearn.model_selection import GridSearchCV
from sklearn import metrics
from sklearn import base
from sklearn.model_selection import StratifiedKFold
import Utils
from collections import Counter


class Classifier(object):
    threshold = 0.5

    def __init__(self):
        self.clf = Pipeline([('scaler', self.scaler), ('clf', self.base_clf)])
        self.load_from_file()

    def load_training_data(self):
        self.X, self.Y = self.get_training_data()
        self.X = np.array(self.X)
        self.Y = np.array(self.Y)

    def grid_searching(self, param_grid, cv):
        print 'Grid searching...'
        grid_search = GridSearchCV(self.clf, param_grid=param_grid, cv=cv,
                                   scoring=metrics.make_scorer(metrics.roc_auc_score, average='weighted'))
        grid_search.fit(self.X, self.Y)
        Utils.report(grid_search.cv_results_)
        # Use best estimator
        self.clf = grid_search.best_estimator_

    def kfold_validation(self, splits_count):
        clf = base.clone(self.clf)

        k_fold = StratifiedKFold(n_splits=splits_count)
        auc_scores = []
        f1_scores = []
        for train, test in k_fold.split(self.X, self.Y):
            print('Dataset shape {}'.format(Counter(self.Y[train])))
            clf.fit(self.X[train], self.Y[train])
            predictions = clf.predict_proba(self.X[test])[:, 1]
            threshold = self.find_threshold_auc(self.Y[test], predictions)
            predictions[predictions > threshold] = 1
            predictions[predictions <= threshold] = 0
            print metrics.precision_recall_fscore_support(self.Y[test], predictions)
            auc_scores.append(metrics.roc_auc_score(self.Y[test], predictions, average="weighted"))
            f1_scores.append(metrics.f1_score(self.Y[test], predictions, average='weighted'))
        auc_scores = np.array(auc_scores)
        f1_scores = np.array(f1_scores)
        print("%d-fold AUC: %0.2f (+/- %0.2f)" % (splits_count, auc_scores.mean(), auc_scores.std()))
        print("%d-fold F1: %0.2f (+/- %0.2f)" % (splits_count, f1_scores.mean(), f1_scores.std()))

    def find_threshold_auc(self, Y_true, Y_pred_prob):
        thresholds = np.arange(0.01, 1.0, 0.01)
        best_threshold = 0.5
        maximum = 0
        for t in thresholds:
            y = np.copy(Y_pred_prob)
            y[Y_pred_prob > t] = 1
            y[Y_pred_prob <= t] = 0
            current_auc = metrics.roc_auc_score(Y_true, y, average='weighted')
            if current_auc > maximum:
                maximum = current_auc
                best_threshold = t
        return best_threshold

    def discard_expertise_features(self, X):
        # knowledge gap: topic - 5, week -6, total -7
        # seen units: week -8, topic - 9
        # grade: 10
        return np.delete(X, [5, 6, 7, 8, 9, 10], axis=1)

    def discard_willigness_features(self, X):
        # seen units: week - 5, topic - 6
        # fresh unit - 7
        # avg activity: course - 9
        # seen questions: week - 10, topic - 11
        return np.delete(X, [5, 6, 7, 9, 10, 11], axis=1)

    def get_training_data(self):
        f = open(self.data_filename, "r")
        X = []
        Y = []
        for line in f:
            line_list = line.split()
            Y.append(int(line_list.pop(0)))
            X.append([float(i) for i in line_list])
        return X, Y


    def save_as_file(self):
        joblib.dump(self.clf, self.model_filename)

    def load_from_file(self):
        if os.path.isfile(self.model_filename):
            #print("Loading %s.\n" % (self.save_filename))
            self.clf = joblib.load(self.model_filename)
            return True
        else:
            return False

