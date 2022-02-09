class EventsController < ApplicationController
  before_action :authenticate_user!

  # フォーム画面でエラーメッセージが出たときに更新するとエラー出るのを防止（route.rb参照）
  def index
    redirect_back(fallback_location: root_path)
  end

    # フォーム画面でエラーメッセージが出たときに更新するとエラー出るのを防止（route.rb参照）
  def show
    redirect_back(fallback_location: root_path)
  end

  def new
    @user = User.find(params[:user_id])
    # ユーザーが一致しなければ、自分のマイページに戻る（メソッドが実行されれば、その後の処理はさせない）
    return if ensure_user(@user)
    @event = Event.new
    @my_events = @user.events.all
  end

  def create
    @user = User.find(params[:user_id])
    # ユーザーが一致しなければ、自分のマイページに戻る（メソッドが実行されれば、その後の処理はさせない）
    return if ensure_user(@user)
    @event = Event.new(event_params)
    # 終了日が開始日より前の日付になっていれば、render + フラッシュメッセージを出して処理を途中でストップ
    @start_date = event_params[:start_date].to_date
    @end_date = event_params[:end_date].to_date
    if start_end_wrong?(@start_date, @end_date)
      flash.now[:date_range_error] = t("flash.date_range_error")
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
    # ユーザーが一致しなければ、自分のマイページに戻る（メソッドが実行されれば、その後の処理はさせない）
    return if ensure_user(@user)
    @event = Event.find(params[:id])
  end

  def update
    @user = User.find(params[:user_id])
    # ユーザーが一致しなければ、自分のマイページに戻る（メソッドが実行されれば、その後の処理はさせない）
    return if ensure_user(@user)
    @event = Event.find(params[:id])
    # 終了日が開始日より前の日付になっていれば、render + フラッシュメッセージを出して処理を途中でストップ
    @start_date = event_params[:start_date].to_date
    @end_date = event_params[:end_date].to_date
    if start_end_wrong?(@start_date, @end_date)
      flash.now[:date_range_error] = t("flash.date_range_error")
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
    user = User.find(params[:user_id])
    # ユーザーが一致しなければ、自分のマイページに戻る（メソッドが実行されれば、その後の処理はさせない）
    return if ensure_user(user)
    event = Event.find(params[:id])
    event.destroy
    redirect_to new_user_event_path(user)
  end

  private

  def event_params
    params.require(:event).permit(:user_id, :name, :start_date, :end_date)
  end

  def start_end_wrong?(start_date, end_date)
    # エラー内容：　きちんと開始日と終了日が送信されているが、「終了日が開始日より前の日付になっている」
    start_date.present? && end_date.present? && end_date < start_date
  end
end
