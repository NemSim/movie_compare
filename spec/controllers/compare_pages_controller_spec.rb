require 'spec_helper'

describe ComparePagesController do

  describe "GET 'home'" do
    it "returns http success" do
      get 'home'
      response.should be_success
    end
  end

  describe "GET 'view'" do
    it "returns http success" do
      get 'view'
      response.should be_success
    end
  end

  describe "GET 'compare'" do
    it "returns http success" do
      get 'compare'
      response.should be_success
    end
  end

end
