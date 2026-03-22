class CreateInquiries < ActiveRecord::Migration[8.1]
  def change
    create_table :inquiries do |t|
      t.string :name, null: false
      t.string :phone, null: false
      t.string :inquiry_type
      t.text :comment, null: false
      t.string :status, null: false, default: "new"

      t.timestamps
    end

    add_index :inquiries, :status
    add_index :inquiries, :created_at
  end
end
