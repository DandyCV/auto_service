module Admin
  class InquiriesController < ApplicationController
    PER_PAGE = 20

    before_action :require_admin!
    before_action :set_inquiry, only: [ :edit, :update, :destroy ]

    layout "admin"

    def index
      @filters = filter_params.to_h.symbolize_keys
      scope = filtered_inquiries

      @current_page = normalized_page
      @total_inquiries = scope.count
      @total_pages = [ (@total_inquiries.to_f / PER_PAGE).ceil, 1 ].max

      @inquiries = scope
        .order(created_at: :desc)
        .offset((@current_page - 1) * PER_PAGE)
        .limit(PER_PAGE)
    end

    def edit
    end

    def update
      if @inquiry.update(inquiry_params)
        redirect_to admin_inquiries_path, notice: "Request updated successfully."
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      @inquiry.destroy
      redirect_to admin_inquiries_path(redirect_filter_params), notice: "Request deleted successfully."
    end

    private

    def set_inquiry
      @inquiry = Inquiry.find(params[:id])
    end

    def inquiry_params
      params.require(:inquiry).permit(:name, :phone, :inquiry_type, :comment)
    end

    def filter_params
      params.permit(:id, :name, :phone, :inquiry_type, :issue)
    end

    def filtered_inquiries
      scope = Inquiry.all

      if @filters[:id].present?
        scope = scope.where(id: @filters[:id].to_i)
      end

      if @filters[:name].present?
        scope = scope.where("name LIKE ?", contains_query(@filters[:name]))
      end

      if @filters[:phone].present?
        scope = scope.where("phone LIKE ?", contains_query(@filters[:phone]))
      end

      if @filters[:inquiry_type].present?
        scope = scope.where(inquiry_type: @filters[:inquiry_type])
      end

      if @filters[:issue].present?
        scope = scope.where("comment LIKE ?", contains_query(@filters[:issue]))
      end

      scope
    end

    def contains_query(value)
      "%#{ActiveRecord::Base.sanitize_sql_like(value.to_s.strip)}%"
    end

    def normalized_page
      page = params[:page].to_i
      page.positive? ? page : 1
    end

    def redirect_filter_params
      request.query_parameters.slice("page", "id", "name", "phone", "inquiry_type", "issue")
    end
  end
end
