# frozen_string_literal: true

module TouchpointsSpecHelpers
  def expect_start_and_end_date_fields
    expect(page).to have_text('Export responses')
    expect(page).to have_text('Start Date')
    expect(page).to have_text('End Date')
    expect(page).to have_css("input#start-date[type='date']")
    expect(page).to have_css("input#end-date[type='date']")
  end

  def expect_responses_fiscal_year_dropdown
    expect(page).to have_text('Export responses')
    expect(page).to have_text('Select Fiscal Year:')
    expect(page).to have_select('fiscal_year', with_options: [
      'All',
      '2025',
      '2024',
      '2023',
      '2022',
      '2021',
      '2020'
    ])
  end

  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end
end

RSpec.configure do |config|
  config.include TouchpointsSpecHelpers, type: :feature
end
