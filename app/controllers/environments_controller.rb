class EnvironmentsController < ApplicationController

  before_filter :load_project
  before_filter :load_environment

  def show
  end

  def changes
    @branch = Branch.find(params[:branch_id])
  end

  protected

  def load_project
    @project = Project.find(params[:project_id])
  end

  def load_environment
    @environment = @project.environments.find(params[:id])
  end

end
