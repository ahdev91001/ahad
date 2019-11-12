class Property < ActiveRecord::Base

  has_many :prop_architects, foreign_key: :propid, dependent: :destroy, inverse_of: :property
  has_many :prop_builders, foreign_key: :propid, dependent: :destroy, inverse_of: :property
  has_many :prop_owners, foreign_key: :propid, dependent: :destroy, inverse_of: :property
  has_many :prop_resources, foreign_key: :propid, dependent: :destroy, inverse_of: :property
  has_many :prop_chrs, foreign_key: :propid, dependent: :destroy, inverse_of: :property, primary_key: :id
  has_many :building_permits, foreign_key: :propid, dependent: :destroy, inverse_of: :property
  has_many :alterations, foreign_key: :propid, dependent: :destroy, inverse_of: :property
  has_many :former_addresses, foreign_key: :propid, dependent: :destroy, inverse_of: :property
  has_one :apn, foreign_key: :propid, dependent: :destroy, inverse_of: :property
  
  accepts_nested_attributes_for :prop_architects, :allow_destroy => true
  accepts_nested_attributes_for :prop_builders, :allow_destroy => true
  accepts_nested_attributes_for :prop_owners, :allow_destroy => true
  accepts_nested_attributes_for :prop_resources, :allow_destroy => true
  accepts_nested_attributes_for :prop_chrs, :allow_destroy => true
  accepts_nested_attributes_for :building_permits, :allow_destroy => true
  accepts_nested_attributes_for :alterations, :allow_destroy => true
  accepts_nested_attributes_for :former_addresses, :allow_destroy => true
  accepts_nested_attributes_for :apn, :allow_destroy => true
  
  self.inheritance_column = nil # required because property table has a type
  # column, and that is a reserved name used for Single Table Inheritance
  # per convention.  If need STI, change nil to :sti_type and probably
  # add a migration to add that column to the DB.  DDC

  self.table_name = "property"

  ###########################################################################
  # #Property#find_by_loose_address
  
  # Find a property by a street address that is quite possibly not in the
  # same syntactical (lexical?) form used by the database.
  #
  # Meaning, the database uses "123 Great St", "456 Rails Rules Ave", etc.,
  # but the addresses typed by a usertypes might include "Street" or "St." or
  # "Avenue" or "Ave." or, for that matter, "Mount" instead of "Mt", "East" 
  # instead of "E", etc.  This routine will do most of the common conversions
  # so the property is found even if the way it is typed is any of the common
  # forms that the database does not use.
  #
  # Note: Below worked for mysql2 which does case-insensitive matching:
  #    @property = Property.find_by address1: addr_normalized
  # but sqlite only does case-insensitive matching in LIKE statements,
  # not in regular "=" expressions. Got this from: 
  # http://stackoverflow.com/questions/2220423/
  #   case-insensitive-search-in-rails-model
  # The reply that starts with: "Quoting from the SQLite documentation:")
  #
  # @param addr [String] a street address without city, state, or zip; does
  #   not need to be in any specific form (e.g. St, St., Street all work)
  # 
  # @return [Property] if the address is found in the database
  #
  # @return [nil] if the address does not exist in the database, or if
  #   the canonicalization routine (normalize_address) can't convert
  #   the spelling of the address into the standard format.
  def self.find_by_loose_address(addr)
    addr_normalized = ApplicationController.helpers.normalize_address(addr)
      
    logger.debug "Hand-typed address (not selected from dropdown list): (" +
      addr + ")"
    logger.debug "  Address text normalized to: (#{addr_normalized})"

    # Use LIKE to work with sqlite as well as mysql2, 
    # instead of find_by(:name,...) 
    Property.where("address1 LIKE ?", "#{addr_normalized}%")[0]
  end

  #
  # Instance methods below
  #
  
  
  ###########################################################################
  # #Property.get_photo_filename
  
  # Return filename of first photo, or return filename of placeholder 
  # cartoon image if nil.
  #
  # @return [String] a valid image filename, either of the property, or
  #   of a cartoon placeholder image.
  def get_photo_filename()
    s = self.primary_image
    if s == nil
      "house-stick-figure-med.png" # perhaps make this non-hard-coded somehow
    else
      s.filename
    end
  end
  
  def primary_image
    i = PropResource.where("propid = ? AND resource_type='photo' AND primary_image='Y'", self.id)
    return i[0] # in case multiple primary_images with "Y" for some reason
  end

  def first_architect
    a = PropArchitect.where("propid = ? AND first_architect='Y'", self.id)
    return a[0] # in case multiple architects with "Y" for some reason
  end
  
  def other_architects
    PropArchitect.where("propid = ? AND (first_architect='N' OR " +
      "first_architect='' OR first_architect IS NULL)", self.id)
  end

  def first_builder
    b = PropBuilder.where("propid = ? AND first_builder='Y'", self.id)
    return b[0] # in case multiple builders with "Y" for some reason
  end
  
  def other_builders
    PropBuilder.where("propid = ? AND (first_builder='N' OR " +
      "first_builder='' OR first_builder IS NULL)", self.id)
  end

  def original_owner
    o = PropOwner.where("propid = ? AND original_owner='Y'", self.id)
    return o[0] # in case multiple owners with "Y" for some reason
  end
  
  def other_owners
    PropOwner.where("propid = ? AND (original_owner='N' OR " +
      "original_owner='' OR original_owner IS NULL)", self.id)
  end

  def chrs_codes
    code_string = ""
    pca = PropChrs.where("propid = ?", self.id)
    if !pca.nil?
      pca.each do |pc|
        code_string += pc.chrs_code + ", "
      end
      if code_string.length > 0
        code_string = code_string[0..-3]
      end
    end
    return code_string
  end

end
