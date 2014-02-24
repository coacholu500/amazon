require 'spec_helper'

describe BillAddressesController do
  before(:each) do
    @customer = FactoryGirl.create :customer
    @bill_address= FactoryGirl.create :bill_address, zipcode: 12345
    sign_in @customer
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    @controller.stub(:current_ability).and_return(@ability)
  end

  describe "GET #new" do
    context "with manage ability" do
      before do
        @ability.can :manage, BillAddress
      end
      it "builds bill_address if customer do not have it already" do
        get :new
        expect(assigns(:bill_address)).to be_a_new BillAddress
      end
      it "renders template new if have manage ability" do
        get :new
        expect(response).to render_template 'new'
      end
      it "redirects to edit_customer_registration_path if customer already have bill_address" do
        FactoryGirl.create :bill_address, customer_id: @customer.id
        get :new
        expect(response).to redirect_to edit_customer_registration_path
      end
    end
    context "without manage ability" do
      before do
        @ability.cannot :manage, BillAddress
      end
      it "redirects to customer_session_path" do
        get :new
        expect(response).to redirect_to customer_session_path
      end
    end
  end

  describe "GET #edit" do
    context "with manage ability" do
      before do
        @ability.can :manage, BillAddress
        BillAddress.stub(:find).and_return @bill_address
      end
      it "receives find and return bill_address" do
        expect(BillAddress).to receive(:find).with(@bill_address.id.to_s).and_return @bill_address
        get :edit, id: @bill_address.id
      end
      it "assigns bill_address" do
        get :edit, id: @bill_address.id
        expect(assigns(:bill_address)).to eq @bill_address
      end
      it "renders template edit" do
        get :edit, id: @bill_address.id
        expect(response).to render_template("edit")
      end
    end
    context "without manage ability" do
      before do
        @ability.cannot :manage, BillAddress
        BillAddress.stub(:find).and_return @bill_address
      end
      it "redirects to customer_session_path" do
        get :edit, id: @bill_address.id
        expect(response).to redirect_to customer_session_path
      end
    end
  end

  describe "POST #create" do
    context "with manage ability" do
      before do
        @ability.can :manage, BillAddress
      end
      context "with valid attributes" do
        it "creates new bill_address" do
          expect{post :create, bill_address: FactoryGirl.attributes_for(:bill_address)}.to change(BillAddress, :count).by(1)
        end
        it "redirects to edit_customer_registration_path" do  
          post :create, bill_address: FactoryGirl.attributes_for(:bill_address)
          expect(response).to redirect_to edit_customer_registration_path
        end
      end
      context "with invalid attributes" do
        it "do not creates new bill_address" do
          expect{post :create, bill_address: FactoryGirl.attributes_for(:bill_address, zipcode: "zipcode")}.to_not change(BillAddress, :count)      
        end
        it "renders template new" do  
          post :create, bill_address: FactoryGirl.attributes_for(:bill_address, zipcode: "zipcode")
          expect(response).to render_template "new"
        end
      end
    end
    context "without manage ability" do
      before do
        @ability.cannot :manage, BillAddress
      end
      context "with valid attributes" do
        it "do not creates new bill_address" do
          expect{post :create, bill_address: FactoryGirl.attributes_for(:bill_address)}.to_not change(BillAddress, :count)
        end
        it "do not redirects to edit_customer_registration_path" do  
          post :create, bill_address: FactoryGirl.attributes_for(:bill_address)
          expect(response).to_not redirect_to edit_customer_registration_path
        end
      end
      context "with invalid attributes" do
        it "do not creates new bill_address" do
          expect{post :create, bill_address: FactoryGirl.attributes_for(:bill_address, zipcode: "zipcode")}.to_not change(BillAddress, :count)      
        end
        it "redirects to customer_session_path" do  
          post :create, bill_address: FactoryGirl.attributes_for(:bill_address, zipcode: "zipcode")
          expect(response).to redirect_to customer_session_path
        end
      end
    end
  end

  describe "PUT #update" do
    context "with manage ability" do
      before do
        @ability.can :manage, BillAddress
        BillAddress.stub(:find).and_return @bill_address
      end
      it "receives find and return bill_address" do
        expect(BillAddress).to receive(:find).with(@bill_address.id.to_s).and_return @bill_address
        put :update, id: @bill_address.id, bill_address: FactoryGirl.attributes_for(:bill_address)
      end
      context "with valid attributes" do
        it "updates @bill_address's attributes" do
          put :update, id: @bill_address.id, bill_address: FactoryGirl.attributes_for(:bill_address, address: "new address")
          @bill_address.reload
          expect(@bill_address.address).to eq "new address"
        end
        it "redirects to edit_customer_registration_path" do  
          put :update, id: @bill_address.id, bill_address: FactoryGirl.attributes_for(:bill_address)
          expect(response).to redirect_to edit_customer_registration_path
        end
      end
      context "with invalid attributes" do
        it "do not updates @bill_address's attributes" do
          put :update, id: @bill_address.id, bill_address: FactoryGirl.attributes_for(:bill_address, zipcode: "zipcode")
          @bill_address.reload
          expect(@bill_address.zipcode).to_not eq "zipcode"
        end
        it "renders template edit" do  
          put :update, id: @bill_address.id, bill_address: FactoryGirl.attributes_for(:bill_address, zipcode: "zipcode")
          expect(response).to render_template "edit"
        end
      end
    end
    context "without manage ability" do
      before do
        @ability.cannot :manage, BillAddress
        BillAddress.stub(:find).and_return @bill_address
      end
      context "with valid attributes" do
        it "do not updates @bill_address's attributes" do
          put :update, id: @bill_address.id, bill_address: FactoryGirl.attributes_for(:bill_address, address: "new address")
          @bill_address.reload
          expect(@bill_address.address).to_not eq "new address"
        end
        it "do not redirects to edit_customer_registration_path" do  
          put :update, id: @bill_address.id, bill_address: FactoryGirl.attributes_for(:bill_address)
          expect(response).to_not redirect_to edit_customer_registration_path
        end
      end
      context "with invalid attributes" do
        it "do not updates @bill_address's attributes" do
          put :update, id: @bill_address.id, bill_address: FactoryGirl.attributes_for(:bill_address, zipcode: "zipcode")
          @bill_address.reload
          expect(@bill_address.zipcode).to_not eq "zipcode"
        end
        it "redirects to customer_session_path" do  
          put :update, id: @bill_address.id, bill_address: FactoryGirl.attributes_for(:bill_address, zipcode: "zipcode")
          expect(response).to redirect_to customer_session_path
        end
      end
    end
  end

  describe 'DELETE destroy' do
    context "with manage ability" do
      before do
        @ability.can :manage, BillAddress
        BillAddress.stub(:find).and_return @bill_address
      end
      it "receives find and return bill_address" do
        expect(BillAddress).to receive(:find).with(@bill_address.id.to_s).and_return @bill_address
        delete :destroy, id: @bill_address.id
      end
      it "deletes bill_address" do
        expect{delete :destroy, id: @bill_address.id}.to change(BillAddress, :count).by(-1)
        delete :destroy, id: @bill_address.id
      end
      it "redirects to edit_customer_registration_path if customer already have bill_address" do
        delete :destroy, id: @bill_address.id
        expect(response).to redirect_to edit_customer_registration_path
      end
    end
    context "without manage ability" do
      before do
        @ability.cannot :manage, BillAddress
        BillAddress.stub(:find).and_return @bill_address
      end
      it "do not deletes bill_address" do
        expect{delete :destroy, id: @bill_address.id}.to_not change(BillAddress, :count)
        delete :destroy, id: @bill_address.id
      end
      it "redirects to customer_session_path" do
        delete :destroy, id: @bill_address.id
        expect(response).to redirect_to customer_session_path
      end
    end
  end
end
