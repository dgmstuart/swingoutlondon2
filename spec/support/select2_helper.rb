module Select2Helper
  # modified from http://stackoverflow.com/a/28970538/1035431
  # There's a gem that does this, but it doesn't work with
  # multiple select2 elements: https://github.com/goodwill/capybara-select2/issues/41

  def select2(value, options)
    select_name = options[:from]
    Select2.new(select_name).value(value)
  end

  class Select2
    include Capybara::DSL
    def initialize(select_name)
      @select_name = select_name
    end

    def value(value)
      click_container
      search_for_value(value)
      select_value(value)
    end

    private def select_value(value)
      find(:xpath, '//body').all("#{DROP_CONTAINER} li", text: value)[-1].click
    end

    private def search_for_value(value)
      find(:xpath, '//body').all('input.select2-input')[-1].set(value)
      page.execute_script(%|$("input.select2-input:visible").keyup();|)
    end

    private def click_container
      (container.first('.select2-choice') || container.find('.select2-choices')).click
    end

    private def container
      @container ||= begin
        label = first('label', text: @select_name)

        raise "couldn't find a label of #{@select_name}" if label.nil?
        id = label[:for]
        first("#s2id_#{id}")
      end
    end

    DROP_CONTAINER = '.select2-results'.freeze
  end
end
