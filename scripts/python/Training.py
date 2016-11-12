from Ensemble import Ensemble

exp_model_f = 'recommendation/expertise-classifier.pkl'
exp_baseline_model_f = 'recommendation/expertise-baseline-classifier.pkl'
will_model_f = 'recommendation/willingness-classifier.pkl'
will_baseline_model_f = 'recommendation/willingness-baseline-classifier.pkl'


if __name__ == '__main__':
    # Train full ensemble
    ensemble = Ensemble(exp_model_f, will_model_f, baseline=False)
    ensemble.fit()

    # Train baseline ensemble.
    ensemble_baseline = Ensemble(exp_baseline_model_f, will_baseline_model_f, baseline=True)
    ensemble_baseline.fit()