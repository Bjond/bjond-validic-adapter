class ValidicConfigurationsController < ApplicationController
  before_action :set_validic_configuration, only: [:show, :edit, :update, :destroy]

  def show
  end

  def edit
  end

  def update
    if @validic_configuration.update(validic_configuration_params)
      redirect_to @validic_configuration, notice: 'Bjönd registration was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @validic_configuration.destroy
    redirect_to bjond_registrations_url, notice: 'validic Configuration was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_validic_configuration
      @validic_configuration = ValidicConfiguration.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def validic_configuration_params
      params.require(:validic_configuration).permit(:api_key, :secret, :sample_person_id)
    end

end
