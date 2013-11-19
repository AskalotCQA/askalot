class AddSocialNetworksToUsers < ActiveRecord::Migration
  def change
    add_column :users, :bitbucket,        :string
    add_column :users, :flickr,           :string
    add_column :users, :foursquare,       :string
    add_column :users, :github,           :string
    add_column :users, :'google-plus',    :string
    add_column :users, :instagram,        :string
    add_column :users, :pinterest,        :string
    add_column :users, :'stack-overflow', :string
    add_column :users, :tumblr,           :string
    add_column :users, :youtube,          :string
  end
end
