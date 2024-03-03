require "pry"
# frozen_string_literal: true

class Docs::ComboboxView < ApplicationView
  def template
    div(class: "max-w-2xl mx-auto w-full py-10 space-y-10") do
      render Docs::Header.new(title: "Combobox", description: "Autocomplete input and command palette with a list of suggestions.")

      render PhlexUI::Typography::H2.new { "Usage" }

      render Docs::VisualCodeExample.new(title: "Example", context: self) do
        <<~RUBY
          frameworks = [
            {
              value: "next.js",
              label: "Next.js",
            },
            # {
            #   value: "sveltekit",
            #   label: "SvelteKit",
            # },
            # {
            #   value: "nuxt.js",
            #   label: "Nuxt.js",
            # },
            # {
            #   value: "remix",
            #   label: "Remix",
            # },
            {
              value: "astro",
              label: "Astro",
            }
          ]

          render PhlexUI::Popover.new(options: { trigger: 'click', placement: 'bottom' }) do
            render PhlexUI::Popover::Trigger.new(class: 'w-full') do
              render PhlexUI::Button.new(variant: :outline, class: "w-[200px] justify-between") do
                # span {button_value.present? ? frameworks.find {|framework| framework.dig(:value) === button_value}&.dig(:label) : "Select framework..."}
                span(id: "combobox-select", data: {controller: "text"}) {"Select framework..."}
                # chevron_icon(class: "ml-auto h-4 w-4", )
                svg(
                  xmlns: "http://www.w3.org/2000/svg",
                  viewbox: "0 0 20 20",
                  fill: "currentColor",
                  class: "ml-2 h-4 w-4 shrink-0 opacity-50",
                ) do |s|
                  s.path(
                    fill_rule: "evenodd",
                    d:
                      "M10 3a.75.75 0 01.55.24l3.25 3.5a.75.75 0 11-1.1 1.02L10 4.852 7.3 7.76a.75.75 0 01-1.1-1.02l3.25-3.5A.75.75 0 0110 3zm-3.76 9.2a.75.75 0 011.06.04l2.7 2.908 2.7-2.908a.75.75 0 111.1 1.02l-3.25 3.5a.75.75 0 01-1.1 0l-3.25-3.5a.75.75 0 01.04-1.06z",
                    clip_rule: "evenodd"
                  )
                end
                cn()
                  # ? frameworks.find((framework) => framework.value === value)?.label
                  # : "Select framework..."}
                # <CaretSortIcon className="ml-2 h-4 w-4 shrink-0 opacity-50" />
              end
            end

            data = {
              controller: "combobox",
              combobox_input_outlet: "#" + "combobox-select",
              combobox_text_outlet: "#" + "combobox-select"
            }
            render PhlexUI::Popover::Content.new(class: 'w-[200px] p-0', data: data) do
              render PhlexUI::Command.new do
                render PhlexUI::Command::Input.new(placeholder: "Search framework...", class: "h-9")
                render PhlexUI::Command::Empty.new { "No framework found." }
                render PhlexUI::Command::Group.new do
                  frameworks.each do |component|
                    render PhlexUI::Command::Item.new(value: component[:label], href: "#", data: {action: "click->combobox#selectItem", combobox_target: "item"}) do
                      plain component[:label]
                      selected_icon
                    end
                  end
                end
              end
            end
          end
        RUBY
      end

      render Docs::VisualCodeExample.new(title: "Open", context: self) do
        <<~RUBY
          render PhlexUI::Collapsible.new(open: true) do
            div(class: "flex items-center justify-between space-x-4 px-4 py-2") do
              h4(class: "text-sm font-semibold") { " @joeldrapper starred 3 repositories" }
              render PhlexUI::Collapsible::Trigger.new do
                render PhlexUI::Button.new(variant: :ghost, icon: true) do
                  chevron_icon
                  span(class: "sr-only") { "Toggle" }
                end
              end
            end

            div(class: "rounded-md border px-4 py-2 font-mono text-sm shadow-sm") do
              "phlex-ruby/phlex"
            end

            render PhlexUI::Collapsible::Content.new do
              div(class: 'space-y-2 mt-2') do
                div(class: "rounded-md border px-4 py-2 font-mono text-sm shadow-sm") do
                  "phlex-ruby/phlex-rails"
                end
                div(class: "rounded-md border px-4 py-2 font-mono text-sm shadow-sm") do
                  "PhlexUI/phlex_ui"
                end
              end
            end
          end
        RUBY
      end

      render Docs::ComponentsTable.new(components)
    end
  end

  private

  def components
    [
      Docs::ComponentStruct.new(name: "CollapsibleController", source: "https://github.com/PhlexUI/phlex_ui_stimulus/blob/main/controllers/collapsible_controller.js", built_using: :stimulus),
      Docs::ComponentStruct.new(name: "PhlexUI::Collapsible", source: "https://github.com/PhlexUI/phlex_ui/blob/main/lib/phlex_ui/collapsible.rb", built_using: :phlex),
      Docs::ComponentStruct.new(name: "PhlexUI::Collapsible::Trigger", source: "https://github.com/PhlexUI/phlex_ui/blob/main/lib/phlex_ui/collapsible/trigger.rb", built_using: :phlex),
      Docs::ComponentStruct.new(name: "PhlexUI::Collapsible::Content", source: "https://github.com/PhlexUI/phlex_ui/blob/main/lib/phlex_ui/collapsible/content.rb", built_using: :phlex)
    ]
  end

  def selected_icon
    svg(
      xmlns: "http://www.w3.org/2000/svg",
      viewbox: "0 0 20 20",
      fill: "currentColor",
      class: "w-4 h-4 absolute right-2 top-1/2 transform -translate-y-1/2 hidden group-data-[selected=true]/selectitem:block"
    ) do |s|
      s.path(
        fill_rule: "evenodd",
        d:
          "M16.704 4.153a.75.75 0 0 1 .143 1.052l-8 10.5a.75.75 0 0 1-1.127.075l-4.5-4.5a.75.75 0 0 1 1.06-1.06l3.894 3.893 7.48-9.817a.75.75 0 0 1 1.05-.143Z",
        clip_rule: "evenodd"
      )
    end
  end

  def chevron_icon
    svg(
      xmlns: "http://www.w3.org/2000/svg",
      viewbox: "0 0 20 20",
      fill: "currentColor",
      class: "w-4 h-4"
    ) do |s|
      s.path(
        fill_rule: "evenodd",
        d:
          "M10 3a.75.75 0 01.55.24l3.25 3.5a.75.75 0 11-1.1 1.02L10 4.852 7.3 7.76a.75.75 0 01-1.1-1.02l3.25-3.5A.75.75 0 0110 3zm-3.76 9.2a.75.75 0 011.06.04l2.7 2.908 2.7-2.908a.75.75 0 111.1 1.02l-3.25 3.5a.75.75 0 01-1.1 0l-3.25-3.5a.75.75 0 01.04-1.06z",
        clip_rule: "evenodd"
      )
    end
  end

  def components_list
    [
      {name: "Accordion", path: helpers.docs_accordion_path},
      {name: "Alert", path: helpers.docs_alert_path},
      {name: "Alert Dialog", path: helpers.docs_alert_dialog_path},
      {name: "Aspect Ratio", path: helpers.docs_aspect_ratio_path},
      {name: "Avatar", path: helpers.docs_avatar_path},
      {name: "Badge", path: helpers.docs_badge_path}
    ]
  end

  def default_icon
    svg(
      xmlns: "http://www.w3.org/2000/svg",
      viewbox: "0 0 24 24",
      fill: "currentColor",
      class: "w-5 h-5"
    ) do |s|
      s.path(
        fill_rule: "evenodd",
        d:
          "M12 2.25c-5.385 0-9.75 4.365-9.75 9.75s4.365 9.75 9.75 9.75 9.75-4.365 9.75-9.75S17.385 2.25 12 2.25zm4.28 10.28a.75.75 0 000-1.06l-3-3a.75.75 0 10-1.06 1.06l1.72 1.72H8.25a.75.75 0 000 1.5h5.69l-1.72 1.72a.75.75 0 101.06 1.06l3-3z",
        clip_rule: "evenodd"
      )
    end
  end
end
