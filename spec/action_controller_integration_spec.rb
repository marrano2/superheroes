require "#{File.dirname(__FILE__)}/../superheroes"
require "#{File.dirname(__FILE__)}/fixtures"

describe SuperHeroes::ActionControllerIntegration do

  setup do
    @citizen = User.make_citizen
    @policeman = User.make_policeman
    @demigod = User.make_demigod
    @another_demigod = User.make_demigod

    @class = Class.new
    @class.class_eval do
      include SuperHeroes::ActionControllerIntegration
    end
  end

  it 'binds check as a class method when included' do
    @class.respond_to?(:check).should == true
  end

  describe 'a simple check on a subject' do

    setup do
      @class.class_eval do
        check(:user).can.enforce_the_rule_of_law
      end
    end

    it 'sets up a before filter instance method based on the check' do
      @instance = @class.new
      @instance.respond_to?(:check_user_can_enforce_the_rule_of_law).should == true
    end

  end

end