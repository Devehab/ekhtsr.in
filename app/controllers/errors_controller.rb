class ErrorsController < ApplicationController
  layout 'errors'

  def page_not_found
  end

  def unprocessable
  end

  def internal_server_error
  end
end
