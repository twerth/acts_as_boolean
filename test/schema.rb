ActiveRecord::Schema.define :version => 0 do
  
  create_table :people, :force => true do |t|
    t.column :boolean_boolean,  :boolean
    t.column :boolean2_boolean, :boolean
    t.column :integer_boolean,  :integer
    t.column :integer2_boolean, :integer
    t.column :integer3_boolean, :integer
    t.column :float_boolean,    :float
    t.column :string_boolean,   :string
    t.column :string2_boolean,  :string
  end
  
end
