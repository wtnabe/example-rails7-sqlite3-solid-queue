class Content < ActiveRecord::Migration[7.1]
  def change
    create_table :contents do |t|
      t.text :blob, null: false

      t.timestamps
    end
  end
end
