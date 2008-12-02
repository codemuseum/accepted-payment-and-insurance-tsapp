class AcceptList < ActiveRecord::Base
  DEFAULT_HEADER = 'Accepted Forms of Payment & Insurance'
  
  DEFAULT_PAYMENT_TYPES = [
    { :name => 'Cash', :description => 'Cash', :link => nil, :icon => 'cash.png' },
    { :name => 'Checks', :description => 'Personal Checks', :link => nil, :icon => 'checks.png' },
    { :name => 'Visa', :description => 'The Visa Credit Card', :link => 'http://www.visa.com', :icon => 'visa.png' },
    { :name => 'MasterCard', :description => 'The MasterCard Credit Card', :link => 'http://www.mastercard.com/', :icon => 'mc.png' },
    { :name => 'American Express', :description => 'The American Express Credit Card', :link => 'http://www.americanexpress.com/', :icon => 'amex.png' },
    { :name => 'Discover', :description => 'The Discover Credit Card', :link => 'http://www.discovercard.com/', :icon => 'discover.png' },
    { :name => 'Debit', :description => 'Debit Cards', :link => nil, :icon => 'debit.png' },
    { :name => 'PayPal', :description => 'PayPal Online Payment', :link => 'http://www.paypal.com/', :icon => 'paypal.png' },
    { :name => 'Google Checkout', :description => 'Google Checkout Online Payment', :link => 'http://checkout.google.com', :icon => 'googlecheckout.png' }
  ]
  
  DEFAULT_INSURANCE_TYPES = [
    { :name => 'Aetna', :description => 'Aetna, Inc.', :link => 'http://www.aetna.com', :icon => 'aetna.png' },
    { :name => 'Anthem Blue Cross', :description => 'Anthem Blue Cross Health Insurance', :link => 'http://www.anthem.com', :icon => 'bluecross.png' },
    { :name => 'Blue Cross', :description => 'Blue Shield Health Insurance', :link => 'http://www.blueshield.com', :icon => 'bluecross.png' },
    { :name => 'Cigna', :description => 'Cigna Health Insurance', :link => 'http://www.cigna.com', :icon => 'cigna.png' },
    { :name => 'Delta Dental', :description => 'Delta Dental Insurance', :link => 'http://www.deltadental.com', :icon => 'deltadental.png' },
    { :name => 'Eye Care Network', :description => 'The Discount Vision Program (DVP) Network', :link => 'http://www.ecndiscount.com', :icon => 'eyecare-network.png' },
    { :name => 'EyeMed', :description => 'EyeMed Vision Care Insurance', :link => 'http://www.eyemedvisioncare.com', :icon => 'eyemed.png' },
    { :name => 'HealthNet', :description => 'HealthNet Health Insurance', :link => 'http://www.healthnet.com', :icon => 'health-net.png' },
    { :name => 'Medicare', :description => 'Medicare Insurance', :link => 'http://www.medicare.gov', :icon => 'medicare.png' },
    { :name => 'Medi-Cal', :description => 'Medi-Cal Insurance', :link => 'http://www.medi-cal.ca.gov', :icon => 'medi-cal.png' },
    { :name => 'MESVision', :description => 'Medical Eye Services Vision Insurance', :link => 'http://www.mesvision.com', :icon => 'mes-vision.png' },
    { :name => 'PacifiCare', :description => 'PacifiCare Insurance', :link => 'http://www.pacificare.com', :icon => 'pacificare.png' },
    { :name => 'Superior Vision', :description => 'Superior Vision Managed Vision Care Insurance', :link => 'http://www.superiorvision.com', :icon => 'superior-vision.png' },
    { :name => 'Tricare', :description => 'Tricare Military Health Insurance', :link => 'http://www.tricare.mil', :icon => 'tricare.png' },
    { :name => 'UHC', :description => 'UnitedHealthcare Insurance', :link => 'http://www.uhc.com', :icon => 'uhc.png' },
    { :name => 'VSP', :description => 'Vision Service Plan Insurance', :link => 'http://www.vsp.com', :icon => 'vsp.png' }
  ]
  
  
  has_many :page_objects
  serialize :payment_types, Array
  serialize :insurance_types, Array
  
  
  attr_protected :organization_uid
  validates_presence_of :organization_uid
  validates_uniqueness_of :organization_uid
  
  before_validation :set_default_header_if_new_record
  
  def after_intialize
    if new_record?
      self.payment_types = []
      self.insurance_types = []
    end
  end
  
  def assigned_payment_types=(arry)
    self.payment_types = arry.map {|a| a[:name] }
  end
  
  def assigned_insurance_types=(arry)
    self.insurance_types = arry.map {|a| a[:name] }
  end
  
  protected
    def set_default_header_if_new_record
      self.header = DEFAULT_HEADER if new_record? && self.header.blank?
    end
end
