migration 2, :order_table_creation do

  up do

    create_table :orders do
      column :id,           Integer, serial: true
      column :order_id,     String, size: 20
      column :total,        Float
      column :currency,     String, size: 10
      column :quantity,     Integer
      column :created_at,   DateTime
      column :updated_at,   DateTime
    end
    create_index :orders, :order_id, unique: true
    create_index :orders, :total
    create_index :orders, :quantity

    create_table :order_items do
      column :id,         Integer, serial: true
      column :order_id,   Integer
      column :parameter,  DataMapper::Property::Text
      column :created_at, DateTime
      column :updated_at, DateTime
    end
    create_index :order_items, :order_id

  end

  down do
    drop_table :orders
    drop_table :order_items
  end

end
