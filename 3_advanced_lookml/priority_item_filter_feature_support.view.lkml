view: priority_item_filter_feature_support {
  # This file shows fields that work together to create the request filter experience.
  # See ADVANCED_LOOKML_README for more on business scenario/request.
  # We want to create a filter that lets the user choose "High Priority Only" or "All".
  # "High Priority" means it's High Value and Status = Complete.

  # This parameter allows the end user to make a choice of some kind before running the query.
  # It looks a lot like a filter, but it doesn't actually filter (at least directly).
  parameter: priority_items_only_toggle{
    label: "Priority Items Only Toggle"
    type: string
    # Scenario: Users requested there be exactly two choices: "High Priority Only" and "All".
    allowed_value: {
      label: "Priority Only" # What the user sees in the filter dropdown
      value: "PriorityOnly" # The value that will be appear in the LookML logic check when this parameter is referenced
    }
    allowed_value: {
      label: "All Items"
      value: "AllItems"
    }
  }

  dimension: is_high_value_item {
    type: yesno
    sql: ${order_items.sale_price} > 100 ;;
    html: {% if value == "Yes"%}<span style="color: green;" >{{rendered_value}}</span>{%else%}{%endif%};;
  }

  dimension: is_high_priority_item {
    type: yesno
    # Use Liquid reference with ._sql used to avoid Looker evaluating this as a circular reference.
    # This field should not be used in user-level derived table.
    sql:  (${is_high_value_item} AND ${order_items.is_valid})
          {% if user_summary_unfiltered._in_query %} or {{user_summary_unfiltered.user_revenue_rank_group._sql}} like 'Top%' {%endif%}
          ;;
  }

  # This LookML field captures whether an order item satisfies the criteria that the user selected in our parameter above.
  # We'll filter this to "Yes" in the Explore to implement the desired filter behavior.
  dimension: meets_priority_parameter_selection {
    type: yesno
    sql: {%if priority_items_only_toggle._parameter_value == "'PriorityOnly'"%}${is_high_priority_item}{%else%}true{%endif%};;
  }
  measure: count_high_priority_items{
    label: "# of Order Items (Priority Only)"
    type: sum
    filters: [is_high_priority_item: "Yes"]
    drill_fields: [order_items.standard_order_items_measure_drill_fields*]
    sql: case when ${order_items.id} is not null then 1 else 0 end ;;
    html: <span style="color: green;" >{{rendered_value}}</span> ;;
  }

}
