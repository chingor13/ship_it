class ProjectsController < ApplicationController

  before_filter :load_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = Project.all
  end
  
  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to @project
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @project.update_attributes(project_params)
      redirect_to @project
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path
  end

  protected

  def project_params
    params.require(:project).permit(:name, :git_repo_url)
  end

  def load_project
    @project = Project.find(params[:id])
  end

end
