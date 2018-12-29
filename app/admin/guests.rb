ActiveAdmin.register Guest do
  permit_params :email, :name, :phone

  controller do
    def index
      index! do |format|
        format.json do
          q = params[:q][:groupings]['0'][:name_contains]
          dummy = Guest.new(id: -1, name: q, email: 'nuevo')
          render json: ([dummy] + collection).as_json(methods: :display_name)
        end
      end
    end
  end
end
