class DeploymentsController < ApplicationController

  before_filter :load_project, only: [:create, :show, :log, :terminate]
  before_filter :load_environment, only: [:create, :show, :log, :terminate]
  before_filter :load_deployment, only: [:show, :log, :terminate]
  before_filter :build_deployment, only: [:create]

  def show
  end

  def log
    content = ""
    offset = params.fetch(:offset) || 0

    if @deployment.log_file
      f = File.open(@deployment.log_file, "r")
      f.seek(offset.to_i)
      content = f.read
    end

    response.headers["X-Log-Complete"] = "1" if @deployment.completed?
    response.headers["X-Log-Length"] = content.length.to_s
    render :text => content
  end

  def create
    if @deployment.save
      redirect_to [@project, @deployment.environment, @deployment]
    else
      render :new
    end
  end
  
  def terminate
    @deployment.terminate!
    
    respond_to do |format|
      format.js { render :text => '' }
    end
  end

  def in_progress
    respond_to do |format|
      format.js
    end
  end

  protected

  def load_project
    @project = Project.find(params[:project_id])
  end

  def load_environment
    @environment = @project.environments.find(params[:environment_id])
  end

  def load_deployment
    @deployment = @environment.deployments.find(params[:id])
  end

  def build_deployment
    @deployment = @environment.deployments.build(deployment_params)
  end

  def deployment_params
    deployment_params = params.require(:deployment).permit(:branch_id, :environment, :started_at, :log_file, :finished_at, :success, :revision, :user_terminated)
  end

end
