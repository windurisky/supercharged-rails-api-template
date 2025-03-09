class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  private

  def generate_uuid_v7
    return if self.class.attribute_types["id"].type != :uuid

    self.id ||= SecureRandom.uuid_v7
  end
end
