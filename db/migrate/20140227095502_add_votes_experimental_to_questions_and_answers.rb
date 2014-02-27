class AddVotesExperimentalToQuestionsAndAnswers < ActiveRecord::Migration
  def change
    add_column :questions, :votes_lb_wsci_bp, :decimal, precision: 13, scale: 12, null: false, default: 0
    add_column :answers,   :votes_lb_wsci_bp, :decimal, precision: 13, scale: 12, null: false, default: 0

    add_index :questions, :votes_lb_wsci_bp
    add_index :answers,   :votes_lb_wsci_bp
  end
end
