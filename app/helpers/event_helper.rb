module EventHelper
  def eventdatetime(date, time)
    if time.nil?
      d = rusdate(date)
      return "#{d}"
    elsif date.nil?
      t = Russian::strftime(time, "%H:%M")
      return "#{t}"
    else
      d = rusdate(date)
      t = Russian::strftime(time, "%H:%M")
      return "#{d} / #{t}"
    end
  end
end
