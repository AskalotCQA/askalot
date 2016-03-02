require_relative '../../../shared/app/services/shared/events/dispatcher'

namespace :sample_data do
  task all: :environment do
    Rake::Task['sample_data:users'].invoke
    Rake::Task['sample_data:followings'].invoke
    Rake::Task['sample_data:categories'].invoke
    Rake::Task['sample_data:watchings'].invoke
    Rake::Task['sample_data:questions'].invoke
    Rake::Task['sample_data:answers'].invoke
    Rake::Task['sample_data:comments'].invoke
    Rake::Task['sample_data:favors'].invoke
    Rake::Task['sample_data:votes'].invoke
    Rake::Task['sample_data:labellings'].invoke
    Rake::Task['sample_data:views'].invoke
    Rake::Task['sample_data:user_context'].invoke
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
      login: "andrew",
      email: "AndrewBaker@Askalot.com",
      password: 'password',
      password_confirmation: 'password',
      nick: "Andrew",
      name: "Andrew Baker",
      first: "Andrew",
      last: "Baker",
      about: "A teacher of courses Introduction and Linear Regression.",
      facebook: nil,
      gravatar_email: nil,
      github: nil,
      role: "teacher",
      time: 64
    }, {
      login: "john",
      email: "JohnShepherd@Askalot.com",
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
      # Courses
      { name: "Machine Learning 2015", tags: ["ml-2015"], uuid: "Williams/202", lti_id: nil, parent_name: "", shared: true, askable: false, time: 385 },
      { name: "Demonstration of Advanced Features", tags: ["ml-2016"], uuid: "Williams/203", lti_id: nil, parent_name: "", shared: true, askable: true, time: 65 },

      # Sections
      { name: "Askalot Demo", tags: [], uuid: "a32093e0cdfa483e9c39feb852bac3cf", lti_id: nil, parent_name: "Machine Learning 2015", shared: true, askable: false, time: 385 },
      { name: "Askalot Demo", tags: [], uuid: "a32093e0cdfa483e9c39feb852bac3cf", lti_id: nil, parent_name: "Demonstration of Advanced Features", shared: true, askable: true, time: 65 },

      # Subsections
      { name: "Introduction", tags: ["intro"], uuid: "03bc97ee76734441899e6193ccfc756d", lti_id: nil, parent_name: "Machine Learning 2015 - Askalot Demo", shared: true, askable: false, time: 385 },
      { name: "Introduction", tags: ["intro"], uuid: "03bc97ee76734441899e6193ccfc756d", lti_id: nil, parent_name: "Demonstration of Advanced Features - Askalot Demo", shared: true, askable: true, time: 65 },
      { name: "Linear Regression", tags: ["regression"], uuid: "cb364967b7bc4befa6434aa5da6b477f", lti_id: nil, parent_name: "Machine Learning 2015 - Askalot Demo", shared: true, askable: false, time: 385 },
      { name: "Linear Regression", tags: ["regression"], uuid: "cb364967b7bc4befa6434aa5da6b477f", lti_id: nil, parent_name: "Demonstration of Advanced Features - Askalot Demo", shared: true, askable: true, time: 65 },
      { name: "Support Vector Machines", tags: ["svm"], uuid: "b5f80b813d10402da5dda0efd165afeb", lti_id: nil, parent_name: "Machine Learning 2015 - Askalot Demo", shared: true, askable: false, time: 385 },
      { name: "Support Vector Machines", tags: ["svm"], uuid: "b5f80b813d10402da5dda0efd165afeb", lti_id: nil, parent_name: "Demonstration of Advanced Features - Askalot Demo", shared: true, askable: true, time: 65 },
      { name: "Neural Networks", tags: ["neural", "networks"], uuid: "f1edaca786904e279c3d0ec4a9f1aa91", lti_id: nil, parent_name: "Demonstration of Advanced Features - Askalot Demo", shared: true, askable: true, time: 65 },

      # Units
      { name: "About Askalot", tags: [], uuid: "i4x:;_;_Williams;_203;_sequential;_03bc97ee76734441899e6193ccfc756d", lti_id: "i4x-Williams-202-lti-3f55254c7f434860a12e56bd821a1cca", parent_name: "Machine Learning 2015 - Askalot Demo - Introduction", shared: true, askable: false, time: 385 },
      { name: "About Askalot", tags: [], uuid: "i4x:;_;_Williams;_203;_sequential;_03bc97ee76734441899e6193ccfc756d", lti_id: "i4x-Williams-203-lti-3f55254c7f434860a12e56bd821a1cca", parent_name: "Demonstration of Advanced Features - Askalot Demo - Introduction", shared: true, askable: true, time: 65 },
      { name: "Definition of Linear Regression", tags: [], uuid: "i4x:;_;_Williams;_203;_sequential;_cb364967b7bc4befa6434aa5da6b477f", lti_id: "i4x-Williams-202-lti-1c0bccee67764f6c863b3f7303f8bd34", parent_name: "Machine Learning 2015 - Askalot Demo - Linear Regression", shared: true, askable: false, time: 385 },
      { name: "Definition of Linear Regression", tags: [], uuid: "i4x:;_;_Williams;_203;_sequential;_cb364967b7bc4befa6434aa5da6b477f", lti_id: "i4x-Williams-203-lti-1c0bccee67764f6c863b3f7303f8bd34", parent_name: "Demonstration of Advanced Features - Askalot Demo - Linear Regression", shared: true, askable: true, time: 65 },
      { name: "Definition of SVM", tags: [], uuid: "i4x:;_;_Williams;_203;_sequential;_b5f80b813d10402da5dda0efd165afeb", lti_id: "i4x-Williams-202-lti-461e3407422745f9a479740854dd9ccc", parent_name: "Machine Learning 2015 - Askalot Demo - Support Vector Machines", shared: true, askable: false ,time: 385 },
      { name: "Definition of SVM", tags: [], uuid: "i4x:;_;_Williams;_203;_sequential;_b5f80b813d10402da5dda0efd165afeb", lti_id: "i4x-Williams-203-lti-461e3407422745f9a479740854dd9ccc", parent_name: "Demonstration of Advanced Features - Askalot Demo - Support Vector Machines", shared: true, askable: true, time: 65 },
      { name: "Definition of Neural Networks", tags: [], uuid: "i4x:;_;_Williams;_203;_sequential;_f1edaca786904e279c3d0ec4a9f1aa91", lti_id: "i4x-Williams-203-lti-04f3e7941b6b4a37b442da8b7054ff44", parent_name: "Demonstration of Advanced Features - Askalot Demo - Neural Networks", shared: true, askable: true, time: 65 },
    ]

    categories.each do |input|
      Timecop.freeze(Time.now - input[:time].days) do
        parent = Shared::Category.find_by(full_tree_name: input[:parent_name])
        parent_id = parent ? parent.id : nil

        category = Shared::Category.create!(
          name: input[:name],
          tags: input[:tags],
          uuid: input[:uuid],
          lti_id: input[:lti_id],
          parent_id: parent_id,
          shared: input[:shared],
          askable: input[:askable]
        )
        category.refresh_full_tree_name
        category.save
      end
    end
  end

  desc 'Fills database with sample watchings'
  task watchings: :environment do
    context_id = Shared::Category.find_by(name: 'Demonstration of Advanced Features').id

    watchings = [
      { category: "Machine Learning 2015 - Askalot Demo - Introduction", user: "Ivan", time: 54, context: context_id },
      { category: "Demonstration of Advanced Features - Askalot Demo - Introduction", user: "Ivan", time: 54, context: context_id },
      { category: "Machine Learning 2015 - Askalot Demo - Introduction", user: "Ben", time: 32, context: context_id },
      { category: "Demonstration of Advanced Features - Askalot Demo - Introduction", user: "John", time: 25, context: context_id },
      { category: "Demonstration of Advanced Features - Askalot Demo - Introduction", user: "Samantha", time: 15, context: context_id },
      { category: "Demonstration of Advanced Features - Askalot Demo - Linear Regression", user: "Andrew", time: 44, context: context_id },
      { category: "Demonstration of Advanced Features - Askalot Demo - Linear Regression", user: "Tom", time: 12, context: context_id },
      { category: "Demonstration of Advanced Features - Askalot Demo - Linear Regression", user: "Lauren", time: 11, context: context_id },
      { category: "Demonstration of Advanced Features - Askalot Demo - Linear Regression", user: "Ella", time: 10, context: context_id },
      { category: "Machine Learning 2015 - Askalot Demo - Support Vector Machines", user: "Ella", time: 60, context: context_id },
      { category: "Demonstration of Advanced Features - Askalot Demo - Support Vector Machines", user: "Ella", time: 60, context: context_id },
      { category: "Demonstration of Advanced Features - Askalot Demo - Support Vector Machines", user: "Archie", time: 10, context: context_id },
      { category: "Machine Learning 2015 - Askalot Demo - Support Vector Machines", user: "Adam", time: 10, context: context_id },
      { category: "Demonstration of Advanced Features - Askalot Demo - Support Vector Machines", user: "Adam", time: 10, context: context_id },
      { category: "Demonstration of Advanced Features - Askalot Demo - Support Vector Machines", user: "Ben", time: 10, context: context_id },
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
      category: "Demonstration of Advanced Features - Askalot Demo - Introduction - About Askalot",
      user: "Archie",
      time: 49,
      title: "Minimal requirements on project",
      text: "There is information in the minimal requirements on the project that it is necessary to use at least two datasets. Are these requirements valid for each algorithm or for overall project?\n\n*[An example of question which tackles with organizational matters]*",
      tag_list: ["minimal-requirements", "project"],
      mention: nil,
      editor: "Archie",
      edited_at: 48
    }, {
      category: "Demonstration of Advanced Features - Askalot Demo - Introduction - About Askalot",
      user: "Sophia",
      time: 45,
      title: "What's is the difference between clustering and classification?",
      text: "What is the difference between clustering and classification?\n\n*[An example of general question]*",
      tag_list: ["clustering", "categorization"],
      mention: nil,
      editor: nil,
      edited_at: nil
    }, {
      category: "Demonstration of Advanced Features - Askalot Demo - Introduction - About Askalot",
      user: "Sophia",
      time: 26,
      title: "Octave version",
      text: "Which version of Octave is most suitable for purpose of the project?\n\n*[An example of a question which aims to obtain a recommendation]*",
      tag_list: ["octave", "project", "version"],
      mention: nil,
      editor: nil,
      edited_at: nil
    }, {
      category: "Machine Learning 2015 - Askalot Demo - Linear Regression - Definition of Linear Regression",
      user: "Ben",
      time: 53,
      title: "Linear vs logistic regression",
      text: "I am not sure whether I understand correctly the difference between a linear and a logistic regression. I think that there is a mistake at the slide 12 and 13, isn't it? I suppose that “linear regresion” should be used instead of “logistic regresion”. Thank you.\n\n*[An example of question, which includes an error report related to study materials]*",
      tag_list: ["linear", "logistic", "regression"],
      mention: nil,
      editor: nil,
      edited_at: nil
    }, {
      category: "Demonstration of Advanced Features - Askalot Demo - Support Vector Machines - Definition of SVM",
      user: "Ivan",
      time: 18,
      title: "SVM implementation in Ruby",
      text: "How can I implement SVM in R language? What is the best possibility how to achieve it?\n\n*[An example of a general question for which another student provided a well-described explanation also with references for supplementary materials]*",
      tag_list: ["svm", "r-language",],
      mention: nil,
      editor: nil,
      edited_at: nil
    }, {
      category: "Demonstration of Advanced Features - Askalot Demo - Support Vector Machines - Definition of SVM",
      user: "Adam",
      time: 7,
      title: "What an abreviation SVM stands for?",
      text: "What an abreviation SVM stands for?\n\n*[An example of inappropriate question that can be solved simply by standard search engines]*",
      tag_list: ["uml"],
      mention: nil,
      editor: nil,
      edited_at: nil
    }, {
      category: "Demonstration of Advanced Features - Askalot Demo - Neural Networks - Definition of Neural Networks",
      user: "Tom",
      time: 31,
      title: "What does the hidden layer in a neural network compute?",
      text: "I understand the input layer and how to normalize the data, I also understand the bias unit, but when it comes to the hidden layer, what the actual computation is in that layer, and how it maps to the output is just a little foggy.\n\n*[An example of a question for which student provided an answer with supplementary materials]*",
      tag_list: ["hidden-layer", "computation"],
      mention: nil,
      editor: nil,
      edited_at: nil
    }, {
      category: "Demonstration of Advanced Features - Askalot Demo - Neural Networks - Definition of Neural Networks",
      user: "Adam",
      time: 41,
      title: "Deep learnign in neural network",
      text: "Is anybody here who has already worked with deep learning in neural networks?\n\n*[An example of social question aimed to find classmate for collaboration]*",
      tag_list: ["deep-learning"],
      mention: nil,
      editor: nil,
      edited_at: nil
    }]

    questions.each do |input|
      Timecop.freeze(Time.now - input[:time].days) do
        category = Shared::Category.find_by(full_tree_name: input[:category]) unless input[:category].nil?
        user = Shared::User.find_by(nick: input[:user])
        editor = Shared::User.find_by(nick: input[:editor]) unless input[:editor].nil?
        mention = Shared::User.find_by(nick: input[:editor]) unless input[:mention].nil?

        question = Shared::Question.create!(
          author_id: user.id,
          category_id: category.nil? ? nil : category.id,
          title: input[:title],
          text: input[:text],
          tag_list: input[:tag_list],
          editor_id: editor.nil? ? nil : editor.id,
          edited_at: input[:edited_at].nil? ? nil : Time.now - input[:edited_at].days,
        )

        Shared::Events::Dispatcher.dispatch :mention, user, question, for: mention unless mention.nil?
        Shared::Events::Dispatcher.dispatch :create, user, question, for: question.parent.watchers + question.tags.map(&:watchers).flatten, anonymous: question.anonymous
        Shared::Watching.deleted_or_new(watcher: user, watchable: question).mark_as_undeleted!
      end
    end
  end

  desc 'Fills database with sample answers'
  task answers: :environment do
    answers = [{
      question: "Minimal requirements on project",
      user: "Andrew",
      time: 49,
      text: "They are applied on the whole project. On the other side they represent really minimal requirements and thus it is advised to regularly consult your project with your supervisor.",
      mention: nil,
      editor: nil,
      edited_at: nil
    }, {
      question: "What's is the difference between clustering and classification?",
      user: "Ruby",
      time: 43,
      text: "**Clustering** is a task of grouping simmilar objects in such way that objects in the same group (cluster) are more similar to each other then to others outside this group.\n\n**Classification** is the problem of identifying to which of a set of categories (clasess) a new observation belongs.",
      mention: nil,
      editor: nil,
      edited_at: nil
    }, {
      question: "Octave version",
      user: "Ivan",
      time: 26,
      text: "I think that the newest one is the best one. The latest Octave 4.0 brought new features, including a graphical user interface, support for classdef object-oriented programming, better compatibility with Matlab, and many new and improved functions.",
      mention: nil,
      editor: nil,
      edited_at: nil
    }, {
      question: "Linear vs logistic regression",
      user: "Adam",
      time: 31,
      text: "I think that there is no difference at all.",
      mention: nil,
      editor: nil,
      edited_at: nil
    }, {
      question: "Linear vs logistic regression",
      user: "John",
      time: 30,
      text: "I have found a very good explanation here: http://stats.stackexchange.com/questions/29325/what-is-the-difference-between-linear-regression-and-logistic-regression \n\nLinear regression is usually solved by minimizing the least squares error of the model to the data, therefore large errors are penalized quadratically. Logistic regression is just the opposite. Using the logistic loss function causes large errors to be penalized to an asymptotically constant.",
      mention: nil,
      editor: nil,
      edited_at: nil
    },  {
      question: "SVM implementation in Ruby",
      user: "Archie",
      time: 14,
      text: "The most simplest way how to implement SVM implementation in Ruby is by utilization of `libsvm` gem:\n\n```ruby\nrequire 'libsvm'\n\n# This library is namespaced.\nproblem = Libsvm::Problem.new\nparameter = Libsvm::SvmParameter.new\n\nparameter.cache_size = 1 # in megabytes\nparameter.eps = 0.001\n\nparameter.c = 10\n\nexamples = [ [1,0,1], [-1,0,-1] ].map {|ary| Libsvm::Node.features(ary) }\nlabels = [1, -1]\n\nproblem.set_examples(labels, examples)\n\nmodel = Libsvm::Model.train(problem, parameter)\n\npred = model.predict(Libsvm::Node.features(1, 1, 1))\nputs \"Example [1, 1, 1] - Predicted \#{pred}\"\n```\n\n\nYou can find more information about this topic at [Github](https://github.com/febeling/rb-libsvm)",
      mention: nil,
      editor: nil,
      edited_at: nil
    }, {
      question: "What does the hidden layer in a neural network compute?",
      user: "Ben",
      time: 5,
      text: "Each layer can apply any function you want to the previous layer to produce an output (usually a linear transformation followed by a squashing nonlinearity). The hidden layer's job is to transform the inputs into something that the output layer can use. You can find more information at [this link](http://stats.stackexchange.com/questions/63152/what-does-the-hidden-layer-in-a-neural-network-compute/63163#63163).",
      mention: nil,
      editor: nil,
      edited_at: nil
    }, {
      question: "Deep learnign in neural network",
      user: "Tom",
      time: 42,
      text: "I have already worked with neural networks and deep learning as a part of assignment at my university. Please, do not hesitate to write me an email and I will be very glad to help you.",
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
      question: "Minimal requirements on project",
      answerer: "Andrew",
      user: "Ben",
      time: 53,
      commentable_type: "Answer",
      text: "@Andrew, thank you very much for clarification.",
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
      question: "What's is the difference between clustering and classification?",
      answerer: "Ruby",
      user: "Andrew",
      time: 41,
      commentable_type: "Answer",
      text: "In addition, it is important to notice that classification is based on supervised learning and clustering on unsupervised learning.",
      mention: nil,
      editor: nil,
      edited_at: nil
    }, {
      question: "Linear vs logistic regression",
      answerer: "John",
      user: "Tom",
      time: 35,
      commentable_type: "Answer",
      text: "@John, thank you very much, it so simple now.",
      mention: "John",
      editor: nil,
      edited_at: nil
    }, {
      question: "What does the hidden layer in a neural network compute?",
      answerer: "Ben",
      user: "Ruby",
      time: 2,
      commentable_type: "Answer",
      text: "@Ben, thank you very much for your perfect answer.",
      mention: "Ben",
      editor: nil,
      edited_at: nil
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
      { question: "What's is the difference between clustering and classification?", user: "Ivan", time: 6 },
      { question: "Linear vs logistic regression", user: "Sophia", time: 28 },
      { question: "Linear vs logistic regression", user: "Ivan", time: 26 },
      { question: "SVM implementation in Ruby", user: "Tom", time: 14 },
      { question: "SVM implementation in Ruby", user: "Ella", time: 2 },
      { question: "What does the hidden layer in a neural network compute?", user: "Andrew", time: 53 },
      { question: "What does the hidden layer in a neural network compute?", user: "Ben", time: 54 },
      { question: "What does the hidden layer in a neural network compute?", user: "John", time: 25 },
      { question: "Deep learnign in neural network", user: "Archie", time: 3 },
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
      { question: "Minimal requirements on project", user: "Amelia", positive: true, time: 48 },
      { question: "Minimal requirements on project", user: "Samantha", positive: true, time: 47 },
      { question: "Linear vs logistic regression", user: "Tom", positive: true, time: 31 },
      { question: "Linear vs logistic regression", user: "John", positive: true, time: 30 },
      { question: "Linear vs logistic regression", user: "Sophia", positive: true, time: 28 },
      { question: "Linear vs logistic regression", user: "Ivan", positive: true, time: 26 },
      { question: "Linear vs logistic regression", user: "Amelia", positive: true, time: 26 },
      { question: "SVM implementation in Ruby", user: "Ivan", positive: true, time: 5 },
      { question: "What an abreviation SVM stands for?", user: "Tom", positive: false, time: 7 },
      { question: "What an abreviation SVM stands for?", user: "Amelia", positive: false, time: 6 },
      { question: "What an abreviation SVM stands for?", user: "Ben", positive: false, time: 3 },
      { question: "Deep learnign in neural network", user: "Amelia", positive: true, time: 54 },
      { question: "Deep learnign in neural network", user: "Ella", positive: true, time: 52 },

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
      { question: "What's is the difference between clustering and classification?", answerer: "Ruby", user: "Samantha", time: 42, positive: true },
      { question: "What's is the difference between clustering and classification?", answerer: "Ruby", user: "Lauren", time: 39, positive: true },
      { question: "What's is the difference between clustering and classification?", answerer: "Ruby", user: "Ella", time: 37, positive: true },
      { question: "Linear vs logistic regression", answerer: "Adam", user: "Ivan", positive: false, time: 31 },
      { question: "Linear vs logistic regression", answerer: "Adam", user: "Archie", positive: false, time: 30 },
      { question: "Linear vs logistic regression", answerer: "Adam", user: "Andrew", positive: false, time: 25 },
      { question: "Linear vs logistic regression", answerer: "John", user: "Andrew", positive: true, time: 15 },
      { question: "Linear vs logistic regression", answerer: "John", user: "Ella", positive: true, time: 14 },
      { question: "SVM implementation in Ruby", answerer: "Archie", user: "Amelia", positive: true, time: 3 },
      { question: "What does the hidden layer in a neural network compute?", answerer: "Ben", user: "Ivan", positive: true, time: 2 },
      { question: "What does the hidden layer in a neural network compute?", answerer: "Ben", user: "Ella", positive: true, time: 1 },
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
      { question: "What's is the difference between clustering and classification?", answerer: "Ruby", user: "Sophia", time: 41 },
      { question: "Linear vs logistic regression", answerer: "John", user: "Tom", time: 29 },
      { question: "Octave version", answerer: "Ivan", user: "Sophia", time: 12 },
      { question: "What does the hidden layer in a neural network compute?", answerer: "Ben", user: "Ruby", time: 2 },
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
      { question: "Minimal requirements on project", user: "John", time: 48 },
      { question: "Minimal requirements on project", user: "Ella", time: 47 },
      { question: "Minimal requirements on project", user: "Adam", time: 46 },
      { question: "Minimal requirements on project", user: "Ivan", time: 46 },
      { question: "What's is the difference between clustering and classification?", user: "Ruby", time: 46 },
      { question: "What's is the difference between clustering and classification?", user: "Adam", time: 46 },
      { question: "What's is the difference between clustering and classification?", user: "Andrew", time: 46 },
      { question: "What's is the difference between clustering and classification?", user: "Samantha", time: 45 },
      { question: "What's is the difference between clustering and classification?", user: "Ivan", time: 45 },
      { question: "What's is the difference between clustering and classification?", user: "Ella", time: 37 },
      { question: "What's is the difference between clustering and classification?", user: "Ella", time: 37 },
      { question: "Linear vs logistic regression", user: "Tom", time: 31 },
      { question: "Linear vs logistic regression", user: "John", time: 30 },
      { question: "Linear vs logistic regression", user: "Sophia", time: 28 },
      { question: "Linear vs logistic regression", user: "Ivan", time: 26 },
      { question: "Linear vs logistic regression", user: "Amelia", time: 26 },
      { question: "Linear vs logistic regression", user: "Ella", time: 26 },
      { question: "Linear vs logistic regression", user: "Samantha", time: 24 },
      { question: "Linear vs logistic regression", user: "Ruby", time: 20 },
      { question: "Linear vs logistic regression", user: "Andrew", time: 4 },
      { question: "Octave version", user: "Sophia", time: 26 },
      { question: "Octave version", user: "Ivan", time: 26 },
      { question: "Octave version", user: "Andrew", time: 25 },
      { question: "Octave version", user: "Ben", time: 22 },
      { question: "Octave version", user: "Amelia", time: 21 },
      { question: "Octave version", user: "John", time: 45 },
      { question: "Octave version", user: "Ella", time: 1 },
      { question: "SVM implementation in Ruby", user: "Ivan", time: 18 },
      { question: "SVM implementation in Ruby", user: "Archie", time: 14 },
      { question: "SVM implementation in Ruby", user: "Amelia", time: 3 },
      { question: "SVM implementation in Ruby", user: "John", time: 10 },
      { question: "SVM implementation in Ruby", user: "Ella", time: 9 },
      { question: "SVM implementation in Ruby", user: "Adam", time: 5 },
      { question: "SVM implementation in Ruby", user: "Adam", time: 7 },
      { question: "SVM implementation in Ruby", user: "Tom", time: 7 },
      { question: "SVM implementation in Ruby", user: "Amelia", time: 6 },
      { question: "SVM implementation in Ruby", user: "Ben", time: 4 },
      { question: "What does the hidden layer in a neural network compute?", user: "Ruby", time: 5 },
      { question: "What does the hidden layer in a neural network compute?", user: "Ben", time: 4 },
      { question: "What does the hidden layer in a neural network compute?", user: "Archie", time: 3 },
      { question: "What does the hidden layer in a neural network compute?", user: "Ivan", time: 2 },
      { question: "What does the hidden layer in a neural network compute?", user: "Ella", time: 1 },
      { question: "Deep learnign in neural network", user: "Adam", time: 45 },
      { question: "Deep learnign in neural network", user: "Tom", time: 45 },
      { question: "Deep learnign in neural network", user: "Amelia", time: 41 },
      { question: "Deep learnign in neural network", user: "John", time: 5 },
      { question: "Deep learnign in neural network", user: "Ella", time: 4 },
      { question: "Deep learnign in neural network", user: "Andrew", time: 53 },
      { question: "Deep learnign in neural network", user: "Ben", time: 54 },
      { question: "Deep learnign in neural network", user: "Ivan", time: 48 },
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

  desc 'Fills database with sample users in context data'
  task labellings: :environment do
    context = Shared::Category.find_by(name: 'Demonstration of Advanced Features')

    Shared::User.all.each do |u|
      Shared::ContextUser.create user: u, context: context.uuid
    end
  end
end
