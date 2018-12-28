ActiveAdmin.register Order do
  permit_params controller.resource_class.new.attributes.symbolize_keys.keys
end
