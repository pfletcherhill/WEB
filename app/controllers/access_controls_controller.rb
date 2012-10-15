class AccessControlsController < ApplicationController
  def create
    @access_control = AccessControl.new(params[:access_control])
    if @access_control.save
      redirect_to "/admin/teams/#{@access_control.team_id}"
    end
  end
end
