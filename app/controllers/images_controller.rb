class ImagesController < ApplicationController
  def show
    filename = "#{params[:id]}.#{params[:format]}"
    @site_template = SiteTemplate.find(params[:site_template_id])
    @image = @site_template.images.find_by_image_file_name(filename)
    if @image
      redirect_to @image.image.url, :status => :moved_permanently
    else
      render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
    end
  end
end
