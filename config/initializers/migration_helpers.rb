class ActiveRecord::Migration
  def add_counter(table, association)
    add_column table, "#{association}_count", :integer, null: false, default: 0

    reset_counter table, association
  end

  def remove_counter(table, association)
    remove_column table, "#{association}_count"
  end

  def reset_counter(table, association)
    model = table.to_s.classify.constantize

    model.reset_column_information

    model.unscoped.find_each do |record|
      model.reset_counters record.id, association
    end
  end
end
