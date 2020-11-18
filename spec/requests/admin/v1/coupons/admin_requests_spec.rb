require 'rails_helper'

RSpec.describe '', type: :request do
  let(:user) { create :user }

  context 'GET /coupons' do
    let(:url) { '/admin/v1/coupons' }
    let!(:coupons) { create_list(:coupon, 2) }

    it 'returns all coupons' do
      get url, headers: auth_header(user)
      expect(body_json['coupons']).to contain_exactly(*coupons.as_json(only: %i(id name code status discount_value max_use due_date)))
    end
    
    it 'returns success status' do
      get url, headers: auth_header(user)
      expect(response).to have_http_status(:ok)
    end
  end

  context 'POST /coupons' do
    let(:url) { '/admin/v1/coupons' }
    
    context 'with valid params' do
      let(:coupon_params) { {coupon: attributes_for(:coupon) }.to_json }
      
      it 'returns success status' do
        post url, headers: auth_header(user), params: coupon_params
        expect(response).to have_http_status(:ok)
      end

      it 'adds a new coupon' do
        expect do
          post url, headers: auth_header(user), params: coupon_params
        end.to change(Coupon, :count).by(1)
      end

      it 'returns last added coupon' do
        post url, headers: auth_header(user), params: coupon_params
        expect_coupon = Coupon.last.as_json(only: %i(id name code status discount_value max_use due_date))
        expect(body_json['coupon']).to eq(expect_coupon)
      end
    end
    
    context 'with invalid params' do
      let(:coupon_invalid_params) { {coupon: attributes_for(:coupon, due_date: 1.day.ago) }.to_json }
      
      it 'returns unprocessable_entity status' do
        post url, headers: auth_header(user), params: coupon_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not add a new coupon' do
        expect do
          post url, headers: auth_header(user), params: coupon_invalid_params  
        end.to_not change(Coupon, :count)
      end
      
      it 'returns unprocessable_entity status' do
        post url, headers: auth_header(user), params: coupon_invalid_params
        expect(body_json['errors']['fields']).to have_key('due_date')  
      end
    end
  end

  context 'PATCH /coupons' do
    let(:coupon) { create(:coupon) }
    let(:url) { "/admin/v1/coupons/#{coupon.id}" }

    context 'with valid params' do
      let(:new_code) { 'TESTDANI' }
      let(:coupon_params) do
        { coupon: { code: new_code } }.to_json
      end
      
      it 'returns success status' do
        patch url, headers: auth_header(user), params: coupon_params
        expect(response).to have_http_status(:ok)
      end

      it 'updates coupon' do
        patch url, headers: auth_header(user), params: coupon_params
        coupon.reload
        expect(coupon.code).to eq(new_code)
      end

      it 'returns updated coupon' do
        patch url, headers: auth_header(user), params: coupon_params
        expect_coupon = Coupon.last.as_json(only: %i(id name code status discount_value max_use due_date))
        expect(body_json['coupon']).to eq(expect_coupon)
      end
    end
    
    context 'with invalid params' do
      let(:coupon_invalid_params) do
        { coupon: attributes_for(:coupon, code: nil) }.to_json
      end
      
      it 'returns unprocessable_entity status' do
        patch url, headers: auth_header(user), params: coupon_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not update Coupon' do
        old_code = coupon.code
        patch url, headers: auth_header(user), params: coupon_invalid_params
        coupon.reload
        expect(coupon.code).to eq(old_code)
      end

      it 'returns error messages' do
        patch url, headers: auth_header(user), params: coupon_invalid_params
        expect(body_json['errors']['fields']).to have_key('code')
      end
    end
  end

  context 'DELETE /coupons/:id' do
    let!(:coupon) { create(:coupon) }
    let(:url) { "/admin/v1/coupons/#{coupon.id}" }
    
    it 'returns no_content status' do
      delete url, headers: auth_header(user)
      expect(response).to have_http_status(:no_content)
    end

    it 'removes coupon' do
      expect do
        delete url, headers: auth_header(user)
      end.to change(Coupon, :count).by(-1)
    end

    it 'does not return any body content' do
      delete url, headers: auth_header(user)
      expect(body_json).to_not be_present
    end
  end
end