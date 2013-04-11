require_relative '../spec_helper'

describe RailsI18nterface::Log do
  describe "write_to_file" do
    before(:each) do
      I18n.locale = :sv
      I18n.backend.store_translations(:sv, from_texts)
      keys = RailsI18nterface::Keys.new
      @log = RailsI18nterface::Log.new(:sv, :en, RailsI18nterface::Keys.to_shallow_hash(from_texts).keys)
      @log.stub!(:file_path).and_return(file_path)
      FileUtils.rm_f file_path
    end

    after(:each) do
      FileUtils.rm_f file_path
    end

    it "writes new log file with from texts" do
      File.exists?(file_path).should be_false
      @log.write_to_file
      File.exists?(file_path).should be_true
      RailsI18nterface::File.new(file_path).read.should == RailsI18nterface::File.deep_stringify_keys(from_texts)
    end

    it "merges from texts with current texts in log file and re-writes the log file" do
      @log.write_to_file
      I18n.backend.store_translations(:sv, {:category => "Kategori ny"})
      @log.keys = ['category']
      @log.write_to_file
      RailsI18nterface::File.new(file_path).read['category'].should == "Kategori ny"
    end

    def file_path
      File.join(File.dirname(__FILE__), "files", "from_sv_to_en.yml")
    end

    def from_texts
      {
        :article => {
          :title => "En artikel"
        },
        :category => "Kategori"
      }
    end
  end
end