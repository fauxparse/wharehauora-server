# frozen_string_literal: true
class HomesController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :set_home, only: [:show, :edit, :destroy, :update]

  def index
    authorize :home
    @homes = policy_scope(Home)
  end

  def show
    @daysago = params[:since].to_i.day.ago

    @readings = @home.readings.take(10)
    @sensors = policy_scope(Sensor).where(home_id: @home.id)
    @temperature = []
    @humidity = []

    @sensors.each do |sensor|
      name = sensor.room_name ? sensor.room_name : 'unnamed'
      @temperature << { name: name, data: temperature_data(sensor, @daysago) }
      @humidity << { name: name, data: humidity_data(sensor, @daysago) }
    end
  end

  def new
    authorize :home
    @home = Home.new
    @home_types = HomeType.all
  end

  def create
    @home = Home.new(home_params.merge(owner_id: current_user.id))
    authorize @home
    @home.save!
    redirect_to @home
  end

  def edit
    @home_types = HomeType.all
  end

  def update
    @home.update(home_params)
    @home.save!
    redirect_to home_path(@home)
  end

  def destroy
    @home.destroy!
    redirect_to homes_path
  end

  private

  def home_params
    params[:home].permit(permitted_home_params)
  end

  def permitted_home_params
    %i(
      name
      is_public
      home_type_id
    )
  end

  def temperature_data(sensor, daysago)
    time_series Reading.temperature, sensor, daysago
  end

  def humidity_data(sensor, daysago)
    time_series Reading.humidity, sensor, daysago
  end

  def time_series(query, sensor, daysago = 1.day.ago)
    query.where(sensor: sensor)
         .where(['created_at >= ?', daysago])
         .pluck("date_trunc('minute', created_at)", :value)
  end

  def set_home
    @home = policy_scope(Home).find(params[:id])
    authorize @home
  end
end
