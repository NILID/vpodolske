module ProfilesHelper
  def show_gender(gender)
    if gender != nil
      gender == 'm' ? t(:male) : t(:female)
    else
      ''
    end
  end
end
