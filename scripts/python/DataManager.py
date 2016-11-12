import psycopg2 as pg
import json
import os

connection = pg.connect(database=os.environ.get('REC_PYTHON_DB_NAME','askalot_edx_development'),
                        user=os.environ.get('REC_PYTHON_DB_USER','postgres'),
                        port=5432, host="localhost", password=os.environ.get('REC_PYTHON_DB_PASSWORD',''))
yeild_cursor = connection.cursor()
cursor = connection.cursor()

QR_FULL_NAME = 'Question routing full'
QR_BASELINE_NAME = 'Question routing baseline'
QR_CONTROL_NAME = 'Control group for question routing'

def get_questions_for_course(course_id):
    '''
    Get questions from DB.
    :return:
    '''
    yeild_cursor.execute("WITH question_categories AS( "
                    "SELECT array_agg(id)::int[] AS a FROM categories as c, "
                   "(SELECT lft, rgt FROM categories WHERE id = " + str(course_id) +") as a  "
                    "WHERE c.lft >= a.lft AND c.rgt <= a.rgt) "
                   "SELECT * FROM questions q WHERE q.category_id = ANY(SELECT unnest(a) FROM question_categories);")
    for question in yeild_cursor:
        yield DbObject(yeild_cursor, question)

def get_answers_for_course(course_id):
    '''
    Get answers from DB.
    :param course_id:
    :return:
    '''
    yeild_cursor.execute(
        "WITH answer_ids AS (WITH question_categories AS("
	        "SELECT array_agg(id)::int[] AS a FROM categories as c,"
		        "(SELECT lft, rgt FROM categories WHERE id = "+ str(course_id)+") as a "
	        "WHERE c.lft >= a.lft AND c.rgt <= a.rgt"
            ") "
            "SELECT array_agg(id)::int[] as b FROM questions q WHERE q.category_id = ANY(SELECT unnest(a) FROM question_categories)"
        ") "
        "SELECT * FROM answers ans WHERE ans.id = ANY(SELECT unnest(b) FROM answer_ids)")
    for answer in yeild_cursor:
        yield DbObject(yeild_cursor, answer)


def get_author(author_id):
    cursor.execute("SELECT * FROM users u WHERE u.id = " + str(author_id))
    return DbObject(cursor, cursor.fetchone())


def get_question(question_id):
    cursor.execute("SELECT * FROM questions q WHERE q.id = " + str(question_id))
    return DbObject(cursor, cursor.fetchone())


def insert_question_profile(question, property, value, prob=100):
    cursor.execute("INSERT INTO question_profiles(question_id, property, text_value, probability, created_at, updated_at)"
                        "VALUES(%s, %s, %s, 100, now(), now());",
                   (str(question.id), property, value))


def insert_user_profile(user_id, property, value, prob=100):
    cursor.execute("INSERT INTO user_profiles(user_id, targetable_id, targetable_type, property, text_value, "
                          "probability, created_at, updated_at)"
                        "VALUES(%s, %s, %s, %s, %s, 100, now(), now());",
                   (str(user_id), 2, property, property, value))


def update_user_profile(user_id, property, value):
    cursor.execute("UPDATE user_profiles SET text_value=%s "
                          "WHERE user_id = %s AND property = %s", (value, str(user_id), property))


def get_user_profile_property(user_id, property):
    cursor.execute("SELECT * FROM user_profiles WHERE user_id = %s AND property = %s", (str(user_id), property))
    row = cursor.fetchone()
    return DbObject(cursor, row) if row else None


def get_question_profile(question_id, property):
    cursor.execute("SELECT * FROM question_profiles WHERE question_id = %s AND property = %s", (str(question_id), property))


def get_all_user_profiles_property(property):
    yeild_cursor.execute("SELECT * FROM user_profiles WHERE property = %s", (property))
    for user_profile in yeild_cursor:
        yield DbObject(yeild_cursor, user_profile)


def get_answer(answer_id):
    cursor.execute("SELECT * FROM answers WHERE id = " + str(answer_id))
    row = cursor.fetchone()
    return DbObject(cursor, row) if row else None


def get_user_profile(user_id, category_id):
    '''
    Get user profile properties. In case of categories, filter only properties which is for category and it's
    ancestors.
    :param user_id: specifies user's id to find
    :param category_id: id of category
    :return: User profile - general properties related to user and user properties related to specified categories.
    '''
    yeild_cursor.execute("SELECT * FROM user_profiles WHERE user_id = %s AND (targetable_type != 'Shared::Category' "
                         "OR (targetable_type = 'Shared::Category' AND targetable_id IN (SELECT id FROM categories as c, "
		                 "(SELECT lft, rgt FROM categories WHERE id = %s) as a "
	                     "WHERE c.lft <= a.lft AND c.rgt >= a.rgt)))", (user_id, category_id))
    users = [DbObject(yeild_cursor, profile) for profile in yeild_cursor]
    return users
    #for user_profile in yeild_cursor:
    #    yield DbObject(yeild_cursor, user_profile)


def get_users_with_views():
    cursor.execute("SELECT id FROM users WHERE views_count > 0")
    users = cursor.fetchall()
    users = [user[0] for user in users]
    return users


def get_users_full_group():
    cursor.execute( "SELECT u.id from users u JOIN ab_groupings a ON u.id = a.user_id WHERE u.views_count > 0 "
                    "AND a.ab_group_id = (SELECT id FROM ab_groups WHERE value = '"+QR_FULL_NAME+"')")
    users = cursor.fetchall()
    users = [user[0] for user in users]
    return users


def get_users_baseline_group():
    cursor.execute( "SELECT u.id from users u JOIN ab_groupings a ON u.id = a.user_id WHERE u.views_count > 0 "
                    "AND a.ab_group_id = (SELECT id FROM ab_groups WHERE value = '"+QR_BASELINE_NAME+"')")
    users = cursor.fetchall()
    users = [user[0] for user in users]
    return users


def get_category(id):
    cursor.execute("SELECT * FROM categories WHERE id = %s", (id, ))
    row = cursor.fetchone()
    return DbObject(cursor, row) if row else None


def category_leaves(category_id):
    cursor.execute( "SELECT * FROM categories as c,(SELECT lft, rgt FROM categories WHERE id = "+str(category_id)+") as a "
                    "WHERE (c.lft >= a.lft) AND (c.rgt < a.rgt) AND (c.rgt - c.lft = 1)")
    categories = cursor.fetchall()
    categories = [DbObject(cursor, category) for category in categories]
    return categories


def user_recommendation_count(user_id):
    cursor.execute("SELECT COUNT(*) FROM notifications WHERE recipient_id = " + str(user_id)
                   +" AND resource_type = 'Shared::Question' AND unread = TRUE AND action = 'recommendation'")
    return cursor.fetchone()[0]


def insert_recommendation(question_id, user_id):
    cursor.execute("INSERT INTO recommendations (question_id, user_id, created_at, updated_at)"
                        "VALUES(%s, %s, now(), now());",
                   (str(question_id), str(user_id)))


def commit_and_close_connection():
    connection.commit()
    connection.close()


def load_bow_json(json_string):
    '''
    Convert json bow to list of tuples.
    :param json_string:
    :return:
    '''
    return [tuple([int(key), value]) for key, value in json.loads(json_string).items()]


class DbObject(object):
    '''
    Create DbObject that set atrributes based on db columns in order to call like question.category_id
    '''
    def __init__(self, cursor, row):
        for (attr, val) in zip((d[0] for d in cursor.description), row):
            setattr(self, attr, val)
