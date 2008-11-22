class AddThemerollerCss < ActiveRecord::Migration
  def self.up
    add_column :site_templates, :themeroller_css, :text
  end

  def self.down
    remove_column :site_templates, :themeroller_css
  end
end
