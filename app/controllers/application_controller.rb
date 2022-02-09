class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  # ログイン後の遷移先
  def after_sign_in_path_for(resource)
    user_path(resource)
  end

  # ユーザーが一致しなければ、自分のマイページに戻る
  def ensure_user(user)
    if !(user == current_user)
      flash[:ensure_user] = t('flash.ensure_user')
      redirect_to user_path(current_user)
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  # セッション変数がnilでないときには代入せず、前回代入されたものを使いたいので、メソッドの外でクラス変数として定義
  @@locale = nil
  def set_locale
    if !session[:locale].nil?
      # セッション変数ががnilでないときには、クラス変数に代入して都度更新する。
      @@locale = session[:locale]
    else
      # セッション変数がnilのときには、セッション変数にクラス変数（前回代入されたもの）を入れてあげる。
      session[:locale] = @@locale
    end
    # %w で配列を定義する
    # ja か en、どちらかに一致したら18n.localeに代入する、
    if %w(ja en).include?(session[:locale])
      I18n.locale = session[:locale]
    end
  end
end
