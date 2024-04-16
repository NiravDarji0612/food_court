class ChangeTokenNumberToIntegerInOrder < ActiveRecord::Migration[7.1]
  def change
    change_column :orders, :token_number, :integer, default: 0, using: 'token_number::integer'
  end
end
