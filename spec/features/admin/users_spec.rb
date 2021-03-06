require 'rails_helper'

RSpec.feature 'Users', type: :feature do
  let!(:admin_user) { FactoryGirl.create :admin }
  let!(:user) { FactoryGirl.create :user }
  let!(:user_tahi) { FactoryGirl.create :user }
  let!(:user_rua) { FactoryGirl.create :user }
  let!(:user_toru) { FactoryGirl.create :user }

  shared_examples 'cannot #index' do
    describe '#index' do
      before { visit '/admin/users' }
      it { expect(page).not_to have_text(user_tahi.email) }
      it { expect(page).not_to have_text(user_rua.email) }
      it { expect(page).not_to have_text(user_toru.email) }
    end
  end

  subject { page }

  context 'not signed in' do
    include_examples 'cannot #index'
  end

  context 'Normal user' do
    background { login_as(user) }
    include_examples 'cannot #index'
  end

  context 'Logged in as admin' do
    background { login_as(admin_user) }
    describe '#index' do
      before { visit '/admin/users' }
      it { expect(page).to have_text(user_tahi.email) }
      it { expect(page).to have_text(user_rua.email) }
      it { expect(page).to have_text(user_toru.email) }
    end

    describe '#edit' do
      before do
        visit '/admin/users'
        click_link user.email
      end
      it { is_expected.to have_text('Editing User') }
    end

    describe '#update' do
      before do
        visit '/admin/users'
        click_link user.email
        fill_in :user_email, with: 'hiria@example.com'
        click_button 'save'
      end
      it { is_expected.to have_text 'hiria@example.com' }
    end

    describe '#destroy' do
      before do
        visit '/admin/users'
        click_link user.email
        click_button 'delete'
      end
      it { is_expected.not_to have_text user.email }
    end
  end
end
