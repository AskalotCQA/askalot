class AddCounterCachesToEvaluables < ActiveRecord::Migration
  def self.up
    add_counter :answers,   :evaluations
    add_counter :questions, :evaluations
  end

  def self.down
    remove_counter :answers,   :evaluations
    remove_counter :questions, :evaluations
  end
end
