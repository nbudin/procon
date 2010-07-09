class AttachedImagesController < ApplicationController
  def show
    filename = "#{params[:id]}.#{params[:format]}"
    @site_template = SiteTemplate.find(params[:site_template_id])
    @image = @site_template.attached_images.find_by_image_file_name(filename)
    if @image
      redirect_to @image.image.url, :status => :moved_permanently
    else
      render :file => "#{Rails.root}/public/404.html", :status => 404
    end
  end
end
