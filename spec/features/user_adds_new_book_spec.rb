require 'rails_helper'

describe 'new book page' do

  it 'form submission adds new book to database' do
    visit '/books/new'

    fill_in("book[title]", with: "farewell to arms")
    fill_in("book[pages]", with: "650")
    fill_in("book[authors]", with: "ernest hemmingway, ghost writer")
    fill_in("book[year]", with: "1934")
    click_button("Create Book")

    expect(Book.last.title).to eq("Farewell To Arms")
    expect(Book.last.authors.first.name).to eq("Ernest Hemmingway")
  end
  it 'redirects to new book show page on submission' do
    visit '/books/new'

    fill_in("book[title]", with: "farewell to arms")
    fill_in("book[pages]", with: "650")
    fill_in("book[authors]", with: "ernest hemmingway, ghost writer")
    fill_in("book[year]", with: "1934")
    click_button("Create Book")

    expect(page).to have_current_path("/books/#{Book.last.id}")
  end
end
