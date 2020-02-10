scope_advert = 'obyavleniya'

Rails.application.routes.draw do

  resources :pages do
    resources :blocks, except: %i[show index] do
      collection do
        post :sort
      end
    end
  end
  resources :letters, except: %i[edit update]
  mount_roboto
  resources :bugs, only: %i[index create new destroy]
  resources :comments, only: %i[index destroy]

  mount Ckeditor::Engine => '/ckeditor'
  get 'parser/karofilm'
  get 'parser/dkoctober'
  get 'parser/vzpodolsk'
  get 'parser/inpodolsk'
  get 'parser/podolsk'
  get 'parser/list'
  get 'parser/dkzio'
  get 'parser/podolsk_cat'
  get 'parser/dkkarl'
  get 'parser/dklepse'
  get 'parser/spravka'
  get 'parser/parktal'
  get 'parser/metallv'
  get 'parser/molodezh'
  get 'parser/dubrov'
  get 'parser/sherbinka'
  get 'parser/metal_lvov'
  get 'parser/druzhba'
  get 'parser/news_tvkvarc'
  get 'parser/news_riamo'
  get 'parser/news_admin'

  scope "/#{scope_advert}" do
    resources :adverts, only: [:index]
  end

  resources :videos do
    resources :comments, except: [:index, :show]
    collection do
      get 'youtube_title'
    end
    member do
      put 'like'
    end
  end


  resources :notes, only: %i[index create new destroy]

  resources :providers, only: %i[new create index]

  resources :places, path: :live do
    collection do
      get 'get_photo'
      get 'about'
      get 'gallery'
      get 'map'
    end

    member do
      put 'like'
      put 'unlike'
    end

    resources :photos, except: [:show]
  end

  scope "/spravochnik" do
    resources :categories do
      collection do
        post :create_list
        get :search
      end
      member do
        post :create_orgs
        post :create_multi_orgs
      end
    end
    resources :organizations do
      collection do
        get :hidden
        get :blocked
        get :emails
      end
      member do
        put :accept
        put :block
        get :edit_access
        patch :update_access
      end
      resources :comments, except: %i[new index destroy show]
    end
  end

  resources :articles, path: 'news', except: [:show] do
    member do
      get :back_item
    end
    collection do
      get :parse
      get :manager
    end
  end

  scope '/afisha' do
    resources :events do
     collection do
       get 'calendar'
       get 'admin'
       get 'archive'
       post 'parse'
       post 'parse_lepse'
       post 'parse_karl'
       post 'parse_talal'
       post 'parse_molodezh'
       post 'parse_dubrov'
       post 'parse_druzhba'
     end
     member do
       put 'coolme'
       put 'like'
       put 'unlike'
     end
    end
  end

  %i[about sponsor den_goroda_2018].each do |page|
    get page, to: "main##{page}"
  end

  devise_for :users, controllers: { registrations: 'registrations', omniauth_callbacks: 'omniauth_callbacks' }

  resources :users, only: %i[index show destroy edit update] do
    member do
      get :crop
    end
    scope "/#{scope_advert}" do
      resources :adverts, except: [:index]
    end
  end

  root to: 'main#index'
end
