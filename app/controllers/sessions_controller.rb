class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # ユーザーログイン後にユーザー情報ページへリダイレクトする
    else
      flash[:danger] = 'Invalid email/password combination' # 本当は正しくないもの
      render 'new'
    end
  end

  def destroy
  end
end
