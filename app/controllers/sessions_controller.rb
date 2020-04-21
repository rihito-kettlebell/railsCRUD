class SessionsController < ApplicationController
  def new
  end

  def create
    #送られてきたメルアドでユーザー検索
    user = User.find_by(email: session_params[:email])

    #authenticateメソッドは、認証のためのメソッド、
    #引数で受け取ったパスワードをハッシュ化し、その結果がUserオブジェクト内部に保存されているdigestと一致するかどうかを調べる
    if user&.authenticate(session_params[:password])
      #セッションに格納
      session[:user_id] = user.id
      redirect_to root_path, notice: 'ログインしました。'
    else
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: 'ログアウトしました。'
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end

end
