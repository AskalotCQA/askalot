import numpy as np
from sklearn.linear_model import SGDClassifier
from sklearn import svm
from sklearn.ensemble import RandomForestClassifier
from sklearn import metrics
from sklearn import preprocessing, feature_selection
from sklearn.model_selection import StratifiedKFold, cross_val_score, train_test_split, validation_curve
from scipy import stats
from collections import Counter
from imblearn.under_sampling import RandomUnderSampler, ClusterCentroids, TomekLinks
from imblearn.over_sampling import RandomOverSampler
from imblearn.combine import SMOTEENN
import matplotlib.pyplot as plt
from scipy.stats import pearsonr
from sklearn.model_selection import GridSearchCV
from sklearn.pipeline import Pipeline
from sklearn.externals import joblib
from sklearn.calibration import CalibratedClassifierCV


#filename = '/media/dmacjam/Data disc1/git/Askalot-dev/askalot/tmp/expertise-train.dat'
filename = '/media/dmacjam/Data disc1/git/Askalot-dev/askalot/tmp/willingness-train.dat'

def get_training_data(filename):

    f = open(filename, "r")
    X = []
    Y = []
    for line in f:
        line_list = line.split()
        Y.append(int(line_list.pop(0)))
        X.append([float(i) for i in line_list])
    return X, Y


# Utility function to report best scores
def report(results, n_top=3):
    for i in range(1, n_top + 1):
        candidates = np.flatnonzero(results['rank_test_score'] == i)
        for candidate in candidates:
            print("Model with rank: {0}".format(i))
            print("Mean validation score: {0:.3f} (std: {1:.3f})".format(
                  results['mean_test_score'][candidate],
                  results['std_test_score'][candidate]))
            print("Parameters: {0}".format(results['params'][candidate]))
            print("")


def grid_searching(clf, X , Y, cv=6):
    param_grid = {
        "n_estimators": [20, 60, 100 ],
        "criterion": ["gini", "entropy"],
        "max_depth": [2, 3, 4, 6, 8, 10]
    }
    print 'Grid searching...'
    grid_search = GridSearchCV(clf, param_grid=param_grid, cv=cv, scoring=metrics.make_scorer(metrics.roc_auc_score,
                                                                                              average='weighted'))
    grid_search.fit(X, Y)
    print report(grid_search.cv_results_)
    return grid_search.best_estimator_


def select_features(X, Y):
    scores, pvaues = feature_selection.f_classif(X, Y)
    print 'ANOVA f-values: ', scores
    print 'ANOVA p-values: ', pvaues


def describe_dataset(X, Y):
    print('Original dataset shape {}'.format(Counter(Y)))


def roc_curve(Y_true, Y_pred_prob):
    fpr, tpr, thresholds = metrics.roc_curve(Y_true, Y_pred_prob, pos_label=1, drop_intermediate=False)
    plt.plot(fpr, tpr)
    plt.xlim([0.0, 1.0])
    plt.ylim([0.0, 1.0])
    plt.title("ROC curve")
    plt.xlabel("FPR (1 - Specificity)")
    plt.ylabel("TPR (Sensitivity)")
    plt.grid(True)
    plt.show()


def find_optimal_threshold(Y_true, Y_pred_prob):
    thresholds = np.arange(0.01, 1, 0.01)
    best_threshold = 0.5
    maximum = 0
    for t in thresholds:
        # Classifier / label agree and disagreements for current threshold.
        TP_t = np.logical_and( Y_pred_prob >  t, Y_true==1 ).sum()
        TN_t = np.logical_and( Y_pred_prob <= t, Y_true==0 ).sum()
        FP_t = np.logical_and( Y_pred_prob >  t, Y_true==0 ).sum()
        FN_t = np.logical_and( Y_pred_prob <= t, Y_true==1 ).sum()

        # Compute true  positive rate for current threshold.
        TPR_t = TP_t / float(TP_t + FN_t)
        TNR_t = TN_t / float(FP_t + TN_t)

        # recall is important
        weight_value = 1.5*TPR_t + TNR_t
        if weight_value > maximum and TP_t > 0 and TN_t > 0:
            maximum = weight_value
            best_threshold = t
    return best_threshold


def find_threshold_f1(Y_true, Y_pred_prob):
    thresholds = np.arange(0.01, 1.0, 0.01)
    best_threshold = 0.5
    maximum = 0
    for t in thresholds:
        y = np.copy(Y_pred_prob)
        y[Y_pred_prob > t] = 1
        y[Y_pred_prob <= t] = 0
        current_f1 = metrics.f1_score(Y_true, y, average='weighted')
        if current_f1 > maximum:
            maximum = current_f1
            best_threshold = t
    return best_threshold

def find_threshold_auc(Y_true, Y_pred_prob):
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



def predicted_prob_histogram(y_pred_prob):
    plt.hist(y_pred_prob, bins=10)
    plt.xlabel("Predicted probability")
    plt.ylabel("Frequency")
    plt.show()


def  kfold_validation(clf, X, Y_true, sampler, splits_count=10):
    k_fold = StratifiedKFold(n_splits=splits_count)
    auc_scores = []
    f1_scores = []
    for train, test in k_fold.split(X, Y_true):
        describe_dataset(X[train], Y_true[train])

        # Data sampling
        #X_train, Y_train= sampler.fit_sample(X[train], Y_true[train])
        X_train, Y_train = X[train], Y_true[train]

        describe_dataset(X_train, Y_train)
        clf.fit(X_train, Y_train)
        predictions = clf.predict_proba(X[test])[:, 1]
        threshold = find_threshold_auc(Y_true[test], predictions)
        predictions[predictions > threshold] = 1
        predictions[predictions <= threshold] = 0
        print metrics.precision_recall_fscore_support(Y_true[test], predictions)
        auc_scores.append(metrics.roc_auc_score(Y_true[test], predictions, average="weighted"))
        f1_scores.append(metrics.f1_score(Y_true[test], predictions, average='weighted'))
    auc_scores = np.array(auc_scores)
    f1_scores = np.array(f1_scores)
    print("%d-fold AUC: %0.2f (+/- %0.2f)" % (splits_count, auc_scores.mean(), auc_scores.std()))
    print("%d-fold F1: %0.2f (+/- %0.2f)" % (splits_count, f1_scores.mean(), f1_scores.std()))


def save_as_file(clf, save_filename):
        joblib.dump(clf, save_filename)


def load_from_file(save_filename):
        return joblib.load(save_filename)


def train_model(clf, X_train, Y_train, X_test, Y_test):
    clf.fit(X_train, Y_train)
    #calibrated_clf = CalibratedClassifierCV(clf, method='sigmoid', cv=4)
    #calibrated_clf.fit(X_train, Y_train)
    predictions = clf.predict_proba(X_test)[:, 1]
    predicted_prob_histogram(predictions)
    roc_curve(Y_test, predictions)
    return predictions


def evaluate_predictions(predictions, Y_test, threshold):
    print '--------------------Threshold:', threshold
    y = np.copy(predictions)
    y[predictions > threshold] = 1
    y[predictions <= threshold] = 0
    print 'AUC: ', metrics.roc_auc_score(Y_test, y, average="weighted")
    print metrics.confusion_matrix(Y_test, y, labels=[1, 0])
    print 'Precision: ', metrics.precision_score(Y_test, y, average="weighted", pos_label=1, labels=[0, 1])
    print 'Recall: ',metrics.recall_score(Y_test, y, average="weighted", pos_label=1, labels=[0, 1])


def validation_curves(clf, X, Y):
    train_scores, test_scores = validation_curve(clf, X, Y, "Classifier__n_estimators",
                                                 np.arange(4, 30, 4), cv=10, scoring=metrics.make_scorer(metrics.roc_auc_score))
    print 'Train scores: ', np.mean(train_scores, axis=1), np.std(train_scores, axis=1)
    print 'Validation scores: ', np.mean(test_scores, axis=1), np.std(test_scores, axis=1)





if __name__ == '__main__':
    #n_iter is 1 in partial fit
    #classifier = SGDClassifier(alpha=0.1, loss='log', penalty='l2', n_jobs=-1,
    #                        shuffle=True, n_iter=10, #average=True,
    #                        verbose=0, class_weight="balanced", random_state=42)
    classifier = RandomForestClassifier(n_estimators=100, max_depth=6, class_weight="balanced", n_jobs=-1,
                                        random_state=42, criterion="entropy")
    #classifier = svm.SVC(class_weight="balanced", kernel="linear", probability=True, random_state=42)
    #classifier = svm.LinearSVC(class_weight="balanced")    # no predict_proba method

    # Load training data
    X, Y = get_training_data(filename)
    X = np.array(X)
    Y = np.array(Y)

    # Build pipeline for processing
    scaler = preprocessing.RobustScaler()
    pipelined_clf = Pipeline([('Scaling', scaler), ('Classifier', classifier)])


    # Feature selection
    select_features(X, Y)
    describe_dataset(X, Y)
    sampler = RandomUnderSampler(random_state=42)
    #X, Y = sampler.fit_sample(X, Y)
    #describe_dataset(X, Y)

    # Divide into training and test set
    X_train, X_test, Y_train, Y_test = train_test_split(X, Y, train_size=0.50, stratify=Y)
    #describe_dataset(X_test, Y_test)
    #X_train, Y_train= sampler.fit_sample(X_train, Y_train)


    #X_sampled, Y_sampled = sampler.fit_sample(X, Y)
    #describe_dataset(X, Y)

    pipelined_clf.named_steps['Classifier'] = grid_searching(RandomForestClassifier(class_weight="balanced",
                                                                                    n_jobs=-1, random_state=42,), X, Y, cv=10)

    # K-fold validation
    kfold_validation(pipelined_clf, X, Y, sampler, splits_count=10)


    predictions = train_model(pipelined_clf, X_train, Y_train, X_test, Y_test)

    evaluate_predictions(predictions, Y_test, 0.5)
    evaluate_predictions(predictions, Y_test, find_optimal_threshold(Y_test, predictions))
    evaluate_predictions(predictions, Y_test, find_threshold_f1(Y_test, predictions))
    evaluate_predictions(predictions, Y_test, find_threshold_auc(Y_test, predictions))

    #validation_curves(pipelined_clf, X, Y)

    #print 'Features importance: ', classifier.coef_
    print 'Features importance: ', pipelined_clf.named_steps['Classifier'].feature_importances_
    print pipelined_clf.get_params()


