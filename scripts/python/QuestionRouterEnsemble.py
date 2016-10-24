from ExpertiseClassifier import BinaryClassifier
import numpy as np
from sklearn.ensemble import RandomForestClassifier


if __name__ == '__main__':
    base_clf = RandomForestClassifier(class_weight="balanced", n_jobs=-1)
    expertise_data_filename = '/media/dmacjam/Data disc1/git/Askalot-dev/askalot/tmp/expertise-train.dat'
    expertise_model_filename = '/media/dmacjam/Data disc1/git/Askalot-dev/askalot/tmp/expertise-classifier.pkl'

    exp_clf = BinaryClassifier(base_clf, expertise_data_filename, expertise_model_filename, threshold=0.5)
    exp_clf.fit({
            "clf__n_estimators": [20, 40, 100, 150],
            "clf__criterion": ["gini", "entropy"]
    }, cv=4)
    exp_clf.load_from_file()
    print exp_clf.predict(np.array([0.1684832, 2, 0, 0, 0, 0, 0, 0, 0.6666666666666666, 1.0]).reshape(1, -1))


    will_data_filename = '/media/dmacjam/Data disc1/git/Askalot-dev/askalot/tmp/willingness-train.dat'
    will_model_filename = '/media/dmacjam/Data disc1/git/Askalot-dev/askalot/tmp/willingness-classifier.pkl'
    will_clf = BinaryClassifier(base_clf, will_data_filename, will_model_filename, threshold=0.5)
    will_clf.fit({
            "clf__n_estimators": [20, 100, 150],
            "clf__criterion": ["gini", "entropy"]
    }, cv=10)
    will_clf.load_from_file()
    print will_clf.predict(np.array([0, 0, 0, 0, 0, 0.0, 0.0, 0, 1.5, 2, 43896.213028907776, 0, 0]).reshape(1, -1))
