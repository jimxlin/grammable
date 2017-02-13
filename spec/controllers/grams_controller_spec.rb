require 'rails_helper'

RSpec.describe GramsController, type: :controller do
  describe "grams#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#show action" do
    it "should successfully show the page if the gram is found" do
      gram = FactoryGirl.create(:gram)
      get :show, params: { id: gram.id }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 if the gram is not found" do
      get :show, params: { id: 'NOTANID' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "grams#new action" do
    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the new form"  do
      user = FactoryGirl.create(:user)
      sign_in user

      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#create action" do
    it "should require users to be logged in" do
      post :create, params: { gram: { message: 'Hello!' } }
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully create a new gram in the database" do
      user = FactoryGirl.create(:user)
      sign_in user

      post :create, params: {
        gram: {
          message: 'Hello!',
          picture: fixture_file_upload("/lenna.jpg", 'image/jpg')
        }
      }

      expect(response).to redirect_to root_path

      gram = Gram.last
      expect(gram.message).to eq("Hello!")
      expect(gram.user).to eq(user)
    end

    it "should properly deal with validation errors" do
      user = FactoryGirl.create(:user)
      sign_in user

      post :create, params: { gram: { message: ''} }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(Gram.count).to eq(0)
    end
  end

  describe "grams#edit action" do
    it "should successfully show the edit form if the gram is found" do
      gram = FactoryGirl.create(:gram)
      sign_in gram.user
      get :edit, params: { id: gram.id }
      expect(response).to have_http_status(:success)
    end

    it "shouldn't let unauthenticated users access the edit form" do
      gram = FactoryGirl.create(:gram)
      get :edit, params: { id: gram.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "shouldn't let users who didn't create the gram access the edit form" do
      gram = FactoryGirl.create(:gram)
      user = FactoryGirl.create(:user)
      sign_in user

      get :edit, params: { id: gram.id }

      expect(response).to have_http_status(:forbidden)
    end

    it "should return a 404 if the gram is not found" do
      get :show, params: { id: 'NOTANID' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "grams#update action" do
    it "should let users to successfully update grams" do
      gram = FactoryGirl.create(:gram, message: "Initial value")
      sign_in gram.user

      patch :update, params: { id: gram.id, gram: { message: 'New Value' } }

      expect(response).to redirect_to root_path
      gram.reload
      expect(gram.message).to eq "New Value"
    end

    it "shouldn't let unauthenticated users update grams" do
      gram = FactoryGirl.create(:gram)
      patch :update, params: { id: gram.id, gram: { message: 'New Value' } }
      expect(response).to redirect_to new_user_session_path
    end

    it "shouldn't let users who didn't create the gram update it" do
      gram = FactoryGirl.create(:gram)
      user = FactoryGirl.create(:user)
      sign_in user

      patch :update, params: { id: gram.id, gram: { message: 'New Value' } }

      expect(response).to have_http_status(:forbidden)
    end


    it "should return a 404 if the gram is not found" do
      user = FactoryGirl.create(:user)
      sign_in user
      patch :update, params: { id: 'NOTANID', gram: { message: 'New Value' } }
      expect(response).to have_http_status(:not_found)
    end

    it "should properly deal with validation errors" do
      gram = FactoryGirl.create(:gram, message: "Initial Value")
      sign_in gram.user

      patch :update, params: { id: gram.id, gram: { message: '' } }

      expect(response).to have_http_status(:unprocessable_entity)
      gram.reload
      expect(gram.message).to eq "Initial Value"
    end
  end

  describe "grams#destroy action" do
    it "should let a user to destroy grams" do
      gram  = FactoryGirl.create(:gram)
      sign_in gram.user

      delete :destroy, params: { id: gram.id }

      expect(response).to redirect_to root_path
      gram = Gram.find_by_id(gram.id)
      expect(gram).to eq nil
    end

    it "shouldn't let unauthenticated users destroy grams" do
      gram = FactoryGirl.create(:gram)
      delete :destroy, params: { id: gram.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "shouldn't let users who didn't create the gram to destroy it" do
      gram = FactoryGirl.create(:gram)
      user = FactoryGirl.create(:user)
      sign_in user

      delete :destroy, params: { id: gram.id }

      expect(response).to have_http_status(:forbidden)
    end

    it "should return a 404 if the id is not in the gram db" do
      user = FactoryGirl.create(:user)
      sign_in user
      delete :destroy, params: { id: 'NOTANID' }
      expect(response).to have_http_status(:not_found)
    end
  end
end
