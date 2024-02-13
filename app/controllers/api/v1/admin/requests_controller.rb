class Api::V1::Admin::RequestsController < Api::V1::Admin::BaseController

  def list_of_requests
   @requests =  case params['status']
                when 'approved' 
                  Vendor.approved
                when 'rejected'
                  Vendor.rejected
                when 'pending'
                  Vendor.pending
                else
                  Vendor.all
                end
    render json: { requests: @requests, message: "Requests has been fetched successfully."}, status: :ok
  end

  def approve_request
    vendor = Vendor.find_by_id(request_params[:vendor_id])
    return render json: { message: "Vendor not found"}, status: :not_found unless vendor

    if vendor.update(status: "approved")
      update_vendor_categories(vendor)
      render json: { message: "#{vendor.first_name}'s request has been approved"}, status: :ok
    else
      render json: { message: "Something went wrong, Please try again"}, status: :unprocessable_entity
    end
  end

  def reject_request
    vendor = Vendor.find_by_id(params[:vendor_id])
    return render json: { message: "Vendor not found"}, status: :not_found unless vendor

    if vendor.update(status: "rejected")
      render json: { message: "#{vendor.first_name}'s request has been rejected"}, status: :ok
    else
      render json: { message: "Something went wrong, Please try again"}, status: :unprocessable_entity
    end
  end

  private

  def request_params
    params.permit(:vendor_id)
  end

  def update_vendor_categories(vendor)
    category_ids = vendor.type_of_categories.map { |category| Category.find_by(name: category)&.id }.compact
    vendor.category_ids = category_ids if category_ids.present?
  end
end