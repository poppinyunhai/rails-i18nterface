# encoding: utf-8

module RailsI18nterface
  module UseKeyForMissing
    def call(exception, locale, key, options)
      if exception.is_a?(I18n::MissingTranslation)
        ("\x00" + key.to_s.split(/\./)[-1] + "\x0b").html_safe
      else
        super
      end
    end
  end
end

I18n.exception_handler.extend RailsI18nterface::UseKeyForMissing
