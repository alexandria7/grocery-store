require "csv"

class Order
  attr_reader :id, :products, :customer, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
    if (@fulfillment_status != :pending && @fulfillment_status != :shipped && @fulfillment_status != :paid && @fulfillment_status != :processing && @fulfillment_status != :complete)
      raise ArgumentError, "That is not a valid fulfillment status."
    end
  end

  def total
    sum = 0
    @products.each_value do |price|
      sum += price
    end
    sum_with_tax = sum + (sum * 0.075)
    return sum_with_tax.round(2)
  end

  def add_product(name, price)
    if @products.include?(name)
      raise ArgumentError, "This product has already been added to the order."
    end
    @products[name] = [price]
  end

  def self.all
    order_array = []
    CSV.open("data/orders.csv", "r").each do |line|
      order_array << Order.new(line[0].to_i, line[1], line[2].to_i, line[3].to_sym)
    end
    return order_array
  end
end
