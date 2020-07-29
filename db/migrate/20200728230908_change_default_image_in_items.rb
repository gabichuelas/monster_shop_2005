class ChangeDefaultImageInItems < ActiveRecord::Migration[5.1]
  def change
    change_column_default :items, :image, "https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg"
  end
end
