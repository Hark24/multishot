class AddAcceptTermsToUser < ActiveRecord::Migration
  def change
  	add_column :users, :accept_terms, :boolean, default: false
  end
end
