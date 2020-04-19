class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def show
    #idによって、DBからマッチするレコードを取得する
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  #登録処理を行う
  def create
    @task = Task.new(task_params)
    #DBへ保存
    if @task.save
    #リダイレクト処理
      redirect_to @task, notice: "タスク「#{@task.name}」を登録しました。"
    else
      render :new
    end
  end

  #受信したデータと一致するデータを検索し、編集画面へ表示する
  def edit
    @task = Task.find(params[:id])
  end

  #更新処理を行う
  def update
    task = Task.find(params[:id])
    #正常データのみを抽出し、DBを更新
    task.update!(task_params)
    redirect_to tasks_url, notice: "タスク「#{task.name}」を更新しました。"
  end

  #削除処理を行う
  def destroy
    task = Task.find(params[:id])
    task.destroy
    redirect_to tasks_url, notice: "タスク「#{task.name}」を削除しました。"
  end

  # ここから下はプライベートメソッド
  private

  # Strong Parametersという仕組み(不正データが登録・更新されることを防ぐ)を使用している
  def task_params
    params.require(:task).permit(:name, :description)
  end
end
