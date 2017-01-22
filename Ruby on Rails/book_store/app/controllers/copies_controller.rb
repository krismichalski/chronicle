class CopiesController < ApplicationController
  def change_state
    @copy = Copy.find(params[:id])
    @copy.user_id = params[:user_id] || current_user.id
    @copy.fire_state_event(params[:event].to_sym)
    redirect_to @copy.book
  end

  def prolongate
    @copy = Copy.find(params[:id])
    @copy.user_id = params[:user_id] || current_user.id
    @copy.prolongate
    redirect_to root_path
  end
end
