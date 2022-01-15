class EventsController < ApplicationController
  def new
    @user = User.find(params[:user_id])
    # ユーザーが一致しなければ、自分のマイページに戻る
    redirect_to user_path(current_user) unless @user == current_user
    @event = Event.new
    @my_events = @user.events.all
  end

  def create
    @user = User.find(params[:user_id])
    @event = Event.new(event_params)
    if @event.save
      redirect_to new_user_event_path(@user)
    else
      render 'new'
    end
  end

  def destroy
    user = params[:user_id]
    event = Event.find(params[:id])
    event.destroy
    redirect_to new_user_event_path(user)
  end

  private
  def event_params
    params.require(:event).permit(:user_id, :name, :start_date, :end_date)
  end
end
