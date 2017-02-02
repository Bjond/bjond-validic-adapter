class BjondValidicUserConversionController < ApplicationController

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
  end

  private

    # Only allow a trusted parameter "white list" through.
    def validic_configuration_params
      params.require(:validic_configuration).permit(:api_key, :secret

end
