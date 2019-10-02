Spree::TaxonsController.class_eval do
  include FiltersInitialization

  def show
    @taxon = Spree::Taxon.friendly.find(params[:id])
    return unless @taxon

    @searcher   = build_searcher(params.merge(taxon: @taxon.id, include_images: true).permit(:taxon, :include_images))
    @products   = @searcher.custom_retrieve_products
    @taxonomies = Spree::Taxonomy.includes(root: :children)

    filters_init
  end
end
