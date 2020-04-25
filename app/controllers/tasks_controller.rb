class TasksController < ApplicationController
  #指定したメソッドの処理を共通化できる
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  def index
    #Task.where(user_id: current_user.id)
    @tasks = current_user.tasks.order(created_at: :desc)
  end

  def show
    #idによって、DBからマッチするレコードを取得する
  end

  def new
    @task = Task.new
  end

  #登録処理を行う
  def create
    @task = current_user.tasks.new(task_params)
    #DBへ保存
    if @task.save
      #ログの出力を設定
      logger.debug "タスクデバッグtask: #{@task.attributes.inspect}"
    #リダイレクト処理
      redirect_to @task, notice: "タスク「#{@task.name}」を登録しました。"
    else
      render :new
    end
  end

  #受信したデータと一致するデータを検索し、編集画面へ表示する
  def edit
  end

  #更新処理を行う
  def update
    #
    #正常データのみを抽出し、DBを更新
    @task.update!(task_params)
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を更新しました。"
  end

  #削除処理を行う
  def destroy
    #
    @task.destroy
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を削除しました。"
  end

  # ここから下はプライベートメソッド
  private

  # Strong Parametersという仕組み(不正データが登録・更新されることを防ぐ)を使用している
  def task_params
    params.require(:task).permit(:name, :description)
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end
end
