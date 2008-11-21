class Person < ActiveRecord::Base
  acts_as_boolean  :boolean_boolean,  :boolean2_boolean

  acts_as_boolean  :string_boolean,   :set_false_as => 'nope', :set_true_as => 'yup' 

  acts_as_boolean  :float_boolean, :false_is_also => 99

  acts_as_boolean  :integer_boolean,  :set_false_as => 0, :false_is_also => ['nine', 'nada', 9999]
  acts_as_boolean  :integer2_boolean, :set_false_as => 99, :false_is_also => ['nine', 'nada', 9999]
  acts_as_boolean  :integer3_boolean, :set_false_as => 66, :set_true_as => -1
end
