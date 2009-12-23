class Foo < ActiveRecord::Base
  validates_presence_of :name
  
  MONDAY = "Monday"
  FRIDAY = "Friday"
  SUNDAY = "Sunday"
  DAYS = [MONDAY, FRIDAY, SUNDAY]
  enumeration_for :days, DAYS
  enumeration_for :selected_day, DAYS, :single => true
  
  named_scope :sundays, :conditions => { :selected_day => enumeration_attribute_db_value(:selected_day, Foo::SUNDAY) }
  
end
