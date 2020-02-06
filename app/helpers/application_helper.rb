module ApplicationHelper
  def body_class
    # params[:controller] == 'main' ? 'homepage-2' : nil
    if params[:controller] == 'main'
      'homepage-2'
    elsif %w[places photos].include? params[:controller]
      'homepage-3'
    else
      nil
    end
  end

  def rusdate(date)
    Russian::strftime(date, format_year(date.year))
  end

  def vpodolske_mail
    mail_to('mail@vpodolske.com', nil, replace_at: '_at_', replace_dot: '_dot_', encode: 'hex')
  end

  def rusdatecom(date)
    format = Time.now.year == date.year ? '%d %B / %H:%M' : '%d %B %Y'
    Russian::strftime(date, format)
  end

  def clear_tags(content)
    sanitize(content, tags: [])
  end

  def format_year(year)
    DateTime.now.year == year ? '%d %B' : '%d %B %Y'
  end

  def russian_to_english_date(date_string)
    # TODO
    # check names
    date_string.downcase!
    # long words
    result = date_string.gsub(/января|февраля|марта|апреля|мая|июня|июля|августа|сентября|октября|ноября|декабря|январь|февраль|март|апрель|май|июнь|июль|август|сентябрь|октябрь|ноябрь|декабрь/,
        'января' => 'January',
        'февраля' => 'February',
        'марта' => 'March',
        'апреля' => 'April',
        'мая' => 'May',
        'июня' => 'June',
        'июля' => 'July',
        'августа' => 'August',
        'сентября' => 'September',
        'октября' => 'October',
        'ноября' => 'November',
        'декабря' => 'December',
        'январь' => 'January',
        'февраль' => 'February',
        'март' => 'March',
        'апрель' => 'April',
        'май' => 'May',
        'июнь' => 'June',
        'июль' => 'July',
        'август' => 'August',
        'сентябрь' => 'September',
        'октябрь' => 'October',
        'ноябрь' => 'November',
        'декабрь' => 'December' )
    # short words
    result.gsub(/янв|фев|мар|апр|май|июн|июл|авг|сен|окт|ноя|дек|пн|вт|ср|чт|пт|сб|вс/,
        'янв' => 'January',
        'фев' => 'February',
        'мар' => 'March',
        'апр' => 'April',
        'май' => 'May',
        'июн' => 'June',
        'июл' => 'July',
        'авг' => 'August',
        'сен' => 'September',
        'окт' => 'October',
        'ноя' => 'November',
        'дек' => 'December',
        'пн' => '',
        'вт' => '',
        'ср' => '',
        'чт' => '',
        'пт' => '',
        'сб' => '',
        'вс' => '' )
  end

  def plural(count, value)
    # custom pluralization
    # for russian pluralization
    val = "plural.#{value}"
    count.to_s + ' ' + Russian.p(count, t("#{val}_1", locale: :ru), t("#{val}_2", locale: :ru), t("#{val}_10", locale: :ru))
  end

  def thumb_img(thumb)
    thumb
  end

  def lazy_img(thumb, alt=nil, style)
    image_tag asset_url('grey.gif'), class: "b-lazy #{style}", data: { src: thumb, src_small: thumb}, alt: alt
  end

  def ads_block(ads)
    Rails.env.production? ? render("main/yandex/#{ads}") : content_tag(:div, 'Здесь могла бы быть ваша реклама', class: 'text-muted')
  end
end
