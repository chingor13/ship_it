class DeployOptionsController < ApplicationController

  before_filter :load_project
  before_filter :load_deploy_option, :only => [:destroy]

  def new
    @deploy_option = @project.deploy_options.build
  end

  def create
    @deploy_option = @project.deploy_options.build(deploy_option_params)
    if @deploy_option.save
      redirect_to edit_project_path(@project)
    else
      render :new
    end
  end

  def destroy
    @deploy_option.destroy
    redirect_to edit_project_path(@project)
  end

  protected

  def load_project
    @project = ShipIt::Project.find(params[:project_id])
  end

  def load_deploy_option
    @deploy_option = @project.deploy_options.find(params[:id])
  end

  def deploy_option_params
    params.require(:deploy_option).permit(:name, :value, :visible)
  end

end
