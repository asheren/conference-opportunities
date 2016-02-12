class StylesController < ApplicationController
  class Style < Struct.new(:path)
    def self.all(section_path)
      Dir.glob(File.join(section_path, "_*")).map { |file_path| new(file_path) }
    end

    def name
      File.basename(path).gsub(/^_/, '').gsub(/\.html\..+$/, '')
    end
  end

  class Section < Struct.new(:path)
    def self.all(path)
      Dir.glob(File.join(path, "**/")).map { |section_path| new(section_path) }
    end

    def any?
      styles.any?
    end

    def styles
      Style.all(path)
    end

    def name
      File.basename(path)
    end
  end

  def index
    @styles = Section.all(Rails.root.join("app/views/styles")).select(&:any?)
  end
end
