require 'spec_helper'

describe AuthorsController do
  before(:each) do
    customer = FactoryGirl.create :customer
    @author = FactoryGirl.create :author
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    @controller.stub(:current_ability).and_return(@ability)
    sign_in customer
  end

  describe "GET #index" do
    context "with read ability" do
      before do
        @ability.can :read, Author
      end
      it "returns an array of authors" do
        get :index 
        expect(assigns(:authors)).to eq [@author]
      end 
      it "renders the index template" do
        get :index
        expect(response).to render_template("index")
      end
    end
    context "without read ability" do
      before do
        @ability.cannot :read, Author
      end
      it "redirects to customer_session_path" do
        get :index
        expect(response).to redirect_to customer_session_path
      end
    end
  end

  describe "GET #show" do
    context "with read ability" do
      before do
        @ability.can :read, Author
        Author.stub(:find).and_return @author
      end
      it "receives find and return author" do
        expect(Author).to receive(:find).with(@author.id.to_s).and_return @author
        get :show, id: @author.id
      end
      it "assigns author" do
        get :show, id: @author.id
        expect(assigns(:author)).to eq @author
      end
      it "renders template show" do
        get :show, id: @author.id
        expect(response).to render_template("show")
      end
    end
    context "without read ability" do
      before do
        @ability.cannot :read, Author
      end
      it "redirects_to customer_session_path" do
        get :show, id: @author.id
        expect(response).to redirect_to customer_session_path
      end
    end
  end
end
