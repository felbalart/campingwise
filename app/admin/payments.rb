ActiveAdmin.register Payment do
  permit_params controller.resource_class.new.attributes.symbolize_keys.keys
end
