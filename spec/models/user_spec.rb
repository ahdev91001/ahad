require 'rails_helper'

RSpec.describe User, type: :model do

  describe '#email' do
  
    it 'validates presence' do
      record = User.new
      #record.email = '' # invalid state
      #record.valid? # run validations
      #record.errors[:email].should include("can't be blank") # check for presence of error

      record.email = 'foo@bar.com' # valid state
      record.valid? # run validations
      record.errors[:email].should_not include("can't be blank") # check for absence of error
    end
    
  end

end
