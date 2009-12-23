require "#{File.dirname(__FILE__)}/test_helper"

setup_db

class Foo < ActiveRecord::Base

  MONDAY = "Monday"
  FRIDAY = "Friday"
  SUNDAY = "Sunday"
  DAYS = [MONDAY, FRIDAY, SUNDAY]
  
  enumeration_for :days, DAYS
  enumeration_for :selected_day, DAYS, :single => true

end

class ArEnumerationsTest < ActiveSupport::TestCase

  def setup
    @foo = Foo.new(:days => [Foo::MONDAY, Foo::FRIDAY], :selected_day => Foo::MONDAY)
  end

  test "should correctly handle enumeration_for attributes" do
    assert @foo.save
    assert_equal Foo::MONDAY, @foo.selected_day
    assert_equal [Foo::MONDAY, Foo::FRIDAY], @foo.days
  end
  
  test "show be possible to change single enumeration_for value" do
    assert @foo.save
    assert_equal Foo::MONDAY, @foo.selected_day
    @foo.selected_day = Foo::FRIDAY
    assert @foo.save
    assert_equal Foo::FRIDAY, @foo.selected_day
  end

  test "show be possible to change multiple enumeration_for values" do
    assert @foo.save
    assert_equal [Foo::MONDAY, Foo::FRIDAY], @foo.days
    @foo.days = [Foo::MONDAY, Foo::FRIDAY, Foo::SUNDAY]
    assert @foo.save
    assert_equal [Foo::MONDAY, Foo::FRIDAY, Foo::SUNDAY], @foo.days
  end
  
  test "should be possible to get DB value for value" do
    assert @foo.save
    assert_equal Foo::MONDAY, @foo.selected_day
    assert_equal Foo.enumeration_attribute_db_value(:selected_day, Foo::MONDAY), @foo[:selected_day]
  end  

end
