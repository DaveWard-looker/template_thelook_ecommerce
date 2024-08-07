### Advanced order items view file
# This view extends the intermediate_order_items view.
# For more detailed explanation of the business scenario and the parameters used, see ADVANCED_LOOKML_README.md
#
# Features added here:
# - Multiple drill-paths on a single field.
###

include: "/2_intermediate_lookml/intermediate_order_items.view.lkml"

view: advanced_order_items {
  extends: [intermediate_order_items] # This view will start with all the settings of intermediate_order_items.

# We'll use these hidden measures to configure a drill path, and then use the drill path/link in our visible field(s).
  measure: count_for_sale_price_trend_drill {
    hidden: yes
    type: count
    drill_fields: [created_at_date, total_sale_price]
  }

  measure: count_for_drill_to_item_details {
    hidden: yes
    type: count
    drill_fields: [standard_order_items_measure_drill_fields*]
  }

# This field is visible to users.
  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: short_dollars
    # Providing multiple drill paths with the link parameter
    link: {label: "📈 Sales by Day" url: "{{ count_for_sale_price_trend_drill._link }}" }
    link: {label: "📊 Item Details" url: "{{ count_for_drill_to_item_details._link }}"  }
  }
}
