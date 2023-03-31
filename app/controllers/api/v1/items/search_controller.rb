class Api::V1::Items::SearchController < ApplicationController
  def index
    items = Item.find_all_items_by_name(params[:name])
    if items != nil
      render json: ItemSerializer.new(items), status: :ok
    else
      render json: ItemSerializer.new([]), status: :ok
    end
  end
end