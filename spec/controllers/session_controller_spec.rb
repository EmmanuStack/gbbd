# frozen_string_literal: true

require "rails_helper"

RSpec.describe SessionController do
  describe "get #create" do
    let(:auth_hash) do
      {
        provider: "github",
        uid: "123456",
        info: {
          name: "John Doe",
        },
        credentials: {
          token: "token123",
        },
      }
    end

    context "when authentication is successful" do
      before do
        request.env["omniauth.auth"] = auth_hash
        allow(User).to receive(:find_or_create_by).and_return(create(:user))
        get :create, params: { provider: "github" }
      end

      it "creates a new user or finds the existing one" do
        expect(User).to have_received(:find_or_create_by).with(provider: auth_hash[:provider], uid: auth_hash[:uid])
      end

      it "sets the user id in the session" do
        expect(session[:user_id]).to eq(User.last.id)
      end

      it "redirects to the overview page" do
        expect(response).to redirect_to(pages_overview_path)
      end
    end

    context "when authentication fails due to Github authentication error" do
      before do
        allow(controller).to receive(:auth_hash).and_raise(StandardError.new("Invalid credentials"))
        get :create, params: { provider: "github" }
      end

      it "redirects to the root path" do
        expect(response).to redirect_to(root_path)
      end

      it "sets an alert message" do
        expect(flash[:alert]).to eq("Invalid credentials")
      end
    end

    context "when authentication fails due to RecordInvalid error" do
      before do
        allow(request.env["omniauth.auth"]).to receive(:[]).and_return(
          {
            provider: "github",
            uid: "123",
            info: {
              name: "John Doe",
            },
            credentials: {
              token: nil,
            },
          },
        )
      end

      it "sets an alert message" do
        expect do
          post :create, params: { provider: "github" }
        end.not_to change(User, :count)

        expect(flash[:alert]).not_to be_empty
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      delete :destroy
    end

    it "resets the session" do
      expect(session).to be_empty
    end

    it "redirects to the root path" do
      expect(response).to redirect_to(root_path)
    end
  end
end
