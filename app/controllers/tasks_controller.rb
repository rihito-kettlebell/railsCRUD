class TasksController < ApplicationController
  def index
  end

  def show
    @task = Task.new
  end

  def new
  end

  def create
    task = Task.new(task_params)
    #DBへ保存
    task.save!
    #リダイレクト処理
    redirect_to tasks_url, notice: "タスク「#{task.name}」を登録しました。"
  end

  def editgit 
  end

  # ここから下はプライぺーとメソッド
  private

  # Strong Parametersという仕組み(不正データが登録・更新されることを防ぐ)を使用している
  def task_params
    params.require(:task).permit(:name, :description)
  end
end
