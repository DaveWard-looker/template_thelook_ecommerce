view: user_summary_and_order_items_fields {
  view_label: "!Special Measures!"
  # sql_table_name:  ;; # The table is intentionally omitted from this view for use with a bare join. See ADVANCED_LOOKML_README.md for further explanation.
  measure: percent_of_lifetime_unfiltered_sales {
    label: "% of Purchasing Users' Total Sales"
    group_label: "{{user_summary_unfiltered.view_UI_label_placeholder._sql}}"
    type: number
    sql: ${order_items.total_sale_price}*1.0/nullif(${user_summary_unfiltered.total_sales_for_these_users},0) ;;
    value_format_name: percent_0
  }
  measure: percent_of_lifetime_unfiltered_items {
    label: "% of Purchasing Users' Total Items"
    group_label: "{{user_summary_unfiltered.view_UI_label_placeholder._sql}}"
    type: number
    sql: ${order_items.count}*1.0/nullif(${user_summary_unfiltered.total_items_for_these_users},0) ;;
    value_format_name: percent_0
  }

  measure: filtered_average_vs_unfiltered_average {
    label: "Avg Price vs These Users' Avg Price (Lifetime)"
    group_label: "{{user_summary_unfiltered.view_UI_label_placeholder._sql}}"
    description: "Does the user spend more per item on these items?"
    type: number
    sql: (${order_items.average_sale_price}*1.0/nullif(${user_summary_unfiltered.average_sale_price_for_these_users},0))-1 ;;
    value_format_name: percent_0
    # Use HTML parameter and Liquid to dynamically change icons and color change depending on the value of this dimension
    html:
    {% if value < 0.005 and value > -0.005  %} Same as Overall Average
    {% elsif value < 0 %}<span style="color: red;">{{rendered_value | replace:'-',''}} Lower
    {% else %}<span style="color: green;">︎︎{{rendered_value}} Higher{%endif%}  ;;
  }
}
