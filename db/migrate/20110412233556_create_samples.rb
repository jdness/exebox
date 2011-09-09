class CreateSamples < ActiveRecord::Migration
  def self.up
    create_table :samples do |t|
      t.string :token
      t.binary :binary
      t.text :hexequiv
      t.string :filetype
      t.string :md5
      t.string :sha1
      t.integer :status
      t.timestamps
    end
  end

  def self.down
    drop_table :samples
  end
end
