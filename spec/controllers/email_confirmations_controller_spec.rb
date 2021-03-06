require "rails_helper"

describe EmailConfirmationsController do
  describe "#update" do
    context "with invalid confirmation token" do
      it "raises RecordNotFound exception" do
        expect do
          get :update, token: "inexistent"
        end.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end

    context "with valid confirmation token" do
      it "confirms user and signs it in" do
        user = create(
          :user,
          email_confirmation_token: "valid_token",
          email_confirmed_at: nil,
        )

        get :update, token: "valid_token"

        user.reload
        expect(user.email_confirmed_at).to be_present
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq "Successfully confirming your email"
      end
    end
  end
end
