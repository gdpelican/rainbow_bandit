class AddModels < ActiveRecord::Migration
  def change
    create_table :colors do |t|
      t.string :hex
    end

    create_table :urls do |t|
      t.string :title
      t.string :screencap
      t.string :url
    end

    create_table :color_urls do |t|
      t.references :color
      t.references :url
    end
  end
end
