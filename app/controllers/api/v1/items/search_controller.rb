class Api::V1::Items::SearchController < ApplicationController
  def index
    if params[:name] != nil && params[:min_price] == nil && params[:max_price] == nil
      items = Item.find_all_items_by_name(params[:name])
      render json: ItemSerializer.new(items), status: :ok
    elsif params[:min_price] != nil && params[:min_price].to_i > 0 && params[:name] == nil && params[:max_price] == nil
      items = Item.find_all_items_by_price(params[:min_price])
      render json: ItemSerializer.new(items), status: :ok
    else
      render json: ItemSerializer.new([]), status: :bad_request
    end
  end
end