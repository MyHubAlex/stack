require 'rails_helper'

RSpec.describe Vote do
  it { should belong_to :votable } 
  it { should belong_to :user }
    
  it { should validate_presence_of :votable_id}
  it { should validate_presence_of :user_id}
  it { should validate_inclusion_of(:point).in?(-1..1) }  
end
