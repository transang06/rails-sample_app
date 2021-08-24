class ApplicationController < ActionController::Base
  include SessionsHelper
  around_action :switch_locale

  private
  def switch_locale &action
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end
end
