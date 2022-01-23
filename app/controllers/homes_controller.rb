class HomesController < ApplicationController
  def top
  end

  def about
  end

  def change_language
   session[:locale] = params[:language]
   redirect_back(fallback_location: root_path)
  end
end
