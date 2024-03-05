class Cart < ApplicationRecord
  belongs_to :customer
  has_many :cart_items, dependent: :destroy

  def as_json(options = {})
    super(
      options.merge(
        include: {
          cart_items: {
            include: {
              food_item: {
                include: {
                  vendor_category: {
                    include: %i[vendor category]
                  }
                }
              }
            }
          }
        }
      )
    )
  end
end
