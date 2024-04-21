require 'rails_helper'

RSpec.describe Coupon, type: :model do
  it {should belong_to :merchant}
  it {should have_many :invoices}
  

  # describe '#validations' do
  #   it { should validate_uniqueness_of :code }
  # end
end
