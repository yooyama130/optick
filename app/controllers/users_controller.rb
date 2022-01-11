class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  def destroy_image
    user = User.find(params[:id])
    # 画像削除の方法は、画像idに nil を代入する
    user.update(profile_image_id: nil)
    redirect_to edit_user_path(user)
  end

  private
  def user_params
    params.require(:user).permit(:email, :profile_image, :name)
  end
end
