Spree::ProductsHelper.class_eval do
  def cache_key_for_products
    count    = @products.count
    first_id = @products.any? ? @products.first.id : nil
    sorting  = params[:sorting]
    "#{I18n.locale}/#{current_currency}/spree/products/all-#{params[:page]}-#{first_id}-#{sorting}-#{count}"
  end

  def link_to_sort(key)
    if current_sorting?(key)
      klass = 'btn btn-primary btn-sm'
    else
      klass = 'btn btn-default btn-sm'
    end
    # params.permit!
    # link_to Spree.t(key).html_safe, params.permit({ :filters => [[[]]] }, { :filters => [[]] },  :types, :filters, { :filters => [] }, :commit, :sorting, :utf8, :page).merge(sorting: key), class: klass
    # link_to Spree.t(key).html_safe, params.merge(sorting: key), class: klass
    link_to Spree.t(key).html_safe, params.permit(:types, :filters, :commit, :sorting, :utf8, :page,
filters: [
  :max_price_range,
  :min_price_range,
  { properties: [
    :types
  ]
 }
]
      ).merge(sorting: key), class: klass
  end

  def current_sorting?(key)
    param_sorting == key.to_sym
  end

  def filter_checked?(keys, value)
    (params[:filters][keys[0]].present? && params[:filters][keys[0]][keys[1]].include?(value)) ? true : false
  end
end
