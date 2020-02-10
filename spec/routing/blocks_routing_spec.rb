require 'rails_helper'

RSpec.describe BlocksController, type: :routing do
  describe 'routing' do
    it 'routes to #new' do
      expect(get: '/pages/podolsk/blocks/new').to route_to('blocks#new', page_id: 'podolsk')
    end

    it 'routes to #edit' do
      expect(get: '/pages/podolsk/blocks/1/edit').to route_to('blocks#edit', id: '1', page_id: 'podolsk')
    end

    it 'routes to #create' do
      expect(post: '/pages/podolsk/blocks').to route_to('blocks#create', page_id: 'podolsk')
    end

    it 'routes to #update via PUT' do
      expect(put: '/pages/podolsk/blocks/1').to route_to('blocks#update', id: '1', page_id: 'podolsk')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/pages/podolsk/blocks/1').to route_to('blocks#update', id: '1', page_id: 'podolsk')
    end

    it 'routes to #destroy' do
      expect(delete: '/pages/podolsk/blocks/1').to route_to('blocks#destroy', id: '1', page_id: 'podolsk')
    end
  end
end
