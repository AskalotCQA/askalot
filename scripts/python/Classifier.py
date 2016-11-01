import numpy as np
from sklearn.linear_model import SGDClassifier
from sklearn import svm
from sklearn.ensemble import RandomForestClassifier
from sklearn import metrics
from sklearn import preprocessing, feature_selection
from sklearn.model_selection import StratifiedKFold, cross_val_score, train_test_split
from scipy import stats
from collections import Counter
from imblearn.over_sampling import SMOTE
import matplotlib.pyplot as plt
from scipy.stats import pearsonr
from sklearn.model_selection import GridSearchCV
from sklearn.pipeline import Pipeline
from sklearn.externals import joblib


filename = '/media/dmacjam/Data disc1/git/Askalot-dev/askalot/tmp/expertise-train.dat'
#filename = '/media/dmacjam/Data disc1/git/Askalot-dev/askalot/tmp/willingness-train.dat'

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
        "n_estimators": [5, 10, 20, 40],
        "criterion": ["gini", "entropy"],
        "max_depth": [2, 3, 4, 5]
    }
    grid_search = GridSearchCV(clf, param_grid=param_grid, cv=cv, scoring=metrics.make_scorer(metrics.roc_auc_score))
    grid_search.fit(X, Y)
    report(grid_search.cv_results_)
    return grid_search.best_estimator_


def select_features(X, Y):
    count_features = X.shape[1]
    correlations = np.corrcoef(X, rowvar=0)
    plt.pcolor(correlations)
    plt.colorbar()
    plt.yticks(np.arange(0, count_features, 1))
    plt.xticks(np.arange(0, count_features, 1))
    plt.gca().invert_yaxis()
    plt.show()

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


def find_optimal_threshold(Y_true, Y_pred_prob, recall_threshold=0.85):
    thresholds = np.linspace(1,0,101)
    for i in range(101):
        t = thresholds[i]
        # Classifier / label agree and disagreements for current threshold.
        TP_t = np.logical_and( Y_pred_prob >  t, Y_true==1 ).sum()
        TN_t = np.logical_and( Y_pred_prob <= t, Y_true==0 ).sum()
        FP_t = np.logical_and( Y_pred_prob >  t, Y_true==0 ).sum()
        FN_t = np.logical_and( Y_pred_prob <= t, Y_true==1 ).sum()

        # Compute true  positive rate for current threshold.
        TPR_t = TP_t / float(TP_t + FN_t)
        if TPR_t > recall_threshold:
            return t
    return 0.5


def predicted_prob_histogram(y_pred_prob):
    plt.hist(y_pred_prob, bins=10)
    plt.xlabel("Predicted probability")
    plt.ylabel("Frequency")
    plt.show()


def  kfold_validation(clf, X, Y_true, sampler, splits_count=10, threshold=0.50):
    k_fold = StratifiedKFold(n_splits=splits_count)
    auc_scores = []
    f1_scores = []
    for train, test in k_fold.split(X, Y_true):
        describe_dataset(X[train], Y_true[train])
        X_train, Y_train= sampler.fit_sample(X[train], Y_true[train])
        describe_dataset(X_train, Y_train)
        clf.fit(X_train, Y_train)
        predictions = clf.predict_proba(X[test])[:, 1]
        predictions[predictions > threshold] = 1
        predictions[predictions <= threshold] = 0
        print metrics.precision_recall_fscore_support(Y_true[test], predictions)
        auc_scores.append(metrics.roc_auc_score(Y_true[test], predictions))
        f1_scores.append(metrics.f1_score(Y_true[test], predictions, average='binary'))
    auc_scores = np.array(auc_scores)
    f1_scores = np.array(f1_scores)
    print("%d-fold AUC: %0.2f (+/- %0.2f)" % (splits_count, auc_scores.mean(), auc_scores.std() * 2))
    print("%d-fold F1: %0.2f (+/- %0.2f)" % (splits_count, f1_scores.mean(), f1_scores.std() * 2))


def save_as_file(clf, save_filename):
        joblib.dump(clf, save_filename)

def load_from_file(save_filename):
        return joblib.load(save_filename)


if __name__ == '__main__':
    #n_iter is 1 in partial fit
    #classifier = SGDClassifier(alpha=.0001, loss='log', penalty='l2', n_jobs=-1,
    #                        shuffle=True, n_iter=1000, #average=True,
    #                        verbose=0, class_weight="balanced")
    classifier = RandomForestClassifier(n_estimators=7, max_depth=5, class_weight="balanced", n_jobs=-1,
                                        random_state=42, criterion="gini")
    #classifier = svm.SVC(class_weight="balanced", kernel="rbf", probability=True)
    #classifier = svm.LinearSVC(class_weight="balanced")    # no predict_proba method


    X, Y = get_training_data(filename)
    print stats.describe(X)
    #q25, median,q75 =  np.percentile(X, [25, 50, 75], axis=0)
    #print q25
    #print median
    #print q75
    # TODO features checking in pandas

    scaler = preprocessing.RobustScaler()
    pipelined_clf = Pipeline([('Scaling', scaler), ('Classifier', classifier)])
    X = np.array(X)
    Y = np.array(Y)

    select_features(X, Y)
    #describe_dataset(X, Y)
    sampler = SMOTE(random_state=42)
    #X, Y = sme.fit_sample(X, Y)
    #describe_dataset(X, Y)

    X_train, X_test, Y_train, Y_test = train_test_split(X, Y, train_size=0.70)
    X_train, Y_train= sampler.fit_sample(X_train, Y_train)

    #grid_searching(RandomForestClassifier(class_weight="balanced", n_jobs=-1), X, Y)

    kfold_validation(pipelined_clf, X, Y, sampler, splits_count=10, threshold=0.50)

    pipelined_clf.fit(X_train, Y_train)
    predictions = pipelined_clf.predict_proba(X_test)[:, 1]
    predicted_prob_histogram(predictions)
    roc_curve(Y_test, predictions)
    print 'AUC: ', metrics.roc_auc_score(Y_test, predictions)

    threshold = find_optimal_threshold(Y_test, predictions, recall_threshold=0.80)
    print 'Threshold:', threshold
    predictions[predictions > threshold] = 1
    predictions[predictions <= threshold] = 0

    print 'AUC: ', metrics.roc_auc_score(Y_test, predictions)
    print metrics.confusion_matrix(Y_test, predictions, labels=[1,0])
    print 'Precision: ', metrics.precision_score(Y_test, predictions)
    print 'Recall: ',metrics.recall_score(Y_test, predictions)
    #print 'Features importance: ', classifier.coef_
    print 'Features importance: ', pipelined_clf.named_steps['Classifier'].feature_importances_
    print pipelined_clf.get_params()

