# require 'rails_helper' # works, but takes forever to load rails
require 'spec_helper'
require_relative '../../app/helpers/properties_helper'

RSpec.describe "PropertiesHelper", :type => :helper do

  include PropertiesHelper # not needed when requiring rails_helper
  
  describe "#normalize_address" do

    it "uppercases" do
      expect(normalize_address("259 Acacia St"))
        .to eq("259 ACACIA ST")
    end

    it "removes leading whitespace" do
      expect(normalize_address("  259 ACACIA ST"))
        .to eq("259 ACACIA ST")
    end

    it "removes trailing whitespace" do
      expect(normalize_address("259 ACACIA ST  \t  "))
        .to eq("259 ACACIA ST")
    end

    it "turns 2 or more whitespace chars in between " +
       "words into a single space" do
      expect(normalize_address("259  ACACIA   \t ST"))
        .to eq("259 ACACIA ST")
    end

    it "turns tabs into spaces" do
      expect(normalize_address("259\tACACIA ST"))
        .to eq("259 ACACIA ST")
      expect(normalize_address("\t259\tACACIA\t\tST\t"))
        .to eq("259 ACACIA ST")
    end

    it "treats tabs adjacent to spaces as spaces" do
      expect(normalize_address("259 \tACACIA\t ST\t"))
        .to eq("259 ACACIA ST")
    end

    it "turns ST. and STREET into ST" do
      expect(normalize_address("259 ACACIA ST."))
        .to eq("259 ACACIA ST")
      expect(normalize_address("259 ACACIA STREET"))
        .to eq("259 ACACIA ST")
    end

    it "turns AVE. and AVENUE into AVE" do
      expect(normalize_address("259 ACACIA AVE."))
        .to eq("259 ACACIA AVE")
      expect(normalize_address("259 ACACIA AVENUE"))
        .to eq("259 ACACIA AVE")
    end

    it "turns BLVD. and BOULEVARD into BLVD" do
      expect(normalize_address("259 ACACIA BLVD."))
        .to eq("259 ACACIA BLVD")
      expect(normalize_address("259 ACACIA BOULEVARD"))
        .to eq("259 ACACIA BLVD")
    end

  # TODO: Complete for the rest of these, and clean up data
  # inconsistencies in dev and prod and real prod db
  #
  # Rd,Dr,Pl,Way,Ln,Cir,Ter
  # Ct,Blvd,South,Palmyra,Tr,Wy
  # DONE: Blvd, Ave, St, 

    it "passes a wacky contrived test of all of the above" do
      expect(normalize_address("  \t259  \tAcaCia   st.   \t  "))
        .to eq("259 ACACIA ST")
    end

  end # #normalize_address
    
end
