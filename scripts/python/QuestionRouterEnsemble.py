import sys
import DataManager
from ExpertiseClassifier import ExpertiseClassifier
from WillingnessClassifier import WillignessClassifier
import numpy as np
from sklearn.ensemble import RandomForestClassifier
import Utils
import SimilarityQU
from Classifier import Classifier
from Ensemble import Ensemble
import Evaluation
from TextualDictionary import TextualDictionary


def get_features(users_ids, question, category, textual_dictionary):
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
        #print 'User id: ', user_id
        user_profile_properties = DataManager.get_user_profile(user_id, category.id)
        profile_dict = user_profile_to_hash(user_profile_properties)
        will_features = [None] * 16
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
        will_features[8] = profile_dict.get('AvgCqaActivity', 0)
        will_features[9] = profile_dict.get('AvgCourseActivity', 0)
        will_features[10] = profile_dict.get('CategorySeenQuestions'+str(week_category_id), 0) / week_questions_c
        will_features[11] = profile_dict.get('CategorySeenQuestions'+str(topic_category_id), 0) / topic_questions_c
        will_features[12] = profile_dict.get('QuestionCount', 0)
        will_features[13] = int((question.created_at - profile_dict['RegistrationDate'])
                                .total_seconds()) if profile_dict.get('RegistrationDate', None) else 0
        will_features[14] = profile_dict.get('RecommendedCount', 0)
        will_features[15] = profile_dict.get('RecCTR', 0)

        exp_features[0] = SimilarityQU.compute_similarity(profile_dict.get('BoW', None), question, textual_dictionary)
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


    #print willingness
    #print expertise
    return willingness, expertise



def user_profile_to_hash(user_profile):
    '''
    Create dictionary {key: value}. Key is property or in case of Category it is property+category_id.
    Value is either value or updated_at column.
    '''
    hash = dict()
    for profile in user_profile:
        if profile.targetable_type != 'Shared::Category':
            value = profile.value if profile.value is not None else profile.text_value
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



MAX_ROUTED_QUESTIONS = 3
ROUTE_TO_MAX = 5

if __name__ == '__main__':
    textual_dictionary = TextualDictionary()
    if not textual_dictionary.load_vocabulary_from_file():
        sys.exit(1)

    # Retrieve new question and it's category.
    question_id = sys.argv[1]
    question = DataManager.get_question(question_id)
    category = DataManager.get_category(question.category_id)
    #self_and_ancestor_categories = DataManager.category_self_and_ancestors(question.category_id)

    # Filter users
    users_ids = DataManager.get_users_with_views()


    # Create willingness matrix
    willingness, expertise = get_features(users_ids, question, category, textual_dictionary)
    willingness = np.array(willingness)
    expertise = np.array(expertise)

    ensemble = Ensemble()
    ensemble.fit()
    rec_users, exp_prob, will_prob = ensemble.predict(expertise, willingness)

    #print 'Recommendation'
    route_to_counter = 0
    for i in rec_users:
        print users_ids[i], '\t\texp:\t', exp_prob[i], '\t\twill:\t', will_prob[i]
        if DataManager.user_recommendation_count(users_ids[i]) <= MAX_ROUTED_QUESTIONS:
            DataManager.insert_recommendation(question_id, users_ids[i])
            print 'Routed to:\t', users_ids[i]
            route_to_counter += 1
        if route_to_counter == ROUTE_TO_MAX:
            break

    users_ids = np.array(users_ids)
    users_ids = np.take(users_ids, rec_users)

    if len(sys.argv) == 3:
        #print sys.argv[2]
        true_user_id = int(sys.argv[2])
        print 'User id:\t', true_user_id
        print 'Rank:\t', Evaluation.true_rank(users_ids, true_user_id)
        print 'Sucess@10:\t', Evaluation.success(users_ids, true_user_id)

    DataManager.close_connection()


