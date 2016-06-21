require_relative '../../../shared/app/services/shared/events/dispatcher'

namespace :sample_data do
  task all: :environment do
    Rake::Task['sample_data:users'].invoke
    Rake::Task['sample_data:followings'].invoke
    Rake::Task['sample_data:categories'].invoke
    Rake::Task['sample_data:assignments'].invoke
    Rake::Task['sample_data:groups'].invoke
    Rake::Task['sample_data:documents'].invoke
    Rake::Task['sample_data:watchings'].invoke
    Rake::Task['sample_data:questions'].invoke
    Rake::Task['sample_data:answers'].invoke
    Rake::Task['sample_data:comments'].invoke
    Rake::Task['sample_data:favors'].invoke
    Rake::Task['sample_data:votes'].invoke
    Rake::Task['sample_data:labellings'].invoke
    Rake::Task['sample_data:views'].invoke
    Rake::Task['sample_data:news'].invoke
    Rake::Task['fixtures:tag_statistics'].invoke
    Rake::Task['reputation:recalculate'].invoke
  end

  desc 'Fills database with sample users'
  task users: :environment do
    users = [{
      login: "ivan",
      email: "ivan.srba@stuba.sk",
      password: 'password',
      password_confirmation: 'password',
      nick: "Ivan",
      name: "Ivan Srba",
      first: "Ivan",
      last: "Srba",
      about: "I am interested in web applications based on knowledge sharing in communities of people that include also Community Question Answering (CQA) systems. Askalot is the first CQA systems that have been specifically designed to support the question answering process in educational and organization environment.",
      facebook: "https://www.facebook.com/ivan.srba",
      gravatar_email: "ivan.srba@stuba.sk",
      github: "https://github.com/isrba",
      role: "administrator",
      time: 65
    }, {
      login: "askalotteacher",
      email: "askalotteacher@gmail.com",
      password: 'password',
      password_confirmation: 'password',
      nick: "Andrew",
      name: "Andrew Baker",
      first: "Andrew",
      last: "Baker",
      about: "A teacher of courses Principles of software engineering and Database systems.",
      facebook: nil,
      gravatar_email: nil,
      github: nil,
      role: "teacher",
      time: 64
    }, {
      login: "askalotstudent",
      email: "askalotstudent@gmail.com",
      password: 'password',
      password_confirmation: 'password',
      nick: "John",
      name: "John Shepherd",
      first: "John",
      last: "Shepherd",
      about: nil,
      facebook: nil,
      gravatar_email: nil,
      github: nil,
      role: "student",
      time: 54
    }, {
      login: "ruby",
      email: "RubyStorey@Askalot.com",
      password: 'password',
      password_confirmation: 'password',
      nick: "Ruby",
      name: "Ruby Storey",
      first: "Ruby",
      last: "Storey",
      about: nil,
      facebook: nil,
      linkedin: nil,
      github: nil,
      role: "student",
      time: 55
    }, {
      login: "lauren",
      email: "LaurenWard@Askalot.com",
      password: 'password',
      password_confirmation: 'password',
      nick: "Lauren",
      name: "Lauren Ward",
      first: "Lauren",
      last: "Ward",
      about: nil,
      facebook: nil,
      gravatar_email: nil,
      github: nil,
      role: "student",
      time: 52
    }, {
      login: "sophia",
      email: "SophiaDaniels@Askalot.com",
      password: 'password',
      password_confirmation: 'password',
      nick: "Sophia",
      name: "Sophia Daniels",
      first: "Sophia",
      last: "Daniels",
      about: nil,
      facebook: nil,
      gravatar_email: nil,
      github: nil,
      role: "student",
      time: 51
    }, {
      login: "tom",
      email: "ThomasHardy@Askalot.com",
      password: 'password',
      password_confirmation: 'password',
      nick: "Tom",
      name: "Thomas Hardy",
      first: "Thomas",
      last: "Hardy",
      about: nil,
      facebook: nil,
      gravatar_email: nil,
      github: nil,
      role: "student",
      time: 49
    }, {
      login: "samantha",
      email: "SamanthaCarey@Askalot.com",
      password: 'password',
      password_confirmation: 'password',
      nick: "Samantha",
      name: "Samantha Carey",
      first: "Samantha",
      last: "Carey",
      about: nil,
      facebook: nil,
      gravatar_email: nil,
      github: nil,
      role: "student",
      time: 59
    }, {
      login: "archie",
      email: "ArchieScott@Askalot.com",
      password: 'password',
      password_confirmation: 'password',
      nick: "Archie",
      name: "Archie Scott",
      first: "Archie",
      last: "Scott",
      about: nil,
      facebook: nil,
      gravatar_email: nil,
      github: nil,
      role: "student",
      time: 54
    }, {
      login: "adam",
      email: "AdamHunt@Askalot.com",
      password: 'password',
      password_confirmation: 'password',
      nick: "Adam",
      name: "Adam Hunt",
      first: "Adam",
      last: "Hunt",
      about: nil,
      facebook: nil,
      gravatar_email: nil,
      github: nil,
      role: "student",
      time: 57
    }, {
      login: "amelia",
      email: "AmeliaBlake@Askalot.com",
      password: 'password',
      password_confirmation: 'password',
      nick: "Amelia",
      name: "Amelia Blake",
      first: "Amelia",
      last: "Blake",
      about: nil,
      facebook: nil,
      gravatar_email: nil,
      github: nil,
      role: "student",
      time: 58
    }, {
      login: "ben",
      email: "BenDawson@Askalot.com",
      password: 'password',
      password_confirmation: 'password',
      nick: "Ben",
      name: "Ben Dawson",
      first: "Ben",
      last: "Dawson",
      about: nil,
      facebook: nil,
      gravatar_email: nil,
      github: nil,
      role: "student",
      time: 56
    }, {
      login: "ella",
      email: "EllaTaylor@Askalot.com",
      password: 'password',
      password_confirmation: 'password',
      nick: "Ella",
      name: "Ella Taylor",
      first: "Ella",
      last: "Taylor",
      about: nil,
      facebook: nil,
      gravatar_email: nil,
      github: nil,
      role: "student",
      time: 55
    }]

    users.each do |input|
      Timecop.freeze(Time.now - input[:time].days) do
        Shared::User.create_without_confirmation!(
          login: input[:login],
          email: input[:email],
          password: input[:password],
          password_confirmation: input[:password_confirmation],
          nick: input[:nick],
          name: input[:name],
          first: input[:first],
          last: input[:last],
          about: input[:about],
          facebook: input[:facebook],
          gravatar_email: input[:gravatar_email],
          github: input[:github],
          role: input[:role]
      )
      end
    end
  end

  desc 'Fills database with sample followings'
  task followings: :environment do
    followings = [
      { follower: "Ivan", followee: "Andrew", time: 25 },
      { follower: "John", followee: "Andrew", time: 25 },
      { follower: "Adam", followee: "Andrew", time: 25 },
      { follower: "Ella", followee: "Andrew", time: 25 },
      { follower: "Samantha", followee: "Andrew", time: 25 },
      { follower: "Sophia", followee: "Samantha", time: 25 },
      { follower: "Ben", followee: "Archie", time: 25 },
      { follower: "John", followee: "Archie", time: 25 },
      { follower: "Lauren", followee: "John", time: 25 },
      { follower: "Amelia", followee: "John", time: 25 },
      { follower: "Amelia", followee: "Archie", time: 25 },
    ]

    followings.each do |input|
      Timecop.freeze(Time.now - input[:time].days) do
        Shared::User.find_by(nick: input[:follower]).toggle_following_by! Shared::User.find_by(nick: input[:followee])
      end
    end
  end

  desc 'Fills database with sample categories'
  task categories: :environment do
    categories = [
        # Academic years
        { name: "2014-15", tags: ["2014-15"], uuid: "2014-15", parent_name: "", shared: true, askable: false, time: 385 },
        { name: "2015-16", tags: ["2015-16"], uuid: "2015-16", parent_name: "", shared: true, askable: true, time: 65 },

        # Grades
        { name: "Bachelor study: 1st grade", tags: ["bachelor-1st"], uuid: "bachelor-1st", parent_name: "2014-15", shared: true, askable: false, time: 385 },
        { name: "Bachelor study: 1st grade", tags: ["bachelor-1st"], uuid: "bachelor-1st", parent_name: "2015-16", shared: true, askable: true, time: 65 },
        { name: "Bachelor study: 2nd grade", tags: ["bachelor-2nd"], uuid: "bachelor-2ndt", parent_name: "2014-15", shared: true, askable: false, time: 385 },
        { name: "Bachelor study: 2nd grade", tags: ["bachelor-2nd"], uuid: "bachelor-2ndt", parent_name: "2015-16", shared: true, askable: true, time: 65 },

        # Subjects
        { name: "Object-oriented programming", tags: ["oop"], uuid: "oop", parent_name: "2014-15 - Bachelor study: 1st grade", shared: true, askable: false, time: 385 },
        { name: "Object-oriented programming", tags: ["oop"], uuid: "oop", parent_name: "2015-16 - Bachelor study: 1st grade", shared: true, askable: true, time: 65 },
        { name: "Principles of software engineering", tags: ["pse"], uuid: "pse", parent_name: "2014-15 - Bachelor study: 2nd grade", shared: true, askable: false, time: 385 },
        { name: "Principles of software engineering", tags: ["pse"], uuid: "pse", parent_name: "2015-16 - Bachelor study: 2nd grade", shared: true, askable: false, time: 65 },
        { name: "Database systems", tags: ["dbs"], uuid: "dbs", parent_name: "2014-15 - Bachelor study: 2nd grade", shared: true, askable: false, time: 385 },
        { name: "Database systems", tags: ["dbs"], uuid: "dbs", parent_name: "2015-16 - Bachelor study: 2nd grade", shared: true, askable: true, time: 65 },

        # Subject parts
        { name: "Lectures", tags: ["lectures"], uuid: "oop-lectures", parent_name: "2014-15 - Bachelor study: 1st grade - Object-oriented programming", shared: true, askable: false, time: 385 },
        { name: "Lectures", tags: ["lectures"], uuid: "oop-lectures", parent_name: "2015-16 - Bachelor study: 1st grade - Object-oriented programming", shared: true, askable: true, time: 65 },
        { name: "Exercises", tags: ["exercises"], uuid: "oop-exercise", parent_name: "2014-15 - Bachelor study: 1st grade - Object-oriented programming", shared: true, askable: false, time: 385 },
        { name: "Exercises", tags: ["exercises"], uuid: "oop-exercise", parent_name: "2015-16 - Bachelor study: 1st grade - Object-oriented programming", shared: true, askable: true, time: 65 },

        { name: "Lectures", tags: ["lectures"], uuid: "pse-project", parent_name: "2014-15 - Bachelor study: 2nd grade - Principles of software engineering", shared: true, askable: false, time: 385 },
        { name: "Lectures", tags: ["lectures"], uuid: "pse-project", parent_name: "2015-16 - Bachelor study: 2nd grade - Principles of software engineering", shared: true, askable: true, time: 65 },
        { name: "Project", tags: ["project"], uuid: "pse-exercise", parent_name: "2014-15 - Bachelor study: 2nd grade - Principles of software engineering", shared: true, askable: false, time: 385 },
        { name: "Project", tags: ["project"], uuid: "pse-exercise", parent_name: "2015-16 - Bachelor study: 2nd grade - Principles of software engineering", shared: true, askable: true, time: 65 },

        { name: "Lectures", tags: ["lectures"], uuid: "dbs-lectures", parent_name: "2014-15 - Bachelor study: 2nd grade - Database systems", shared: true, askable: false, time: 385 },
        { name: "Lectures", tags: ["lectures"], uuid: "dbs-lectures", parent_name: "2015-16 - Bachelor study: 2nd grade - Database systems", shared: true, askable: true, time: 65 },
    ]

    categories.each do |input|
      Timecop.freeze(Time.now - input[:time].days) do
        parent = Shared::Category.find_by(full_tree_name: input[:parent_name])
        parent_id = parent ? parent.id : nil

        next unless Shared::Category.find_by(parent_id: parent_id, name: input[:name]).nil?

        category = Shared::Category.create!(
            name: input[:name],
            tags: input[:tags],
            uuid: input[:uuid],
            parent_id: parent_id,
            shared: input[:shared],
            askable: input[:askable]
        )
        category.refresh_full_tree_name
        category.save
      end
    end
  end

  desc 'Fills database with sample assignments'
  task assignments: :environment do
    assignments = [
        { user: "Andrew", category: "2015-16 - Bachelor study: 1st grade - Object-oriented programming", role: "teacher", time: 25 },
        { user: "Andrew", category: "2015-16 - Bachelor study: 2nd grade - Principles of software engineering", role: "teacher", time: 25 },
    ]

    assignments.each do |input|
      Timecop.freeze(Time.now - input[:time].days) do
        category = Shared::Category.find_by(full_tree_name: input[:category])
        user = Shared::User.find_by(nick: input[:user])
        role = Shared::Role.find_by(name: input[:role])

        Shared::Assignment.create(role: role, user: user, category: category, admin_visible: true, parent: nil)
      end
    end
  end

  desc 'Fills database with sample groups'
  task groups: :environment do
    groups = [
      { title: "Database systems - Exam", description: "The purpose of this group is to collect important materials useful for preparation for a final exam at a course Database Systems. [An example of a public group which contains documents and related questions used during a preparation for final exams]", visibility: "public", user: "Andrew", time: 45 },
    ]

    groups.each do |input|
      Timecop.freeze(Time.now - input[:time].days) do
        user = Shared::User.find_by(nick: input[:user])

        group = University::Group.create!(
          creator_id: user.id,
          title: input[:title],
          description: input[:description],
          visibility: input[:visibility]
        )
      end
    end
  end

  desc 'Fills database with sample documents'
  task documents: :environment do
    documents = [
      { group: "Database systems - Exam", title: "Topic 1: Data definition language (DDL)", text: "The first part of the exam will practice DDL statements:\n\n* CREATE\n* DROP\n* ALTER", user: "Andrew", time: 45 },
      { group: "Database systems - Exam", title: "Topic 2: Data manipulation language (DML)", text: "The second part of the exam will practice DML statements:\n\n* SELECT\n* INSERT\n* UPDATE\n* DELETE", user: "Andrew", time: 45 },
    ]

    documents.each do |input|
      Timecop.freeze(Time.now - input[:time].days) do
        user = Shared::User.find_by(nick: input[:user])
        group = University::Group.find_by(title: input[:group])

        document = University::Document.create!(
          author_id: user.id,
          group_id: group.id,
          title: input[:title],
          text: input[:text]
        )
      end
    end
  end

  desc 'Fills database with sample watchings'
  task watchings: :environment do
    watchings = [
      { category: "2014-15 - Bachelor study: 2nd grade - Principles of software engineering - Lectures", user: "Ivan", time: 54 },
      { category: "2014-15 - Bachelor study: 2nd grade - Principles of software engineering - Project", user: "Ivan", time: 54 },
      { category: "2015-16 - Bachelor study: 2nd grade - Principles of software engineering - Lectures", user: "Ivan", time: 54 },
      { category: "2015-16 - Bachelor study: 2nd grade - Principles of software engineering - Project", user: "Ivan", time: 54 },
      { category: "2014-15 - Bachelor study: 2nd grade - Principles of software engineering - Lectures", user: "Ben", time: 32 },
      { category: "2014-15 - Bachelor study: 2nd grade - Principles of software engineering - Project", user: "Ben", time: 32 },
      { category: "2015-16 - Bachelor study: 2nd grade - Principles of software engineering - Lectures", user: "John", time: 25 },
      { category: "2015-16 - Bachelor study: 2nd grade - Principles of software engineering - Project", user: "John", time: 25 },
      { category: "2015-16 - Bachelor study: 2nd grade - Principles of software engineering - Lectures", user: "Samantha", time: 15 },
      { category: "2015-16 - Bachelor study: 2nd grade - Principles of software engineering - Project", user: "Samantha", time: 15 },
      { category: "2014-15 - Bachelor study: 2nd grade - Database systems - Lectures", user: "Andrew", time: 44 },
      { category: "2015-16 - Bachelor study: 2nd grade - Database systems - Lectures", user: "Andrew", time: 44 },
      { category: "2015-16 - Bachelor study: 2nd grade - Database systems - Lectures", user: "Tom", time: 12 },
      { category: "2014-15 - Bachelor study: 2nd grade - Database systems - Lectures", user: "Lauren", time: 11 },
      { category: "2015-16 - Bachelor study: 2nd grade - Database systems - Lectures", user: "Lauren", time: 11 },
      { category: "2015-16 - Bachelor study: 2nd grade - Database systems - Lectures", user: "Ella", time: 10 },
      { category: "2014-15 - Bachelor study: 1st grade - Object-oriented programming - Lectures", user: "Ella", time: 60 },
      { category: "2014-15 - Bachelor study: 1st grade - Object-oriented programming - Exercises", user: "Ella", time: 60 },
      { category: "2015-16 - Bachelor study: 1st grade - Object-oriented programming - Lectures", user: "Ella", time: 60 },
      { category: "2015-16 - Bachelor study: 1st grade - Object-oriented programming - Exercises", user: "Ella", time: 60 },
      { category: "2014-15 - Bachelor study: 1st grade - Object-oriented programming - Lectures", user: "Archie", time: 10 },
      { category: "2014-15 - Bachelor study: 1st grade - Object-oriented programming - Exercises", user: "Archie", time: 10 },
      { category: "2015-16 - Bachelor study: 1st grade - Object-oriented programming - Lectures", user: "Archie", time: 60 },
      { category: "2015-16 - Bachelor study: 1st grade - Object-oriented programming - Exercises", user: "Archie", time: 60 },
      { category: "2015-16 - Bachelor study: 1st grade - Object-oriented programming - Lectures", user: "Adam", time: 60 },
      { category: "2015-16 - Bachelor study: 1st grade - Object-oriented programming - Exercises", user: "Adam", time: 60 },
      { category: "2015-16 - Bachelor study: 1st grade - Object-oriented programming - Lectures", user: "Ben", time: 60 },
      { category: "2015-16 - Bachelor study: 1st grade - Object-oriented programming - Exercises", user: "Ben", time: 60 },
    ]

    watchings.each do |input|
      Timecop.freeze(Time.now - input[:time].days) do
        Shared::Category.find_by(full_tree_name: input[:category]).toggle_watching_by! Shared::User.find_by(nick: input[:user])
      end
    end
  end

  desc 'Fills database with sample questions'
  task questions: :environment do
    questions = [{
      category: "2015-16 - Bachelor study: 2nd grade - Principles of software engineering - Lectures",
      user: "Ben",
      time: 53,
      title: "Model vs Diagram",
      text: "I am not sure whether I understand correctly the difference between a model and a diagram. I think that there is a mistake in the sample project at the page 12 and 13, isn't it? I suppose that “Use case diagram” should be used instead of “Use case model”. Thank you.\n\n*[An example of question, which includes an error report related to study materials]*",
      tag_list: ["model", "diagram"],
      mention: nil,
      editor: nil,
      edited_at: nil
    }, {
      category: "2015-16 - Bachelor study: 2nd grade - Principles of software engineering - Project",
      user: "Archie",
      time: 49,
      title: "Minimal requirements on project",
      text: "There is information in the minimal requirements on the project that it is necessary to model at least 2 use cases with alternative flows, at least two include relations and 1 extend relation. Are these requirements valid for each single use case diagram or for overall project?\n\n*[An example of question which tackles with organizational matters]*",
      tag_list: ["minimal-requirements", "project"],
      mention: nil,
      editor: "Archie",
      edited_at: 48
    }, {
      category: "2015-16 - Bachelor study: 2nd grade - Principles of software engineering - Lectures",
      user: "Sophia",
      time: 45,
      title: "What's is the difference between include and extend?",
      text: "What is the difference between include and extend relation in a use case diagram?\n\n*[An example of general question]*",
      tag_list: ["include", "extend"],
      mention: nil,
      editor: nil,
      edited_at: nil
    }, {
      category: "2014-15 - Bachelor study: 2nd grade - Database systems - Lectures",
      user: "Tom",
      time: 31,
      title: "Function COUNT()",
      text: "In which cases it is usefull to use a function `COUNT()` with another params as '*'?\n\n*[An example of a question for which student provided an answer with supplementary materials]*",
      tag_list: ["count"],
      mention: nil,
      editor: nil,
      edited_at: nil
    }, {
      category: "2015-16 - Bachelor study: 2nd grade - Database systems - Lectures",
      user: "Sophia",
      time: 26,
      title: "PostgreSQL version",
      text: "Which version of PostgreSQL database is most suitable for purpose of the project?\n\n*[An example of a question which aims to obtain a recommendation]*",
      tag_list: ["postgresql", "project", "database"],
      mention: nil,
      editor: nil,
      edited_at: nil
    }, {
      category: "2015-16 - Bachelor study: 1st grade - Object-oriented programming - Lectures",
      user: "Ivan",
      time: 18,
      title: "Singleton in Java",
      text: "How can I implement a singleton in Java language? I need to secure that I will work with only one instance of a object from various threads. In addition, I need to serialize this object. What is the best possibility how to achieve it?\n\n*[An example of a general question for which another student provided a well-described explanation also with references for supplementary materials]*",
      tag_list: ["singleton", "java", "serialization"],
      mention: nil,
      editor: nil,
      edited_at: nil
    }, {
      category: "2014-15 - Bachelor study: 2nd grade - Principles of software engineering - Lectures",
      user: "Adam",
      time: 7,
      title: "What an abreviation UML stands for?",
      text: "What an abreviation UML stands for?\n\n*[An example of inappropriate question that can be solved simply by standard search engines]*",
      tag_list: ["uml"],
      mention: nil,
      editor: nil,
      edited_at: nil
    }, {
      category: "2015-16 - Bachelor study: 1st grade - Object-oriented programming - Exercises",
      user: "Ruby",
      time: 10,
      title: "Anonymous class in always true condition",
      text: "There is an anonymous class creation in else branch of condition which will always return true.\n\n```java\nif (true) {...} else return new.....;\n```\n\nHow many instanced of this class can be created?\n\nHow can I implement a singleton in Java language? I need to secure that I will work with only one instance of a object from various threads. In addition, I need to serialize this object. What is the best possibility how to achieve it?\n\n*[An example of a general question for which another student provided a well-described explanation also with references for supplementary materials]*",
      tag_list: ["anonymous-class", "java", "condition"],
      mention: nil,
      editor: "Ruby",
      edited_at: 10
    }, {
      document: "Topic 1: Data definition language (DDL)",
      user: "Adam",
      time: 41,
      title: "How to create autoincrement primary key?",
      text: "How it is possible to create a table with autoincrement primary key in MySQL database?\n\n*[An example of question that is related to the particular document and was asked inside a topic-focused group]*",
      tag_list: ["mysql", "create", "autoincrement"],
      mention: nil,
      editor: nil,
      edited_at: nil
    }]

    questions.each do |input|
      Timecop.freeze(Time.now - input[:time].days) do
        category = Shared::Category.find_by(full_tree_name: input[:category]) unless input[:category].nil?
        document = University::Document.find_by(title: input[:document]) unless input[:document].nil?
        user = Shared::User.find_by(nick: input[:user])
        editor = Shared::User.find_by(nick: input[:editor]) unless input[:editor].nil?
        mention = Shared::User.find_by(nick: input[:editor]) unless input[:mention].nil?

        question = Shared::Question.create!(
          author_id: user.id,
          category_id: category.nil? ? nil : category.id,
          document_id: document.nil? ? nil : document.id,
          title: input[:title],
          text: input[:text],
          tag_list: input[:tag_list],
          editor_id: editor.nil? ? nil : editor.id,
          edited_at: input[:edited_at].nil? ? nil : Time.now - input[:edited_at].days,
        )

        Shared::Events::Dispatcher.dispatch :mention, user, question, for: mention unless mention.nil?
        Shared::Events::Dispatcher.dispatch :create, user, question, for: question.parent_watchers + question.tags.map(&:watchers).flatten, anonymous: question.anonymous
        Shared::Watching.deleted_or_new(watcher: user, watchable: question).mark_as_undeleted!
      end
    end

    Shared::Category.roots.each do |root|
      root.reload_categories_questions
    end
  end

  desc 'Fills database with sample answers'
  task answers: :environment do
    answers = [{
      question: "Model vs Diagram",
      user: "Andrew",
      time: 52,
      text: "Yes, it is a mistake and the correct caption of the image should contain a diagram as the image contains “only” the graphical representation of particular model artefacts. In comparison with a diagram, a model contains also a description of these artefacts, the relationships among them together with the reasons that lead to the decisions captured by the model.\n\nThank you very much for notification.",
      mention: nil,
      editor: nil,
      edited_at: nil
    }, {
      question: "Minimal requirements on project",
      user: "Andrew",
      time: 49,
      text: "They are applied on the whole project. On the other side they represent really minimal requirements and thus it is advised to regularly consult your project with your supervisor.",
      mention: nil,
      editor: nil,
      edited_at: nil
    }, {
      question: "What's is the difference between include and extend?",
      user: "Ruby",
      time: 43,
      text: "**Extend** is used when a particular use case conditionally involve another user case in its flow.\n\n**Include** is used when a use case always involve some steps that are duplicated in several other user cases. I means that it is possible to use include to get rod off duplicated steps in several use cases.",
      mention: nil,
      editor: nil,
      edited_at: nil
    }, {
      question: "Function COUNT()",
      user: "Adam",
      time: 31,
      text: "I think that there is no difference at all.",
      mention: nil,
      editor: nil,
      edited_at: nil
    }, {
      question: "Function COUNT()",
      user: "John",
      time: 30,
      text: "I have found a very good explanation here: http://www.databasedev.co.uk/sql-count.html \n\nIf you will use `COUNT(*)` above a database table, you will get a number of all records. On the other side, if you will use `COUNT(column_name)`, you will get a number of records where column is not null.",
      mention: nil,
      editor: nil,
      edited_at: nil
    }, {
      question: "PostgreSQL version",
      user: "Ivan",
      time: 26,
      text: "I think that the newest one is the best one. For example, the version 9.2 brought a support for  JSON data type which can be useful if you want to store data with dynamic structure (e.g. system logs). Just for information, askalot.fiit.stuba.sk uses PostreSQL 9.3.",
      mention: nil,
      editor: nil,
      edited_at: nil
    }, {
      question: "Singleton in Java",
      user: "Archie",
      time: 14,
      text: "The most simplest way how to implement singleton in Java is:\n\n```java\npublic enum Singleton {\n  INSTANCE;\n  ...\n}\n```\nThis solution has several advantages: it is the shortest possible code; access to singleton object is 100% thread-safe (guaranteed by JVM); and serialization is provided out-of-box.\n\nYou can find more information about this topic in Effective Java Second Edition, Item 3",
      mention: nil,
      editor: nil,
      edited_at: nil
    }, {
      question: "Anonymous class in always true condition",
      user: "Ben",
      time: 5,
      text: "If you will write `if (true) { ... }` Java compiler will completely ignore if statement. Of course block `{…}` will still remain and the rest (after else) will be ommited from bytecode.\n\nI found also some supplementary information in these sources: [will-the-compiler-optimize-this-out](https://askalot.fiit.stuba.sk/questions/153#7122723/will-the-compiler-optimize-this-out) and [java-if-false-compile](https://askalot.fiit.stuba.sk/questions/153#6239991/java-iffalse-compile).",
      mention: nil,
      editor: nil,
      edited_at: nil
    }, {
      question: "How to create autoincrement primary key?",
      user: "Tom",
      time: 42,
      text: "It is simple, you can proceed from this example code:\n\n```mysql\nCREATE TABLE test (\n     id INT NOT NULL AUTO_INCREMENT,\n     name CHAR(30) NOT NULL,\n     PRIMARY KEY (id)\n );\n```\n\nauto_increment means that the corresponding primary key will automatically increase.",
      mention: nil,
      editor: nil,
      edited_at: nil
    }]

    answers.each do |input|
      Timecop.freeze(Time.now - input[:time].days) do
        question = Shared::Question.find_by(title: input[:question])
        user = Shared::User.find_by(nick: input[:user])
        editor = Shared::User.find_by(nick: input[:editor]) unless input[:editor].nil?
        mention = Shared::User.find_by(nick: input[:editor]) unless input[:mention].nil?

        answer = Shared::Answer.create!(
          author_id: user.id,
          question_id: question.id,
          text: input[:text],
          editor_id: editor.nil? ? nil : editor.id,
          edited_at: input[:edited_at].nil? ? nil : Time.now - input[:edited_at].days,
        )

        Shared::Events::Dispatcher.dispatch :mention, user, answer, for: mention unless mention.nil?
        Shared::Events::Dispatcher.dispatch :create, user, answer, for: question.watchers
        Shared::Watching.deleted_or_new(watcher: user, watchable: question).mark_as_undeleted!
      end
    end
  end

  desc 'Fills database with sample comments'
  task comments: :environment do
    comments = [{
      question: "Model vs Diagram",
      answerer: "Andrew",
      user: "Ben",
      time: 53,
      commentable_type: "Answer",
      text: "@Andrew, you are welcome.",
      mention: "Andrew",
      editor: nil,
      edited_at: nil
    }, {
      question: "Minimal requirements on project",
      answerer: nil,
      user: "Ruby",
      time: 49,
      commentable_type: "Question",
      text: "The same question here :+1:",
      mention: nil,
      editor: nil,
      edited_at: nil
    }, {
      question: "What's is the difference between include and extend?",
      answerer: "Ruby",
      user: "Andrew",
      time: 41,
      commentable_type: "Answer",
      text: "In addition, it is important to notice that the arrow for extend/include has an opposite direction. It is a very common mistake in student projects.",
      mention: nil,
      editor: nil,
      edited_at: nil
    }, {
      question: "Function COUNT()",
      answerer: "John",
      user: "Tom",
      time: 35,
      commentable_type: "Answer",
      text: "@John, thank you very much, it so simple now.",
      mention: "John",
      editor: nil,
      edited_at: nil
    }, {
      question: "Anonymous class in always true condition",
      answerer: "Ben",
      user: "Ruby",
      time: 2,
      commentable_type: "Answer",
      text: "@Ben, thank you very much for your perfect answer.",
      mention: "Ben",
      editor: "Ruby",
      edited_at: 2
    }]

    comments.each do |input|
      Timecop.freeze(Time.now - input[:time].days) do
        user = Shared::User.find_by(nick: input[:user])
        answerer = Shared::User.find_by(nick: input[:answerer]) unless input[:answerer].nil?
        editor = Shared::User.find_by(nick: input[:editor]) unless input[:editor].nil?
        mention = Shared::User.find_by(nick: input[:editor]) unless input[:mention].nil?

        question = Shared::Question.find_by(title: input[:question])

        commentable = Shared::Question.find_by(title: input[:question]) if input[:commentable_type] == "Question"
        commentable = Shared::Answer.find_by(question_id: question.id, author_id: answerer.id) if input[:commentable_type] == "Answer"

        comment = Shared::Comment.create!(
          author_id: user.id,
          commentable_id: commentable.id,
          commentable_type: "Shared::" + input[:commentable_type],
          text: input[:text],
          editor_id: editor.nil? ? nil : editor.id,
          edited_at: input[:edited_at].nil? ? nil : Time.now - input[:edited_at].days,
        )

        Shared::Events::Dispatcher.dispatch :mention, user, comment, for: mention unless mention.nil?
        Shared::Events::Dispatcher.dispatch :create, user, comment, for: question.watchers
        Shared::Watching.deleted_or_new(watcher: user, watchable: question).mark_as_undeleted!
      end
    end
  end

  desc 'Fills database with sample favors'
  task favors: :environment do
    favors = [
      { question: "Model vs Diagram", user: "Andrew", time: 53 },
      { question: "Model vs Diagram", user: "Ben", time: 54 },
      { question: "Model vs Diagram", user: "John", time: 25 },
      { question: "What's is the difference between include and extend?", user: "Ivan", time: 6 },
      { question: "Function COUNT()", user: "Sophia", time: 28 },
      { question: "Function COUNT()", user: "Ivan", time: 26 },
      { question: "Singleton in Java", user: "Tom", time: 14 },
      { question: "Singleton in Java", user: "Ella", time: 2 },
      { question: "Anonymous class in always true condition", user: "Archie", time: 3 },
    ]

    favors.each do |input|
      Timecop.freeze(Time.now - input[:time].days) do
        question = Shared::Question.find_by(title: input[:question])
        user = Shared::User.find_by(nick: input[:user])

        favorite = question.toggle_favoring_by! user
        Shared::Events::Dispatcher.dispatch :create, user, favorite, for: question.watchers
      end
    end
  end

  desc 'Fills database with sample votes'
  task votes: :environment do
    votes = [
      { question: "Model vs Diagram", user: "Amelia", positive: true, time: 54 },
      { question: "Model vs Diagram", user: "Ella", positive: true, time: 52 },
      { question: "Minimal requirements on project", user: "Amelia", positive: true, time: 48 },
      { question: "Minimal requirements on project", user: "Samantha", positive: true, time: 47 },
      { question: "Function COUNT()", user: "Tom", positive: true, time: 31 },
      { question: "Function COUNT()", user: "John", positive: true, time: 30 },
      { question: "Function COUNT()", user: "Sophia", positive: true, time: 28 },
      { question: "Function COUNT()", user: "Ivan", positive: true, time: 26 },
      { question: "Function COUNT()", user: "Amelia", positive: true, time: 26 },
      { question: "Singleton in Java", user: "Ivan", positive: true, time: 5 },
      { question: "What an abreviation UML stands for?", user: "Tom", positive: false, time: 7 },
      { question: "What an abreviation UML stands for?", user: "Amelia", positive: false, time: 6 },
      { question: "What an abreviation UML stands for?", user: "Ben", positive: false, time: 3 },
    ]

    votes.each do |input|
      Timecop.freeze(Time.now - input[:time].days) do
        question = Shared::Question.find_by(title: input[:question])
        user = Shared::User.find_by(nick: input[:user])

        vote = question.toggle_vote_by! user, input[:positive]
        Shared::Events::Dispatcher.dispatch :create, user, vote, for: question.watchers
      end
    end

    votes = [
      { question: "Model vs Diagram", answerer: "Andrew", user: "Amelia", time: 51, positive: true },
      { question: "What's is the difference between include and extend?", answerer: "Ruby", user: "Samantha", time: 42, positive: true },
      { question: "What's is the difference between include and extend?", answerer: "Ruby", user: "Lauren", time: 39, positive: true },
      { question: "What's is the difference between include and extend?", answerer: "Ruby", user: "Ella", time: 37, positive: true },
      { question: "Function COUNT()", answerer: "Adam", user: "Ivan", positive: false, time: 31 },
      { question: "Function COUNT()", answerer: "Adam", user: "Archie", positive: false, time: 30 },
      { question: "Function COUNT()", answerer: "Adam", user: "Andrew", positive: false, time: 25 },
      { question: "Function COUNT()", answerer: "John", user: "Andrew", positive: true, time: 15 },
      { question: "Function COUNT()", answerer: "John", user: "Ella", positive: true, time: 14 },
      { question: "Singleton in Java", answerer: "Archie", user: "Amelia", positive: true, time: 3 },
      { question: "Anonymous class in always true condition", answerer: "Ben", user: "Ivan", positive: true, time: 2 },
      { question: "Anonymous class in always true condition", answerer: "Ben", user: "Ella", positive: true, time: 1 },
    ]

    votes.each do |input|
      Timecop.freeze(Time.now - input[:time].days) do
        question = Shared::Question.find_by(title: input[:question])
        answerer = Shared::User.find_by(nick: input[:answerer])
        answer = Shared::Answer.find_by(question_id: question.id, author_id: answerer.id)
        user = Shared::User.find_by(nick: input[:user])

        vote = answer.toggle_vote_by! user, input[:positive]
        Shared::Events::Dispatcher.dispatch :create, user, vote, for: question.watchers
      end
    end
  end

  desc 'Fills database with sample labellings'
  task labellings: :environment do
    labellings = [
      { question: "Minimal requirements on project", answerer: "Andrew", user: "Archie", time: 51 },
      { question: "What's is the difference between include and extend?", answerer: "Ruby", user: "Sophia", time: 41 },
      { question: "Function COUNT()", answerer: "John", user: "Tom", time: 29 },
      { question: "PostgreSQL version", answerer: "Ivan", user: "Sophia", time: 12 },
      { question: "Anonymous class in always true condition", answerer: "Ben", user: "Ruby", time: 2 },
    ]

    labellings.each do |input|
      Timecop.freeze(Time.now - input[:time].days) do
        question = Shared::Question.find_by(title: input[:question])
        answerer = Shared::User.find_by(nick: input[:answerer])
        answer = Shared::Answer.find_by(question_id: question.id, author_id: answerer.id)
        user = Shared::User.find_by(nick: input[:user])

        labeling = answer.toggle_labeling_by! user, :best
        Shared::Events::Dispatcher.dispatch :create, user, labeling, for: question.watchers
      end
    end
  end

  desc 'Fills database with sample views'
  task views: :environment do
    views = [
      { question: "Model vs Diagram", user: "Andrew", time: 53 },
      { question: "Model vs Diagram", user: "Ben", time: 54 },
      { question: "Model vs Diagram", user: "Amelia", time: 51 },
      { question: "Model vs Diagram", user: "John", time: 50 },
      { question: "Model vs Diagram", user: "Ella", time: 49 },
      { question: "Model vs Diagram", user: "Adam", time: 5 },
      { question: "Model vs Diagram", user: "Ivan", time: 48 },
      { question: "Minimal requirements on project", user: "John", time: 48 },
      { question: "Minimal requirements on project", user: "Ella", time: 47 },
      { question: "Minimal requirements on project", user: "Adam", time: 46 },
      { question: "Minimal requirements on project", user: "Ivan", time: 46 },
      { question: "What's is the difference between include and extend?", user: "Ruby", time: 46 },
      { question: "What's is the difference between include and extend?", user: "Adam", time: 46 },
      { question: "What's is the difference between include and extend?", user: "Andrew", time: 46 },
      { question: "What's is the difference between include and extend?", user: "Samantha", time: 45 },
      { question: "What's is the difference between include and extend?", user: "Ivan", time: 45 },
      { question: "What's is the difference between include and extend?", user: "Ella", time: 37 },
      { question: "What's is the difference between include and extend?", user: "Ella", time: 37 },
      { question: "Function COUNT()", user: "Tom", time: 31 },
      { question: "Function COUNT()", user: "John", time: 30 },
      { question: "Function COUNT()", user: "Sophia", time: 28 },
      { question: "Function COUNT()", user: "Ivan", time: 26 },
      { question: "Function COUNT()", user: "Amelia", time: 26 },
      { question: "Function COUNT()", user: "Ella", time: 26 },
      { question: "Function COUNT()", user: "Samantha", time: 24 },
      { question: "Function COUNT()", user: "Ruby", time: 20 },
      { question: "Function COUNT()", user: "Andrew", time: 4 },
      { question: "PostgreSQL version", user: "Sophia", time: 26 },
      { question: "PostgreSQL version", user: "Ivan", time: 26 },
      { question: "PostgreSQL version", user: "Andrew", time: 25 },
      { question: "PostgreSQL version", user: "Ben", time: 22 },
      { question: "PostgreSQL version", user: "Amelia", time: 21 },
      { question: "PostgreSQL version", user: "John", time: 45 },
      { question: "PostgreSQL version", user: "Ella", time: 1 },
      { question: "Singleton in Java", user: "Ivan", time: 18 },
      { question: "Singleton in Java", user: "Archie", time: 14 },
      { question: "Singleton in Java", user: "Amelia", time: 3 },
      { question: "Singleton in Java", user: "John", time: 10 },
      { question: "Singleton in Java", user: "Ella", time: 9 },
      { question: "Singleton in Java", user: "Adam", time: 5 },
      { question: "Singleton in Java", user: "Adam", time: 7 },
      { question: "Singleton in Java", user: "Tom", time: 7 },
      { question: "Singleton in Java", user: "Amelia", time: 6 },
      { question: "Singleton in Java", user: "Ben", time: 4 },
      { question: "Anonymous class in always true condition", user: "Ruby", time: 5 },
      { question: "Anonymous class in always true condition", user: "Ben", time: 4 },
      { question: "Anonymous class in always true condition", user: "Archie", time: 3 },
      { question: "Anonymous class in always true condition", user: "Ivan", time: 2 },
      { question: "Anonymous class in always true condition", user: "Ella", time: 1 },
      { question: "How to create autoincrement primary key?", user: "Adam", time: 45 },
      { question: "How to create autoincrement primary key?", user: "Tom", time: 45 },
      { question: "How to create autoincrement primary key?", user: "Amelia", time: 41 },
      { question: "How to create autoincrement primary key?", user: "John", time: 5 },
      { question: "How to create autoincrement primary key?", user: "Ella", time: 4 },
    ]

    views.each do |input|
      Timecop.freeze(Time.now - input[:time].days) do
        question = Shared::Question.find_by(title: input[:question])
        user = Shared::User.find_by(nick: input[:user])

        view = question.views.create! viewer: user
        Shared::Events::Dispatcher.dispatch :create, user, view, for: question.watchers
      end
    end
  end

  desc 'Fills database with sample news'
  task news: :environment do
    all_news = [
        { title: "Try university version of CQA system Askalot!", description: "#### Demo teacher account\nCredentials: askalotteacher / password\n\n#### Demo student account\nCredentials: askalotstudent / password", time: 0 },
     ]

    all_news.each do |input|
      Timecop.freeze(Time.now - input[:time].days) do
        news = Shared::News.create!(
            title: input[:title],
            description: input[:description],
            show: true,
        )
      end
    end
  end
end
