class LocaleCell < Cell::Rails
  def index
    @locales = Locale.all.order(:order)
    render
  end
end
