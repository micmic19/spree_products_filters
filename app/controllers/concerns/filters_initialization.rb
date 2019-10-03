module FiltersInitialization
  extend ActiveSupport::Concern

  included do
    helper_method :param_sorting
  end

  def param_sorting
    params[:sorting].try(:to_sym) || default_sorting
  end

  private

  def default_sorting
    #:descend_by_updated_at
    :descend_by_master_price
  end

  def sorting_scope
    Spree::FiltersConfiguration::Config.allowed_sortings.include?(param_sorting) ? param_sorting : default_sorting
  end

  def filters_init
    params.permit!
    filters_hash = AdvancedFilters.new(params, @products).filter_results.to_h
    @properties         = filters_hash[:properties]
    @product_properties = filters_hash[:product_properties]
    @price_range        = filters_hash[:price_range]
    products            = filters_hash[:products].page(params[:page]).
                            per(params[:per_page] || Spree::Config[:products_per_page])
    @products = if sorting_scope.to_s.include?('price')
                  products.select('spree_products.*', 'spree_prices.amount').send(sorting_scope)
                else
                  products.send(sorting_scope)
                end
    if params[:controller] == 'spree/taxons' && params[:action] == 'show'
      @option_types = filters_hash[:option_types]
    end
  end
end
