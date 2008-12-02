class CreateAcceptLists < ActiveRecord::Migration
  def self.up
    create_table :accept_lists do |t|
      t.string :header
      t.text :payment_types
      t.text :insurance_types
      t.text :note
      t.string :organization_uid

      t.timestamps
    end
  end

  def self.down
    drop_table :accept_lists
  end
end
