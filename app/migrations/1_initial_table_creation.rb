migration 1, :initial_table_creation do

  up do

    # create_table :users do
    #   column :id,         Integer, serial: true
    #   column :first_name, String, size: 50
    #   column :last_name,  String, size: 50
    #   column :email,      String, size: 255
    #   column :password,   String, size: 60
    #   column :created_at, DateTime
    #   column :updated_at, DateTime
    # end

    create_table :projects do
      column :id,           Integer, serial: true
      column :title,        String, size: 100
      column :project_hash, String, size: 64
      column :created_at,   DateTime
      column :updated_at,   DateTime
    end
    create_index :projects, :project_hash, unique: true

    create_table :campaigns do
      column :id,               Integer, serial: true
      column :title,            String, size: 100
      column :campaign_hash,    String, size: 64
      column :cookie_lifetime,  Integer, default: 30
      column :parameter_name,   String, size: 20
      column :parameter_value,  String, size: 20
      column :project_id,       Integer
      column :script_template,  DataMapper::Property::Text
      column :created_at,       DateTime
      column :updated_at,       DateTime
    end
    create_index :campaigns, :campaign_hash, unique: true

    create_table :campaign_hits do
      column :id,                 Integer, serial: true
      column :campaign_id,        Integer
      column :campaign_hit_hash,  String, size: 64
      column :created_at,         DateTime
      column :updated_at,         DateTime
    end
    create_index :campaign_hits, :campaign_hit_hash, unique: true

  end

  down do
    # drop_table :users
    drop_table :projects
    drop_table :campaigns
    drop_table :campaign_hits
  end

end
