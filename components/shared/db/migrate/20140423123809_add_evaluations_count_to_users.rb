class AddEvaluationsCountToUsers < ActiveRecord::Migration
  def up
    add_counter :users, :evaluations
  end

  def down
    remove_counter :users, :evaluations
  end
end
