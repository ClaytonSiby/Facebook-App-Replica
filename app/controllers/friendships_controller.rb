class FriendshipsController < ApplicationController
  include ApplicationHelper

  def create
    # disallow the ability to send a friend request to yourself
    return if current_user.id == params[:user_id]

    # disallow the ability to sent friend requests more than once to the same person
    return if friend_request_sent?(params[:user_id])

    # disallow the ability to send friend request to someone who already sent you one
    return if friend_request_received?(User.find(params[:user_id]))

    @user = User.find(params[:user_id])
    @friendship = current_user.friend_sent.build(sent_to_id: params[:user_id])

    if @friendship.save
      flash[:success] = 'Friend request sent!'

      @notification = new_notification(@user, @current_user.id, 'friendRequest')
      @notification.save
    else
      flash[:danger] = 'Friend Request Failed!'
    end

    redirect_back(fallback_location: root_path)
  end

  def accept_friend
    @friendship = Friendship.find_by(sent_by_id: params[:user_id], sent_to_id: current_user.id, status: false)

    # return if no record is found
    return unless @friendship

    @friendship.status = true

    if @friendship.save
      flash[:success] = 'Friend request accepted!'
      @friendship2 = current_user.friend_sent.build(sent_to_id: params[:user_id], status: true)
      @friendship2.save
    else
      flash[:danger] = 'Friend request could not be accepted!'
    end

    redirect_back(fallback_location: root_path)
  end

  def decline_friend
    @friendship = Friendship.find_by(sent_by_id: params[:user_id], sent_to_id: current_user.id, status: false)
    return unless @friendship

    @friendship.destroy
    flash[:success] = 'Friend request declined!'
    redirect_back(fallback_location: root_path)
  end
end
