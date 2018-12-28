ActiveAdmin.register Reserve do
  permit_params controller.resource_class.new.attributes.symbolize_keys.keys
end
