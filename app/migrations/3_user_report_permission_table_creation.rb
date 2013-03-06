migration 3, :user_report_permission_table_creation do

  up do

    create_table :users do
      column :id,         Integer, serial: true
      column :email,      String, size: 255
      column :password,   String, size: 90
      column :name,       String, size: 50
      column :is_admin,   TrueClass, default: false
      column :created_at, DateTime
      column :updated_at, DateTime
    end
    create_index :users, :email, unique: true

    create_table :reports do
      column :id,         Integer, serial: true
      column :label,      String, size: 20
      column :created_at, DateTime
      column :updated_at, DateTime
    end

    create_table :permissions do
      column :id,         Integer, serial: true
      column :user_id,    Integer
      column :report_id,  Integer
      column :project_id, Integer
      column :created_at, DateTime
      column :updated_at, DateTime
    end
    create_index :permissions, :user_id
    create_index :permissions, :report_id
    create_index :permissions, :project_id

  end

  down do
    drop_table :users
    drop_table :reports
    drop_table :permissions
  end

end
