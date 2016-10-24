import psycopg2 as pg
import json

connection = pg.connect(database="askalot_edx_development", user="postgres", port=5432,
                        host="localhost", password="")
yeild_cursor = connection.cursor()
cursor = connection.cursor()

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
    targetable_id = get_targetable_id(property)
    cursor.execute("UPDATE user_profiles SET text_value=%s "
                          "WHERE user_id = %s AND targetable_id = %s", (value, str(user_id), targetable_id))


def get_user_profile(user_id, property):
    targetable_id = get_targetable_id(property)
    cursor.execute("SELECT * FROM user_profiles WHERE user_id = %s AND targetable_id= %s", (str(user_id), targetable_id))
    row = cursor.fetchone()
    return DbObject(cursor, row) if row else None

def get_question_profile(question_id, property):
    targetable_id = get_targetable_id(property)
    cursor.execute("SELECT * FROM question_profiles WHERE question_id = %s AND property = %s", (str(question_id), property))
    # TODO add targetable id to not compare strings


def get_all_user_profiles(property):
    yeild_cursor.execute("SELECT * FROM user_profiles WHERE targetable_id= %s", str(get_targetable_id(property)))
    for user_profile in yeild_cursor:
        yield DbObject(yeild_cursor, user_profile)


def get_answer(answer_id):
    cursor.execute("SELECT * FROM answers WHERE id = " + str(answer_id))
    row = cursor.fetchone()
    return DbObject(cursor, row) if row else None


def close_connection():
    connection.commit()
    connection.close()


def get_targetable_id(property):
    '''
    Property name to targetable_id mapping table.
    :param property:
    :return:
    '''
    if property == 'BoW':
        return 2
    elif property == 'LDA':
        return 3
    elif property == 'recommendation':
        return 4


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
