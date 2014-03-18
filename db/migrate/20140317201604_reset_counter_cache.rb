class ResetCounterCache < ActiveRecord::Migration
  def self.up
    reset_counter :answers, :comments
    reset_counter :answers, :votes

    reset_counter :categories, :questions

    reset_counter :questions, :answers
    reset_counter :questions, :comments
    reset_counter :questions, :favorites
    reset_counter :questions, :views
    reset_counter :questions, :votes

    reset_counter :users, :answers
    reset_counter :users, :comments
    reset_counter :users, :favorites
    reset_counter :users, :questions
    reset_counter :users, :views
    reset_counter :users, :votes
  end
end
