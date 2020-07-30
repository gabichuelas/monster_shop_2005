class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip

  belongs_to :user
  has_many :item_orders
  has_many :items, through: :item_orders

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def total_quantity
    item_orders.sum('quantity')
  end

  def cancel_items
    item_orders.each do |item_order|
      item_order.update(status: 0)
    end
    update(status: "cancelled")
  end

  def restock
    item_orders.each do |item_order|
      qty = item_order.quantity + item_order.item.inventory
      item_order.item.update(inventory: qty)
      item_order.quantity -= item_order.quantity
    end
  end

  def total_items(merchant)
    merchant.item_orders.where(order_id: self.id).sum(:quantity)
  end

  def total_sum(merchant)
    item_orders.joins(:item).where(items: {merchant_id: merchant.id}).sum('item_orders.quantity * item_orders.price')
  end

  enum status: %w(pending packaged shipped cancelled)
end
