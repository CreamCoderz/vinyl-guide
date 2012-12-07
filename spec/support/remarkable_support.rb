#patch to make remarkable work with Rails 3.9(?).. submit a pull request
ActiveRecord::Reflection::AssociationReflection.class_eval do
  alias_method :primary_key_name, :foreign_key unless respond_to?(:primary_key_name)
end