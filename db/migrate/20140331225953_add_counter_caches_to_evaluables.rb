class AddCounterCachesToEvaluables < ActiveRecord::Migration
  def up
    add_counter :answers,   :evaluations
    add_counter :questions, :evaluations
  end

  def down
    remove_counter :answers,   :evaluations
    remove_counter :questions, :evaluations
  end
end
