class EventsController < ApplicationController
  before_action :authenticate_user!

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
    # 終了日が開始日より前の日付になっていれば、render + フラッシュメッセージを出して処理を途中でストップ
    @start_date = event_params[:start_date].to_date
    @end_date = event_params[:end_date].to_date
    if start_end_wrong?
      flash[:range_error] = "日付範囲が正しく指定されていません"
      @my_events = @user.events.all
      render 'new'
      return
    end
    if @event.save
      redirect_to new_user_event_path(@user)
    else
      @my_events = @user.events.all
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:user_id])
    # ユーザーが一致しなければ、自分のマイページに戻る
    redirect_to user_path(current_user) unless @user == current_user
    @event = Event.find(params[:id])
  end

  def update
    @user = User.find(params[:user_id])
    @event = Event.find(params[:id])
    # 終了日が開始日より前の日付になっていれば、render + フラッシュメッセージを出して処理を途中でストップ
    @start_date = event_params[:start_date].to_date
    @end_date = event_params[:end_date].to_date
    if start_end_wrong?
      flash[:range_error] = "日付範囲が正しく指定されていません"
      render 'edit'
      return
    end
    if @event.update(event_params)
      redirect_to new_user_event_path(@user)
    else
      render 'edit'
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

  def start_end_wrong?
    # エラー内容：　きちんと開始日と終了日が送信されているが、「終了日が開始日より前の日付になっている」
    @start_date.present? && @end_date.present? && @end_date < @start_date
  end
end
