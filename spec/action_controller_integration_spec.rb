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
      def self.before_filter(*args); end
    end
  end

  def add_check(&check)
    @class.class_eval(&check)
  end

  it 'binds check as a class method when included' do
    @class.respond_to?(:check).should == true
  end

  describe 'a simple check on a subject' do

    setup do
      add_check { check(:user).can.enforce_the_rule_of_law? }
      @instance = @class.new
    end

    it 'sets up a before filter instance method based on the check' do
      @instance.respond_to?(:check_user_can_enforce_the_rule_of_law?).should == true
    end

    it 'creates a before_filter on the class with the generated method' do
      @class.should_receive(:before_filter).with(:check_user_can_enforce_the_rule_of_law?)
      add_check { check(:user).can.enforce_the_rule_of_law? } # damn mocks
    end

    it 'does nothing if the filter is successful' do
      @instance.should_receive(:assigns).any_number_of_times.with(:user).and_return(@policeman)
      @instance.should_not_receive(:cannot_perform_ability)
      @instance.check_user_can_enforce_the_rule_of_law?
    end

    it 'calls cannot_perform_ability if the filter is unsuccessful' do
      @instance.should_receive(:assigns).any_number_of_times.with(:user).and_return(@citizen)
      @instance.should_receive(:cannot_perform_ability).with(@citizen, :enforce_the_rule_of_law?, nil)
      @instance.check_user_can_enforce_the_rule_of_law?
    end

  end

  it 'handles method_mising more proper, i.e. look into abilities then re-raise if there is a miss'

end
