module ActiveRecord
  module ArEnumerations

    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
    end

    module ClassMethods

      def enumeration_for(name, values, options = { :single => false })
        enumeration_attribute(name, values, options[:single])
      end
      
      def enumeration_attribute_options(name)
        enumeration_attributes = read_inheritable_attribute(:enumeration_attributes) || {}
        if enumeration_attributes.include?(name)
          enumeration_attributes[name]
        else
          raise ArgumentError, "Could not find enumeration attribute `#{name}` in class #{self.class.name}"
        end
      end
      
      def enumeration_attribute_db_value(name, values)
        attribute_options = enumeration_attribute_options(name)
        value = values.is_a?(Array) ? values.map(&:to_s) : [values].map(&:to_s)
        (value & attribute_options[:values]).map { |r| 2**attribute_options[:values].index(r) }.sum
      end

    protected
    
      def enumeration_accessors(name)
        class_eval <<-EOE
          def #{name}; enumeration_read(:#{name}); end
          def #{name}=(new_value); enumeration_write(:#{name}, new_value); end
        EOE
      end

      def enumeration_attribute(name, values, single)
        enumeration_attributes = read_inheritable_attribute(:enumeration_attributes) || {}
        options = {}
        options[:values] = values
        options[:single] = single
        enumeration_attributes[name] = options
        write_inheritable_attribute(:enumeration_attributes, enumeration_attributes)
        enumeration_accessors(name)
      end
      
    end

    module InstanceMethods

      def enumeration_read(name)
        attribute_options = self.class.enumeration_attribute_options(name)
        unless self[name].nil?
          result = attribute_options[:values].reject { |r| ((self[name] || 0) & 2**attribute_options[:values].index(r)).zero? }  
          if attribute_options[:single]
            result.first 
          else
            result
          end
        else
          nil
        end
      end

      def enumeration_write(name, new_value)
        self[name] = self.class.enumeration_attribute_db_value(name, new_value)
        new_value
      end
      
      def enumeration_options(name)
        attribute_options = self.class.enumeration_attribute_options(name)
        attribute_options[:values]
      end

    end
  end
end
