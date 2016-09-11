require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  context "when logged in as admin" do
    before(:each) do
      @admin = User.create(:email => "brian@airtailor.com", :password => "12345")
      allow(controller).to receive(:current_user).and_return(@admin)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "renders the show template" do
      get :show, id: @admin.id
      expect(response).to render_template(:show)
    end

    it "it renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end

    describe "POST create" do
      context "when user params are valid" do
        before(:each) do
          @new_user_params = {:email => "blah@blah.com", :password => "12345" }
        end

        it "saves new user" do
          expect{post :create, :user => @new_user_params}.to change(User, :count).by(1)
        end

        it "redirects to new user's page" do
          post :create, :user => @new_user_params
          expect(response).to redirect_to(assigns[:user])
        end
      end


      context "when user params are invalid" do
        before(:each) do
          @new_user_params = {:email => "blah@blah.com", :password => "2" }
        end

        it "does not save new user" do
          expect{post :create, :user => @new_user_params}.to_not change(User, :count)
        end

        it "renders the new template" do
          post :create, :user => @new_user_params
          expect(response).to redirect_to("/users/new")
        end
      end
    end # ends post create

    describe "PUTS update" do
      before(:each) do
        @user = User.first
      end

      context "when user params are valid" do
        before(:each) do
          @update_params = {:email => @user.email, :password => "redux4TheWin", :business_name => "Pleasant Ghost" }
          put :update, :id => @user.id, :user => @update_params
          @user.reload
        end

        it "should find the user by id" do
          expect(assigns[:user]).to eq(@user)
        end

        it "should save new data" do
          expect(@user.business_name).to eq("Pleasant Ghost")
        end

        it "should redirect to the user page" do
          expect(response).to redirect_to(assigns[:user])
        end
      end

      context "when user params are invalid" do
        before(:each) do
          @update_params = {:email => @user.email, :password => "", :business_name => "Pleasant Ghost" }
          put :update, :id => @user.id, :user => @update_params
        end

        it "should not save new data" do
          expect(response).to_not be_success
        end

        it "renders the new template" do
          expect(response).to redirect_to("/users/#{@user.id}/edit")
        end
      end
    end # ends puts update
  end # ends context when logged in as admin

  context "when not logged in as non-admin" do
    before(:each) do
      @user = User.create(:email => "blah@blah.com", :password => "12345")
      allow(controller).to receive(:current_user).and_return(@user)
    end

    it "should not render the index template" do
      get :index
      expect(response).to redirect_to("/")
    end

    it "renders the user's show template" do
      get :show, id: @user.id
      expect(response).to render_template(:show)
    end

    it "should not render the new template" do
      get :new
      expect(response).to redirect_to("/")
    end

    describe "PUTS update" do
      context "when user params are valid" do
        before(:each) do
          @update_params = {:email => @user.email, :password => "redux4TheWin", :business_name => "Pleasant Ghost" }
          put :update, :id => @user.id, :user => @update_params
          @user.reload
        end

        it "should find the user by id" do
          expect(assigns[:user]).to eq(@user)
        end

        it "should save new data" do
          expect(@user.business_name).to eq("Pleasant Ghost")
        end

        it "should redirect to the user page" do
          expect(response).to redirect_to(assigns[:user])
        end
      end

      context "when user params are invalid" do
        before(:each) do
          @update_params = {:email => @user.email, :password => "", :business_name => "Pleasant Ghost" }
          put :update, :id => @user.id, :user => @update_params
        end

        it "should not save new data" do
          expect(response).to_not be_success
        end

        it "renders the new template" do
          expect(response).to redirect_to("/users/#{@user.id}/edit")
        end
      end
    end # ends puts update
  end

end
