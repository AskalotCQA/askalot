import DataManager

def recommended_questions_count(user):
    # Delete all recommendations older than X days

    # Return number of recommendations
    #return len(DataManager.get_user_profile(user.id, 'recommendation'))
    return 0

def user_expertise(user):
    return user.votes_count + user.answers_count + user.comments_count

def asker_expertise(question):
    return user_expertise(DataManager.get_author(question.author_id))


def optimization_value(user, question):
    return recommended_questions_count(user) + abs(asker_expertise(question) - user_expertise(user))