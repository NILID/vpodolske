class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)

    can :read, :all
    cannot :read, Event, hidden: true
    cannot :read, [Bug, Note, Letter, Organization]
    cannot :index, Comment
    can :emails, Organization
    can :read, Organization, status_mask: 2
    can :create, [Note, Bug, Organization, Place, Photo, Event, Comment]
    can :search, Category
    can :archive, Event
    can %i[gallery about map], Place

    if user.role? :admin
      can %i[manage], :all
      can %i[admin coolme calendar], Event
    end
    if (user.role? :user) || (user.role? :moderator)
      # can :manage, [Event, Profile], user_id: user.id
      # cannot %i[edit update], [Event], hidden: false
      can %i[edit update], Organization, user_id: user.id
      can :show, Organization, status_mask: 1, user_id: user.id
      cannot :read, Note
      cannot :read, [Event], hidden: true
      can %i[create], [Place, Photo, Event, Comment]
      can %i[like unlike], [Event, Place]
      can %i[read update], Event, user_id: user.id
      can %i[edit update], User, id: user.id
      can %i[like youtube_title], Video
      # can :read, [Event], hidden: true, user_id: user.id
    end
  end
end
