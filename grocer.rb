require 'pry'

def consolidate_cart(array)
  cart_hash = {}
  array.each { |item_hash|
    number_of_items = 1  
    item_hash.each { |item, info|
     if cart_hash.include?(item)
       number_of_items+=1
     end 
     info[:count] = number_of_items
     cart_hash[item] = info 
    }
  }
  cart_hash
end

def apply_coupons(cart, coupons)
   coupons.each do |coupon_info|
       name = coupon_info[:item]
      if cart[name] 
          if cart["#{name} W/COUPON"]
            cart["#{name} W/COUPON"][:count]+=1 
          else 
            cart["#{name} W/COUPON"] = {count: 1, price: coupon_info[:cost]} 
            cart["#{name} W/COUPON"][:clearance] = cart[name][:clearance]
          end 
          if cart[name][:count] >= coupon_info[:num]
            cart[name][:count]-= coupon_info[:num]
          end 
      end
    end 
    cart 
end

def apply_clearance(cart)
  cart.each { |item_name, item_info|
    if item_info[:clearance] == true  
      item_info[:price]-= (item_info[:price]*0.2)
    end  
  } 
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  #binding.pry 
  cart = apply_clearance(cart)
  total = 0 
  cart.each { |item, item_info|
    total+=item_info[:price]
  }
  if total > 100
    total-=(total*0.1)
  end
  total 
end
