# EDSC-71: As a user, I want to view browse imagery for capable granules so that
#          I may see a preview of the data they contain

require "spec_helper"

describe "Granule browse display", reset: false, wait: 30 do
  extend Helpers::DatasetHelpers

  before :all do
    Capybara.reset_sessions!
    visit "/search"
    # scrolling in these specs doesn't work unless the window is resized
    page.driver.resize_window(1000, 1000)
  end

  context "for granules with browse" do
    use_dataset 'C14758250-LPDAAC_ECS', 'AST_L1A'

    context "viewing the granule list" do
      hook_granule_results

      it "displays browse thumbnails for each granule which link to the original browse image" do
        expect(granule_list).to have_css('a.panel-list-thumbnail-container img[src$="h=65&w=65"]')
      end

      context "clicking on a granule result" do
        before :all do
          first_granule_list_item.click
        end

        after :all do
          first_granule_list_item.click
        end

        it "displays a larger browse thumbnail on the map which links to the original browse image" do
          expect(page).to have_css('#map .granule-browse a img[src$="h=256&w=256"]')
        end
      end
    end

    context "returning to the search page with granule browse visible on the map" do
      before :all do
        first_dataset_result.click
        sleep(1) # Wait for sliding transitions
        first_granule_list_item.click
        find('#granule-list').click_link('Back to Datasets')
        wait_for_visualization_unload
        sleep(1)
      end

      it "hides the granule browse" do
        expect(page).to have_no_css('.granule-browse a img[src$="h=256&w=256"]')
      end
    end
  end

  context "for granules with no browse" do
    use_dataset 'C179003030-ORNL_DAAC', '15 Minute Stream Flow Data: USGS (FIFE)'

    context "viewing the granule list" do
      hook_granule_results

      it "displays no browse imagery or placeholders" do
        expect(granule_list).to have_no_css('.panel-list-thumbnail-container')
      end

      context "clicking on a granule result" do
        it "displays no browse thumbnail for that result" do
          expect(page).to have_no_css('.granule-browse')
        end
      end
    end
  end

end
