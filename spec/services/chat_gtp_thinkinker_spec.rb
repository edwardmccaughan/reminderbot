require 'rails_helper'

RSpec.describe ChatGtpThinker do

  # NOTE: this hits the real api and uses up credits, so use with caution

  context 'adding a reminder' do
    subject { ChatGtpThinker.new.reminder_test("remind me to buy salad tomorrow") }

    it 'should generally work' do
      expect{ subject }.to change{Task.count}.by(1)
    end
  end
end