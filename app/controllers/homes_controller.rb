class HomesController < ApplicationController
  def top
  end

  def about
  end

  # 代入をせず、前回代入したもの保持したいケースもあるのでメソッドの外でクラス変数として定義
  @@prev_url = nil
  def change_language
    # ダブルクリックすると『リダイレクトが繰り返されます』となるので、
    # （原因：ダブルクリックする　＝　直前のURLがchange_languageとみなされ、無限ループ）
    # 直前のURLがこのアクションでなければ、クラス変数prev_urlに代入するようにする
    @@prev_url = request.referer unless request.referer.include?("/change_language/")
    session[:locale] = params[:language]
    redirect_to @@prev_url
  end
end
