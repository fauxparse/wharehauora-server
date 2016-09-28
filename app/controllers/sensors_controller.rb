# frozen_string_literal: true
class SensorsController < WebController
  before_action :authenticate_user!
  def index
    @sensors = policy_scope(Sensor)
  end

  def show
    @sensor = Sensor.find(params[:id])
    authorize @sensor
  end

  def destroy
    # sensor = Sensor.find(params[:id])
    # authorize sensor
    # sensor.destroy!
    # redirect_to sensor.room.home
  end

  def update
    sensor = Sensor.find(params[:id])
    authorize sensor
    sensor.update(sensor_params)
    sensor.save!
    redirect_to sensor.home
  end

  private

  def sensor_params
    params[:sensor].permit(permitted_sensor_params)
  end

  def permitted_sensor_params
    %i(
      room_id
    )
  end
end
