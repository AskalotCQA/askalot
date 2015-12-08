class UpdateCategoriesTree < ActiveRecord::Migration
  def up
    create_table :category_depths do |t|
      t.integer :depth, index: true
      t.string :name
      t.boolean :is_in_public_name

      t.timestamps
    end

    Shared::CategoryDepth.create!({depth: 0, name: 'Root', is_in_public_name: false})
    Shared::CategoryDepth.create!({depth: 1, name: 'Školský rok', is_in_public_name: false})
    Shared::CategoryDepth.create!({depth: 2, name: 'Predmet', is_in_public_name: true})
    Shared::CategoryDepth.create!({depth: 3, name: 'Časť', is_in_public_name: true})

    add_column :categories, :depth, :integer, index: true
    add_column :categories, :children_count, :integer
    add_column :categories, :full_tree_name, :string, index: true
    add_column :categories, :full_public_name, :string, index: true

    add_index :categories, :lft

    categories     = Shared::Category.all.order(:lft)
    finder         = categories.index_by(&:id)

    path           = [nil]
    full_tree_path = []
    full_public_path = []

    i = 1
    total = categories.count.to_s
    categories.each do |category|
      if category.parent_id != path.last
        # We are on a new level, did we descend or ascend?
        if path.include?(category.parent_id)
          # Remove the wrong trailing path elements
          while path.last != category.parent_id
            path.pop
          end
        else
          path << category.parent_id
        end

        full_tree_path = []
        full_public_path = []
        path.each do |id|
          full_tree_path << finder[id].name if finder[id] && finder[id].name != 'root'
          full_public_path << finder[id].name if finder[id] && [2,3].include?(finder[id].level)
        end
      end

      category.full_tree_name = (full_tree_path + [category.name]).join ' - '
      category.full_public_name = (full_public_path + [category.name]).join ' - '

      puts i.to_s + '/' + total + ' Name: ' + category.name + ' Depth: ' + category.level.to_s  + ' | ' + category.full_tree_name  + ' | ' + category.full_public_name

      category.save!
      i += 1
    end
  end

  def down
    remove_column :categories, :depth
    remove_column :categories, :children_count
    remove_column :categories, :full_tree_name
    remove_column :categories, :full_public_name
    remove_index :categories, :lft

    remove_table :category_depths
  end
end
