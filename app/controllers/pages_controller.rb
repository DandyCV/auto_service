class PagesController < ApplicationController
  def home
    @inquiry = Inquiry.new
  end

  def about; end

  def services; end

  def contacts
    @inquiry = Inquiry.new
  end

  def privacy; end
end
