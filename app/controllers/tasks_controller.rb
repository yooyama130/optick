class TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = User.find(params[:user_id])
    # ユーザーが一致しなければ、自分のマイページに戻る（メソッドが実行されれば、その後の処理はさせない）
    return if ensure_user(@user)
    # 検索キーワードがあれば、あいまい検索で取得してくる
    keyword = params[:keyword]
    if keyword.present?
      @my_tasks = @user.tasks.where("content LIKE ?", "%#{keyword}%")
    else
      @my_tasks = @user.tasks.all
    end
  end

  # フォーム画面でエラーメッセージが出たときに更新するとエラー出るのを防止（route.rb参照）
  def show
    redirect_back(fallback_location: root_path)
  end

  def new
    @user = User.find(params[:user_id])
    # ユーザーが一致しなければ、自分のマイページに戻る（メソッドが実行されれば、その後の処理はさせない）
    return if ensure_user(@user)
    @new_task = Task.new
  end

  def create
    @user = User.find(params[:user_id])
    # ユーザーが一致しなければ、自分のマイページに戻る（メソッドが実行されれば、その後の処理はさせない）
    return if ensure_user(@user)
    @new_task = Task.new(task_params)
    if @new_task.save
      redirect_to user_tasks_path
    else
      @user = User.find(params[:user_id])
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:user_id])
    # ユーザーが一致しなければ、自分のマイページに戻る（メソッドが実行されれば、その後の処理はさせない）
    return if ensure_user(@user)
    @task = Task.find(params[:id])
  end

  def update
    @user = User.find(params[:user_id])
    # ユーザーが一致しなければ、自分のマイページに戻る（メソッドが実行されれば、その後の処理はさせない）
    return if ensure_user(@user)
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to user_tasks_path
    else
      @user = User.find(current_user.id)
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    # ユーザーが一致しなければ、自分のマイページに戻る（メソッドが実行されれば、その後の処理はさせない）
    return if ensure_user(@user)
    task = Task.find(params[:id])
    task.destroy
    redirect_to user_tasks_path
  end

  def destroy_icon
    user = User.find(params[:user_id])
    # ユーザーが一致しなければ、自分のマイページに戻る（メソッドが実行されれば、その後の処理はさせない）
    return if ensure_user(user)
    task = Task.find(params[:id])
    # 画像削除の方法は、画像idに nil を代入する
    task.update(icon_image_id: nil)
    redirect_to edit_user_task_path(user, task)
  end

  private

  def task_params
    params.require(:task).permit(:user_id, :icon_image, :content)
  end
end
