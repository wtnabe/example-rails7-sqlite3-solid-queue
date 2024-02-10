class IndexController < ApplicationController
  skip_forgery_protection

  def index
  end

  def new
    length = params[:length].to_i

    StoreRandomContentsJob.perform_later(length)
  end
end
