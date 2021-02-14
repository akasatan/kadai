    # frozen_string_literal: true

    require 'rails_helper'

    # RSpec.describe List, "モデルに関するテスト", type: :model do
      describe '実際に保存してみる' do
        it '有効な投稿内容の場合は保存されるか' do
          expect(FactoryBot.build(:book)).to be_valid # buildはnewの外部参照簡単バージョン
        end
      end
      describe '投稿のテスト' do
        let!(:list) { create(:list,title:'hoge',body:'body') }
        describe 'トップ画面(top_path)のテスト' do
          before do #トップ画面への遷移
            visit top_path
          end
          context '表示の確認' do
            it 'トップ画面(top_path)に「ここはTopページです」が表示されているか' do
              expect(page).to have_link "", href: lists_path
            end
            it 'top_pathが"/top"であるか' do
              expect(current_path).to eq('/')
            end
          end
        end
        describe '投稿画面のテスト' do
          before do #投稿画面への遷移
            visit todolists_new_path
          end
          context '表示の確認' do
            it 'todolists_new_pathが"/todolists/new"であるか' do
              expect(todolists_new_path).to eq('/todolists/new')
            end
            it '投稿ボタンが表示されているか' do
              expect(page).to have_botton 'Create Book'
            end
          end
          context '投稿処理のテスト' do
            it '投稿後のリダイレクト先は正しいか' do
              fill_in 'lists[title]', with: Faker::Lorem.characters(number:1)
              fill_in 'lists[body]', with: Faker::Lorem.characters(number:1)
              click_button '投稿'
              expect(page).to have_current_path todolist_path(list.id)
              # list.idもlistも同じ意味
            end
          end
        end
        describe '一覧画面のテスト' do
          before do  #一覧画面への遷移
            visit todolists_path
          end
          context '一覧の表示とリンクの確認'
          it "一覧表示画面に投稿されたものが表示されているか"
            (1..5).each do |i|
              List.create(title:'hoge'+i.to_s,body:'body'+1.to_s)
            end
            visit todolists_path
            List.all.each_with_index do |list,i|
              j = i * 3
              expect(page).to have_content list.title
              expect(page).to have_content book.body
            end
        end
        describe '詳細画面のテスト' do
          before #詳細画面への遷移
            visit list_path(list)
          end
          context '表示のテスト' do
            it '削除リンクが存在しているか' do
              destroy_link = find_all('a')[0]
              expect(destroy_link.native.inner_text).to match(/destroy/i)
            end
            it '編集リンクが存在しているか' do
              show_link = find_all('a')[0]
              expect(edit_link.native.inner_text).to match(/edit/i)
            end
          end
          context 'リンクの遷移先の確認' do
            it '編集の遷移先は編集画面か'
              edit_link = find_all('a')[0]
              edit_link.click
              expect(current_path).to eq('/books') + book.id.to_s + ('/edit')
            end
          end
          context 'list削除のテスト' do
            it 'listの削除' do
              expect{ list.destroy }.to change{ List.count }.by(-1)
            end
          end
          describe '編集画面のテスト' do
            before do #編集画面への遷移
              visit edit_todolist_path(list)
            end
            context '表示の確認' do
              it '編集前のタイトルと本文がフォームに表示(セット)されている' do
                expect(page).to have_field 'todolist[:title]', with: todolist.title
                expect(page).to have_field 'todolist[:body]', with: todolist.body
              end
              it '保存ボタンが表示される' do
                expect(page).to have_botton '保存'
              end
            end
            context '更新処理に関するテスト' do
              it '更新後のリダイレクト先は正しいか' do
                fill_in 'todolist[title]', with: Faker::Lorem.characters(number:5)
                fill_in 'todolist[body]', with: Faker::Lorem.characters(number:20)
                click_button '保存'
                expect(page).to have_current_path todolist_path(list)
          
                
      