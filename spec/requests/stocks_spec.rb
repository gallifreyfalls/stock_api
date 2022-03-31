# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StocksController, type: :request do
  describe 'GET /stocks' do
    before do
      create_list(:stock, 4)
    end

    it 'shows stocks with bearers' do
      get stocks_path

      expect(JSON.parse(response.body).count).to eq 4
      expect(JSON.parse(response.body).first['bearer']).to be_present
    end
  end

  describe 'POST /stocks' do
    context 'with bearer' do
      let(:params) { { stock: { name: 'name', bearer: { name: 'bearer' } } } }

      it 'creates stock' do
        post stocks_path, params: params

        expect(response.status).to eq 200
        expect(Stock.count).to eq 1
      end
    end

    context 'without bearer' do
      let(:params) { { stock: { name: 'name' } } }

      it "doesn't create stock" do
        post stocks_path, params: params

        expect(response.status).to eq 422
        expect(Stock.count).to eq 0
      end
    end

    context 'with pre-defined bearer' do
      let!(:bearer) { create(:bearer, name: 'bearer') }
      let(:params) { { stock: { name: 'name', bearer: { name: 'bearer' } } } }

      it 'creates stock with existing bearer' do
        post stocks_path, params: params

        expect(response.status).to eq 200
        expect(JSON.parse(response.body)['bearer']['id']).to eq bearer.id
        expect(Stock.count).to eq 1
        expect(Bearer.count).to eq 1
      end
    end

    context 'with taken name' do
      let!(:stock) { create(:stock, name: 'stock') }
      let(:params) { { stock: { name: 'stock' } } }

      it "doesn't create stock" do
        post stocks_path, params: params

        expect(response.status).to eq 422
        expect(Stock.count).to eq 1
      end
    end
  end

  describe 'PATCH /stocks/id' do
    let(:stock) { create(:stock, name: 'stock') }

    context 'when everything is alright' do
      let(:params) { { stock: { name: 'stock1' } } }

      it 'updates stock' do
        patch stock_path(stock), params: params

        expect(response.status).to eq 200
        expect(stock.reload.name).to eq 'stock1'
      end
    end

    context 'with new bearer' do
      let(:params) { { stock: { name: 'stock1', bearer: { name: 'bearer1' } } } }

      it 'updates stock' do
        patch stock_path(stock), params: params

        expect(response.status).to eq 200
        expect(stock.reload.name).to eq 'stock1'
        expect(stock.bearer.name).to eq 'bearer1'
      end
    end

    context 'with taken name' do
      let(:params) { { stock: { name: 'stock1', bearer: { name: 'bearer1' } } } }

      before do
        create(:stock, name: 'stock1')
      end

      it 'does not update stock' do
        patch stock_path(stock), params: params

        expect(response.status).to eq 422
        expect(stock.reload.name).to eq 'stock'
      end
    end

    context 'with predefined bearer' do
      let!(:bearer) { create(:bearer, name: 'bearer1') }
      let(:params) { { stock: { bearer: { name: 'bearer1' } } } }

      before do
        create(:stock, name: 'stock1')
      end

      it 'updates stock' do
        patch stock_path(stock), params: params

        expect(response.status).to eq 200
        expect(stock.reload.bearer).to eq bearer
      end
    end
  end

  describe 'DELETE /stocks/id' do
    let(:stock) { create(:stock) }

    it 'destroys stock' do
      delete stock_path(stock)

      expect(response.status).to eq 200
      expect(Stock.only_deleted.count).to eq 1
      expect(Stock.count).to eq 0
    end
  end
end
