class TasksController < ApplicationController
  #指定したメソッドの処理を共通化できる
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  def index
    @q = current_user .tasks.ransack(params[:q])
    @tasks = @q.result(distinct: true)

    respond_to do |format|
      format.html
      format.csv { send_data @tasks.generate_csv, filename: "tasks-#{Time.zone.now.strftime('%Y%m%d%S')}.csv" }
    end
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

    #戻る機能の追加
    if params[:back].present?
      render :new
      return
    end

    #DBへ保存
    if @task.save
      TaskMailer.creation_email(@task).deliver_now
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

  #オリジナルのロガーの作成メソッド
  # def task_logger
  #   @task_logger ||= Logger.new('log/task.log', 'daily')
  # end

  # task_logger.debug 'taskのログを出力'

  #　確認画面表示
  def confirm_new
    @task = current_user.tasks.new(task_params)
    render :new unless @task.valid?
  end

  # ここから下はプライベートメソッド
  private

  # Strong Parametersという仕組み(不正データが登録・更新されることを防ぐ)を使用している
  def task_params
    params.require(:task).permit(:name, :description, :image)
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end
end
