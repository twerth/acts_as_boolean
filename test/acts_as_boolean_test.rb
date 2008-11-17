require File.dirname(__FILE__) + '/test_helper'

class ActsAsBooleanTest < Test::Unit::TestCase
  def setup
    @person = Person.new

    # Make public for testing
    Person.send(:public, *Person.protected_instance_methods) 
  end
  
  def teardown
    Person.delete_all
  end
  
  def test__is_true__should_return_false_for_false_values
    [ false, nil, 0, 0.0, '', '0', '0.0', 'f', 'F', 'false', 'FALSE', 'False', 'faLSe', 'n', 'N', 'no', 'NO', 'No', 'negative', 'NEGATIVE', 'Negative', [], {} ].each do |o| 
      assert !@person.is_true?(o)
    end
  end

  def test__is_true__should_return_true_for_true_values
    [ 1, -1, 1.0, true, 't', 'T', 'true', 'TRUE', 'yes', 'yEs', 'y', 'foo', 45.5, [1,2] ].each do |o| 
      assert @person.is_true?(o)
    end
  end

  # def test_performance_of__is_true_
    # puts "\nis_true performance: "
    # puts Benchmark.measure { 
      # 5000.times do |i|
        # test__is_true__should_return_false_for_false_values
        # test__is_true__should_return_true_for_true_values

        # # 10.times do 
          # # t = @person.is_true?(true)
          # # t = @person.is_true?(false)
        # # end
      # end
    # }
  # end

  def test__false_is_also__should_add_additional_false_consants_to__is_true
    assert @person.is_true?(66)
    assert @person.is_true?(1, ['nine', 'nada', 9999])
    assert @person.is_true?(-1, 1)

    assert !@person.is_true?(66, [66])
    assert !@person.is_true?(66, 66)

    assert !@person.is_true?('nine', ['nine', 'nada', 9999])
    assert !@person.is_true?(9999, ['nine', 'nada', 9999])

    assert !@person.is_true?(0, ['nine', 'nada', 9999])
    assert !@person.is_true?('f', ['nine', 'nada', 9999])
  end

  def test__false_is_also__should_add_additional_false_consants
    @person.integer2_boolean = false 
    assert !@person.integer2_boolean
  end

  def test_both_read_methods_should_return_the_same_value
    @person.boolean_boolean = true
    assert @person.boolean_boolean?
    assert @person.boolean_boolean
    
    @person.boolean_boolean = 0
    assert !@person.boolean_boolean?
    assert !@person.boolean_boolean

    @person.boolean_boolean = -1
    assert @person.boolean_boolean?
    assert @person.boolean_boolean
  end
  
  def test_all_should_return_false_as_nil_is_false
    assert !@person.boolean_boolean 
    assert !@person.boolean2_boolean 
    assert !@person.boolean3_boolean 
    assert !@person.boolean4_boolean 
    assert !@person.integer_boolean 
    assert !@person.string_boolean 
  end

  def test_value_should_be_stored_as_set_for_non_booleans
    # If set_true_as or set_false_as aren't set
    person = Person.new
    person.integer_boolean = 66
    assert person.integer_boolean?
    assert_equal 66, person.integer_boolean_before_type_cast

    person.save
    assert_equal 66, person.integer_boolean_before_type_cast
  end
  
  def test_single__false_is_also__should_return_false
    @person.boolean4_boolean = 99
    assert !@person.boolean4_boolean

    # These shouldn't
    @person.boolean_boolean = 99
    assert @person.boolean_boolean
    
    @person.boolean4_boolean = 98
    assert @person.boolean4_boolean
  end

  def test_array_for__false_is_also__should_return_false
    @person.integer_boolean = 9999 
    assert !@person.integer_boolean?

    @person.integer_boolean = 9998 
    assert @person.integer_boolean?

    @person.integer_boolean = 0 
    assert !@person.integer_boolean?

    @person.integer_boolean = 'f' 
    assert !@person.integer_boolean?

    @person.integer_boolean = 'nada' 
    assert !@person.integer_boolean?
  end

  def test__set_true_as__should_change_how_a_true_value_is_stored_in_db
    person = Person.new
    person.boolean3_boolean = true
    person.string_boolean = true
    person.save

    assert_equal -1, person.boolean3_boolean_before_type_cast
    assert_equal 'yup', person.string_boolean_before_type_cast
  end

  def test__set_false_as__should_change_how_a_false_value_is_stored_in_db
    person = Person.new
    person.string_boolean = false
    person.integer_boolean = false
    person.save

    assert_equal 'nope', person.string_boolean_before_type_cast
    assert_equal 0, person.integer_boolean_before_type_cast
  end

end
