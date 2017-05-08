def consolidate_cart(cart)
  new_hash={}
  cart.each_with_index do |product, i|
    product.each do |item, pricing|
     if new_hash[item].nil?
       new_hash[item]=pricing
       new_hash[item][:count] = 1
     else
       new_hash[item][:count] += 1
     end
    end
  end
  new_hash
end


def apply_coupons(cart, coupons)
  coupons.each do |group|
    cart.keys.each do |item|
        if group[:item] == item && group[:num] <= cart[item][:count]
          cart["#{item} W/COUPON"]= {
            :price => group[:cost],
            :clearance => cart[item][:clearance],
            :count => cart[item][:count] / group[:num]
            }
            cart[item][:count]= cart[item][:count] % group[:num]
        end
      end
    end
    cart
end

def apply_clearance(cart)
  cart.keys.each do |item|
    if cart[item][:clearance] == true
      cart[item][:price]=(cart[item][:price]*0.8).round(2)
        end
  end
    cart
end

def checkout(cart, coupons)
  total_cost = 0
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  cart.keys.each do |item|
    total_cost += cart[item][:price]*cart[item][:count]
  end
  if total_cost > 100
    total_cost = (total_cost*0.9).round(2)
  end
  total_cost
end
