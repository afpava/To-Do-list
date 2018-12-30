class TasksController < ApplicationController
  before_action :set_task, only: [:destroy, :edit, :update, :complete]
  #before_action :authorize, only: [:edit, :update, :destroy]
  before_action :authorize_admin, only: [:update, :edit]

  def edit
    @birthdays = User.birthdays_this_month.sort_by{|p| p.birth_date.day}
  end

  def create
    @user = User.find(params[:user_id])
    @task = @user.tasks.create(task_params)


    if @task.save
      redirect_to root_path, notice: 'task was successfully created.'
    else
      redirect_to root_path, alert: 'task was not created. Title and text could not be blank'
    end
  end

  #PATCH/user_id/id/
  def complete
    # binding.pry
   @task.update_attribute(:completed, params[:completed])

   params[:completed] == "true" ? (redirect_to root_path, notice: "Todo item completed") : (redirect_to root_path, notice: "Todo item unchecked")
  end

  # PATCH/PUT /stores/1
  # PATCH/PUT /stores/1.json
  def update
    if @task.update(task_params)
      redirect_to root_path, notice: 'task was successfully updated.'
    else
      render :edit
    end
  end


  # DELETE /stores/1
  # DELETE /stores/1.json
  def destroy
    @task.destroy
    redirect_to root_path, notice: 'task was successfully destroyed.'
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @user = User.find(params[:user_id])
    @task = @user.tasks.find(params[:id])

  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def task_params
    params.require(:task).permit(:title, :text, :priority)
  end

end
