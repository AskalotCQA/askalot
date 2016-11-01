import sys
import DataManager
from ExpertiseClassifier import BinaryClassifier
import numpy as np
from sklearn.ensemble import RandomForestClassifier
import Utils
import SimilarityQU


def get_features(users_ids, question, category):
    # shape = [n_samples, n_features]
    week_category_id = DataManager.get_category(category.parent_id).parent_id
    topic_category_id = category.parent_id
    week_category_leaves = DataManager.category_leaves(week_category_id)
    topic_category_leaves = DataManager.category_leaves(topic_category_id)
    week_category_leaves_c = len(week_category_leaves)
    topic_category_leaves_c = len(topic_category_leaves)
    week_questions_c = sum([category.questions_count for category in week_category_leaves])
    topic_questions_c =  sum([category.questions_count for category in topic_category_leaves])

    asker_profile = DataManager.get_user_profile(question.author_id, category.id)
    asker_profile = user_profile_to_hash(asker_profile)
    asker_total_knowledge = asker_profile.get('AnswersCount', 0) + asker_profile.get('QuestionVotesCount', 0) + asker_profile.get('AnswersVotesCount', 0)
    asker_week_knowledge = asker_profile.get('AnswersCountCategory'+str(week_category_id), 0) + asker_profile.get('VotesCountCategory'+str(week_category_id), 0)
    asker_topic_knowledge =  asker_profile.get('AnswersCountCategory'+str(topic_category_id), 0) + asker_profile.get('VotesCountCategory'+str(topic_category_id), 0)

    willingness = []
    expertise = []
    for user_id in users_ids:
        print 'User id: ', user_id
        user_profile_properties = DataManager.get_user_profile(user_id, category.id)
        profile_dict = user_profile_to_hash(user_profile_properties)
        will_features = [None] * 18
        exp_features = [None] * 10

        will_features[0] = profile_dict.get('AnswersCount', 0)
        will_features[1] = profile_dict.get('CommentsCount', 0)
        will_features[2] = profile_dict.get('RecentAnswersCount', 0)
        will_features[3] = profile_dict.get('QuestionVotesCount', 0) + profile_dict.get('AnswersVotesCount', 0)
        will_features[4] = int((question.created_at - profile_dict['LastAnswerTime'])
                                .total_seconds()) if profile_dict.get('LastAnswerTime', None) else 0
        will_features[5] = profile_dict.get('SeenUnits'+str(week_category_id), 0) / week_category_leaves_c
        will_features[6] = profile_dict.get('SeenUnits'+str(topic_category_id), 0) / topic_category_leaves_c
        fresh_unit_key = 'FreshUnitTime'+str(category.id)
        will_features[7] = int((question.created_at - profile_dict[fresh_unit_key])
                                .total_seconds()) if profile_dict.get(fresh_unit_key, None) else 0
        will_features[8] = profile_dict.get('BetweenCqaActivity', 0)
        will_features[9] = profile_dict.get('AvgCqaActivity', 0)
        will_features[10] = profile_dict.get('BetweenCourseActivity', 0)
        will_features[11] = profile_dict.get('AvgCourseActivity', 0)
        will_features[12] = profile_dict.get('CategorySeenQuestions'+str(week_category_id), 0) / week_questions_c
        will_features[13] = profile_dict.get('CategorySeenQuestions'+str(topic_category_id), 0) / topic_questions_c
        will_features[14] = profile_dict.get('QuestionCount', 0)
        will_features[15] = int((question.created_at - profile_dict['RegistrationDate'])
                                .total_seconds()) if profile_dict.get('RegistrationDate', None) else 0
        will_features[16] = profile_dict.get('RecommendedCount', 0)
        will_features[17] = profile_dict.get('RecCTR', 0)

        exp_features[0] = SimilarityQU.compute_similarity(profile_dict.get('BoW', None), question)
        exp_features[1] = profile_dict.get('AnswersCountCategory'+str(week_category_id), 0)
        exp_features[2] = profile_dict.get('AnswersCountCategory'+str(topic_category_id), 0)
        exp_features[3] = profile_dict.get('VotesCountCategory'+str(topic_category_id), 0)
        exp_features[4] = profile_dict.get('VotesCountCategory'+str(week_category_id), 0)
        exp_features[5] = (profile_dict.get('AnswersCountCategory'+str(topic_category_id), 0)
                           + profile_dict.get('VotesCountCategory'+str(topic_category_id), 0)) - asker_topic_knowledge
        exp_features[6] = (profile_dict.get('AnswersCountCategory'+str(week_category_id), 0)
                           + profile_dict.get('VotesCountCategory'+str(week_category_id), 0)) - asker_week_knowledge
        exp_features[7] = (profile_dict.get('AnswersCount', 0) + profile_dict.get('QuestionVotesCount', 0)
                           + profile_dict.get('AnswersVotesCount', 0)) - asker_total_knowledge
        exp_features[8] = profile_dict.get('SeenUnits'+str(week_category_id), 0) / week_category_leaves_c
        exp_features[9] = profile_dict.get('SeenUnits'+str(topic_category_id), 0) / topic_category_leaves_c

        willingness.append(will_features)
        expertise.append(exp_features)


    print willingness
    print expertise
    return willingness, expertise



def user_profile_to_hash(user_profile):
    '''
    Create dictionary {key: value}. Key is property or in case of Category it is property+category_id.
    Value is either value or updated_at column.
    '''
    hash = dict()
    for profile in user_profile:
        if profile.targetable_type != 'Shared::Category':
            value = profile.value if profile.value else profile.text_value
            if value is None:
                value = profile.updated_at
            hash[profile.property] = value
        else:
            hash[profile.property+str(profile.targetable_id)] = profile.value if profile.value else profile.updated_at
    return hash


    #return dict((profile.property, profile.value if profile.value else profile.updated_at)
    #            if profile.targetable_type != 'Shared::Category' else
    #            (profile.property+str(profile.targetable_id), profile.value if profile.value else profile.updated_at)
    #            for profile in user_profile)



if __name__ == '__main__':
    # Retrieve new question and it's category.
    question_id = sys.argv[1]
    question = DataManager.get_question(question_id)
    category = DataManager.get_category(question.category_id)
    #self_and_ancestor_categories = DataManager.category_self_and_ancestors(question.category_id)

    # Filter users
    users_ids = DataManager.get_users_with_views()


    # Create willingness matrix
    willingness, expertise = get_features([2, 3], question, category)
    willingness = np.array(willingness)
    expertise = np.array(expertise)

    base_clf = RandomForestClassifier(class_weight="balanced", n_jobs=-1)
    expertise_data_filename = '/media/dmacjam/Data disc1/git/Askalot-dev/askalot/tmp/expertise-train.dat'
    expertise_model_filename = '/media/dmacjam/Data disc1/git/Askalot-dev/askalot/tmp/expertise-classifier.pkl'

    exp_clf = BinaryClassifier(base_clf, expertise_data_filename, expertise_model_filename, threshold=0.5)
    exp_clf.fit()
    exp_clf.load_from_file()
    #print exp_clf.predict(np.array([0.1684832, 2, 0, 0, 0, 0, 0, 0, 0.6666666666666666, 1.0]).reshape(1, -1))
    print exp_clf.predict(expertise)


    will_data_filename = '/media/dmacjam/Data disc1/git/Askalot-dev/askalot/tmp/willingness-train.dat'
    will_model_filename = '/media/dmacjam/Data disc1/git/Askalot-dev/askalot/tmp/willingness-classifier.pkl'
    will_clf = BinaryClassifier(base_clf, will_data_filename, will_model_filename, threshold=0.5)
    will_clf.fit()
    will_clf.load_from_file()
    #print will_clf.predict(np.array([0, 0, 0, 0, 0, 0.0, 0.0, 0, 1.5, 2, 43896.213028907776, 0, 0]).reshape(1, -1))
    print will_clf.predict(willingness)
