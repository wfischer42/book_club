require 'rails_helper'

describe 'new book page' do
  it 'user sees a new book form' do
    visit '/books/new'

    expect(page).to have_css('#new-book-form')
    expect(page).to have_css('#title')
    expect(page).to have_css('#pages')
    expect(page).to have_css('#authors')
    expect(page).to have_css('#year')
    expect(page).to have_css('#submit')
  end
  it 'form submission adds new book to database' do
    visit '/books/new'

    fill_in("book[title]", with: "farewell to arms")
    fill_in("book[pages]", with: "650")
    fill_in("book[authors]", with: "ernest hemmingway, ghost writer")
    fill_in("book[year]", with: "1934")
    click_button("submit")

    expect(Book.last.title).to eq("Farewell To Arms")
    expect(Book.last.authors.first.name).to eq("Ernest Hemmingway")
  end
  it 'redirects to new book show page on submission' do
    visit '/books/new'

    fill_in("book[title]", with: "farewell to arms")
    fill_in("book[pages]", with: "650")
    fill_in("book[authors]", with: "ernest hemmingway, ghost writer")
    fill_in("book[year]", with: "1934")
    click_button("submit")

    expect(page).to have_current_path("/books/#{Book.last.id}")
  end
end
