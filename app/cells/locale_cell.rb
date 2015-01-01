class LocaleCell < Cell::Rails
  def index
    @locales = Locale.all
    render
  end
end
