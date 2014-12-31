class LocaleCell < Cell::Rails
  def index
    @locales = Locale.all
  end
end
