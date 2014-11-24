require 'const'

class WorkTableController < ApplicationController
  def index
    # Constantの設定
    gon.const  = const_values(Const, {})
  end

  def const_values(const_class, obj)
    const_class.constants.each do |c|
      v = const_class.const_get(c)
      if v.is_a? Class
        obj[c] = const_values(v, {})
      else
        obj[c] = v
      end
    end
    return obj
  end
end
