class Item < ApplicationRecord
  belongs_to :merchant

  def self.find_all_items_by_name(params)
    where("name ILIKE ?", "%#{params}%")
  end
end