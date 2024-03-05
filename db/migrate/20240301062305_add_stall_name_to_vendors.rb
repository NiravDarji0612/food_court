class AddStallNameToVendors < ActiveRecord::Migration[7.1]
  def change
    add_column :vendors, :stall_name, :string
  end
end
