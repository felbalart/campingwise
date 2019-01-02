ActiveAdmin.register Guest do
  menu priority: 7
  permit_params :email, :name, :phone

  controller do
    def index
      index! do |format|
        format.json do
          q = params[:q][:groupings]['0'][:name_contains]
          dummy = Guest.new(id: -rand(1000000000), name: q, email: 'nuevo')
          render json: ([dummy] + collection).as_json(methods: :display_name)
        end
      end
    end
  end
end
