class UsersController < ApplicationController
  before_action :authenticate_user! # Ensure only authorized users can manage users
  before_action :ensure_admin, only: [:toggle_admin, :destroy]

  def index
    @users = User.all
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to userist_path, notice: 'User was successfully deleted.'
  end

  def toggle_admin
    user = User.find(params[:id])
    user.update(admin: !user.admin)
    redirect_to userist_path, notice: "#{user.email} is now #{user.admin? ? 'an Admin' : 'a regular user'}."
  end

  def invite
    email = params[:email]
    user = User.find_by(email: email)

    if user
      flash[:alert] = "A user with this email already exists."
    else
      # Generate an invitation token
      token = SecureRandom.hex(10)
      invite_url = "#{root_url}/users/sign_up?invitation_token=#{token}"

      # Send the email
      InvitationMailer.invite_email(email, invite_url).deliver_now

      # Optionally, store the token in the database
      Invitation.create!(email: email, token: token, used: false)

      flash[:notice] = "Invitation sent to #{email}."
    end

    redirect_to users_path
  end

  private

  def ensure_admin
    redirect_to root_path, alert: "Access denied." unless current_user.admin?
  end
end
