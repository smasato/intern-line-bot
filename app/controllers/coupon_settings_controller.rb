class CouponSettingsController < ApplicationController
  before_action :set_coupon_setting, only: [:show, :edit, :update, :destroy]

  # GET /coupon_settings
  def index
    @coupon_settings = CouponSetting.all
  end

  # GET /coupon_settings/1
  def show
  end

  # GET /coupon_settings/new
  def new
    @coupon_setting = CouponSetting.new
  end

  # GET /coupon_settings/1/edit
  def edit
  end

  # POST /coupon_settings
  def create
    @coupon_setting = CouponSetting.new(coupon_setting_params)
    @coupon_setting.thumbnail = coupon_setting_params[:thumbnail].read

    respond_to do |format|
      if @coupon_setting.save
        format.html { redirect_to @coupon_setting, notice: 'CouponSetting was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /coupon_settings/1
  def update
    respond_to do |format|
      if @coupon_setting.update(coupon_setting_params)
        format.html { redirect_to @coupon_setting, notice: 'CouponSetting was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /coupon_settings/1
  def destroy
    @coupon_setting.destroy
    respond_to do |format|
      format.html { redirect_to coupon_settings_url, notice: 'CouponSetting was successfully destroyed.' }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_coupon_setting
    @coupon_setting = CouponSetting.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def coupon_setting_params
    params.require(:coupon_setting).permit(:item_id, :status, :name, :message, :thumbnail)
  end

end

