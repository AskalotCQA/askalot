class AddCounterCaches < ActiveRecord::Migration
  def self.up
    add_counter :answers, :comments
    add_counter :answers, :votes

    add_counter :categories, :questions

    add_counter :questions, :answers
    add_counter :questions, :comments
    add_counter :questions, :favorites
    add_counter :questions, :views
    add_counter :questions, :votes

    add_counter :users, :answers
    add_counter :users, :comments
    add_counter :users, :favorites
    add_counter :users, :questions
    add_counter :users, :views
    add_counter :users, :votes
  end

  def self.down
    remove_counter :answers, :comments
    remove_counter :answers, :votes

    remove_counter :categories, :questions

    remove_counter :questions, :answers
    remove_counter :questions, :comments
    remove_counter :questions, :favorites
    remove_counter :questions, :views
    remove_counter :questions, :votes

    remove_counter :users, :answers
    remove_counter :users, :comments
    remove_counter :users, :favorites
    remove_counter :users, :questions
    remove_counter :users, :views
    remove_counter :users, :votes
  end

  def self.add_counter(table, association)
    add_column table, "#{association}_count", :integer, null: false, default: 0

    model = table.to_s.classify.constantize

    model.reset_column_information

    model.find_each do |record|
      model.reset_counters record.id, association
    end
  end

  def self.remove_counter(table, association)
    remove_column table, "#{association}_count"
  end
end
