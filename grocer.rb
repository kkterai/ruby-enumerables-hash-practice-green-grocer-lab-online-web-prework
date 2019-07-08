def consolidate_cart(cart)
  result = {}

  cart.each do |item_hash|
    item_hash.each do |item, hash|
      if result[item] 
        result[item][:count] += 1
      else
        result[item] = hash
        result[item][:count] = 1
      end
    end
  end
  result
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon_hash|
    if cart["#{coupon_hash[:item]} W/COUPON"] && cart[coupon_hash[:item]][:count] >= coupon_hash[:num]
      cart[coupon_hash[:item]][:count] -= coupon_hash[:num]
      cart["#{coupon_hash[:item]} W/COUPON"][:count] += coupon_hash[:num]
    elsif cart[coupon_hash[:item]] && cart[coupon_hash[:item]][:count] >= coupon_hash[:num]
      cart[coupon_hash[:item]][:count] -= coupon_hash[:num]
      cart["#{coupon_hash[:item]} W/COUPON"] = {
        :price => coupon_hash[:cost]/coupon_hash[:num],
        :clearance => cart[coupon_hash[:item]][:clearance],
        :count => coupon_hash[:num]
      }
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, details|
    if details[:clearance] == true
      details[:price] = (0.8*details[:price]).round(1)
    end
  end
end

def checkout(cart, coupons)
  total = 0
  combined_cart = consolidate_cart(cart)
  combined_coupons = apply_coupons(combined_cart, coupons)
  clearance = apply_clearance(combined_coupons)

  clearance.each do |item, details|
    total += details[:price] * details[:count]
  end
  
  if total > 100
    total = total * 0.9
  end
  total
end
