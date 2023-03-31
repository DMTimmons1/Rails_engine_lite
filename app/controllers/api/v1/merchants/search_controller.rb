class Api::V1::Merchants::SearchController < ApplicationController
  def index
    merchant = Merchant.find_merchant_by_name(params[:name])
    if merchant != nil
      render json: MerchantSerializer.new(merchant), status: :ok
    else
      render json: MerchantSerializer.new(Merchant.new), status: :ok
    end
  end
end