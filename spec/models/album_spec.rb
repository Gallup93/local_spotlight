require 'rails_helper'
RSpec.describe Album, type: :model do 
  it "test album exist" do 
    attrs = {items: {name: "Californication", images:[{url: "test URL"}, {url: "this is the bad url"}]}}

    album = Album.new(attrs[:items])

    expect(album).to be_a Album
    expect(album.name).to eq("Californication")
    expect(album.cover).to eq("test URL")
  end 

end