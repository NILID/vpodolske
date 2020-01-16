module PlacesHelper
  def map_info(place)
     [
       place.title,
       place.address,
       content_tag(:div, map_images(place)) + truncate(clear_tags(place.desc), length: 120, separator: ' ', omission: '...'),
       link_to(place.title, place )
     ]
  end

  def map_images(place)
    photos = place.photos
    content_tag(:div, map_image(photos, :first) + (map_image(photos, :last) if photos.size > 1))
  end

  def map_image(collection, position)
    image_tag(collection.send(position).slide(:thumb), width: 100, class: 'img-thumbnail')
  end
end
