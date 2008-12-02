class PageObject < ActiveRecord::Base
  include ThriveSmartObjectMethods
  self.caching_default = :any_page_update #[in :forever, :page_update, :any_page_update, 'data_update[datetimes]', :never, 'interval[5]']

  belongs_to :accept_list
  
  
  attr_protected :accept_list_id
  # validates_presence_of :accept_list_id  -- Interferes with the code below, when accept_list is a new object
  
  # Pass the buck and actually save the accept_list
  after_update :save_accept_list
  
  # Creates a new accept_list if it doesn't exist for the sent in organization
  def self.new_by_organization_uid(organization_uid, attr_hash)
    accept_list = AcceptList.find_by_organization_uid(organization_uid)
    if accept_list.nil?
      accept_list = AcceptList.new
      accept_list.organization_uid = organization_uid
    end
    new(attr_hash.merge({:accept_list => accept_list}))
  end
  
  def validate
    unless accept_list.valid?
      errors.add(:accept_list, " has an error that must be corrected.")
    end
  end
  
  # Passes the buck of the hash passed in to the actual accept_list model
  def assigned_accept_list=(hash)
    self.accept_list.attributes = hash
  end
  
  protected
    def save_accept_list
      accept_list.save
    end
end
