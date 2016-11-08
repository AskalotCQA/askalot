from Ensemble import Ensemble

exp_model_f = '/media/dmacjam/Data disc1/git/Askalot-dev/askalot/tmp/expertise-classifier.pkl'
exp_baseline_model_f = '/media/dmacjam/Data disc1/git/Askalot-dev/askalot/tmp/expertise-baseline-classifier.pkl'
will_model_f = '/media/dmacjam/Data disc1/git/Askalot-dev/askalot/tmp/willingness-classifier.pkl'
will_baseline_model_f = '/media/dmacjam/Data disc1/git/Askalot-dev/askalot/tmp/willingness-baseline-classifier.pkl'


if __name__ == '__main__':
    ensemble = Ensemble(exp_model_f, will_model_f, baseline=False)
    ensemble.fit()

    ensemble_baseline = Ensemble(exp_baseline_model_f, will_baseline_model_f, baseline=True)
    ensemble_baseline.fit()