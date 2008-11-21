require 'active_record/version'

module ActsAsBoolean
  module ClassMethods

    # Treats a column as a boolean, whether it's a tinyint, integer, float, 
    # string, etc.  No matter how the true and false are stored in the database.
    #
    # This is useful when you don't have control over how booleans are 
    # stored by different applications.  For example: Microsoft Access stores 
    # booleans as 0 and -1.  Normally -1 in a MySQL database, would be
    # converted, by Rails/ActiveRecord, into a false, rather than true as it 
    # should be.
    #
    # You can use either foo or foo? methods and they return the same result.
    #
    # The following are false (lower or any case), all else are true: 
    # false, nil, 0, 0.0, '', '0', '0.0', 'f', 'false', 'n', 'no', 'negative', 
    # [], {}
    # You can add to these, for individual columns, using the false_is_also
    # parameter.  Note: if you use the set_false_as parameter, it will 
    # automatically be added to the list of falses for this column.
    #
    # You can specify a specific way a boolean should be stored when 
    # assigned with set_false_as and set_true_as parameters.  This will not 
    # change how the value is evaluated on read.  In other words, if you save 
    # a false as a 'nope', a value of '0' or 'f' in the database will still be 
    # read as a false. It only affects how it is stored.
    #
    # The values set with set_true_as and set_false_as have to be appropriate 
    # for the field type. You, obviously, can't store 'foo' in an integer field.
    # Also note that boolean type fields can't have set_false_as or 
    # set_true_as set, because booleans are stored differently in different 
    # databases (for example: 't' and 'f' in sqlite and 0 and 1 in others).  
    # However, acts_as_boolean is still useful for booleans, to correctly
    # convert something like a -1 to true.
    #
    # Parameters:
    #
    #   * set_false_as  - What false value to store in the column on assignment.
    #                     By default any value will be stored, and converted to
    #                     true or false when you read the value.      
    #   * set_true_as   - What true value to store in the column on assignment.
    #                     By default any value will be stored, and converted to
    #                     true or false when you read the value.
    #   * false_is_also - Additional values to be treated as false, a value or 
    #                     an array is fine
    #
    # Examples of use:
    # class Person < ActiveRecord::Base
    #   acts_as_boolean :alive, :employee
    #   acts_as_boolean :vendor, client, :set_true_as => -1
    #   acts_as_boolean :foo, :false_is_also => ['nine', 'nada', 9999]
    #   acts_as_boolean :bar, :set_false_as => 'no', :set_true_as => 'yes', :false_is_also => 'nyet'
    #
    #   #...
    # end
    def acts_as_boolean(*args)

      options = args.extract_options!
      false_is_also = options[:false_is_also]
      set_false_as, set_true_as = options[:set_false_as], options[:set_true_as]


      if false_is_also or set_false_as 
         
        if false_is_also and set_false_as
          false_is_also =  [*set_false_as] | [*false_is_also] # Combine them as an array
        elsif set_false_as
          false_is_also = set_false_as # Use just the one value, else just false_is_also
        end

        end_true_call = ", #{false_is_also.inspect}" 
      else
        end_true_call = ""
      end


      # Create setters
      set_false = set_false_as ? set_false_as.inspect : 'new_value'
      set_true  = set_true_as  ? set_true_as.inspect  : 'new_value'

      args.each do |arg|

        # For Rails 2.1 and higher, tell dirty module that we are changing the value
        if (ActiveRecord::VERSION::MAJOR == 2 and ActiveRecord::VERSION::MINOR >= 1) or
           (ActiveRecord::VERSION::MAJOR > 2)
          dirty_code = "#{arg}_will_change!"
        end

        kode = %Q(
          def #{arg}=(new_value)
            #{dirty_code}
            
            if is_true?( new_value #{end_true_call})
              self[:#{arg}] = #{set_true}
            else
              self[:#{arg}] = #{set_false}
            end
          end
        )
        class_eval kode
      end


      # Create getters
      args.each do |arg|
        kode = %Q(
          def #{arg}?
            is_true?( #{arg}_before_type_cast #{end_true_call})
          end
          alias :#{arg} :#{arg}?
        )
        class_eval kode
      end 
    end

  end # ClassMethods

  module InstanceMethods

    protected
      def is_true?(value, false_is_also = nil)
        if false_is_also and (false_is_also == value or Array(false_is_also).include?(value)) # For performance
          false
        else

          if value.kind_of?(String) # Split into 2 arrays for performance reasons
            !STRING_FALSES.include?(value.downcase)
          else
            !FALSES.include?(value)
          end

        end
      end

    private 
      STRING_FALSES = [ '', '0', '0.0', 'f', 'false', 'n', 'no', 'negative' ]
      FALSES = [ false, nil, 0, 0.0, [], {} ]

  end # InstanceMethods
end # ActsAsBoolean
 

class ActiveRecord::Base
  include ActsAsBoolean::InstanceMethods
end
ActiveRecord::Base.extend  ActsAsBoolean::ClassMethods
