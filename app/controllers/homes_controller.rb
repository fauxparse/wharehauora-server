# frozen_string_literal: true
class HomesController < ApplicationController
  before_action :authenticate_user!

  def index
    @homes = policy_scope(Home)
  end

  def show
    @home = Home.find(params[:id])
    authorize @home
  end
end
