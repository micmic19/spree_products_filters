Spree::TaxonsController.class_eval do
  include FiltersInitialization

  def show
    @taxon = Spree::Taxon.friendly.find(params[:id])
    return unless @taxon

    @searcher   = build_searcher(taxxon_params.to_h.merge(taxon: @taxon.id, include_images: true))
    @products   = @searcher.custom_retrieve_products
    @taxonomies = Spree::Taxonomy.includes(root: :children)

    filters_init
  end

  private
  def taxxon_params
    params.require(:taxon).permit(:taxon, :include_images)
  end
end
