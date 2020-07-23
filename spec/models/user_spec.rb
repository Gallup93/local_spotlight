require 'rails_helper'

RSpec.describe User, type: :model do
  describe "relationships" do
    it {should have_many :user_artists}
    it {should have_many(:artists).through(:user_artists)}
  end
end
