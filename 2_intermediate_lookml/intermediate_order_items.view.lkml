### Intermediate order items view file
# This view is meant to:
#   - Highlight common types of field-level development/enhancements/customizations that a LookML developer will implement to meet specific user needs
#   - Introduce the LookML set object (a named set of fields)
#   - Introduce basic drill_fields options
#
# NOTE: To demonstrate an optional stylistic choice, declarations which are redundant with defaults have been removed. For example, the the `type:string` subparameter of the `dimension` parameter.
###

include: "/2_intermediate_lookml/custom_named_value_formats.lkml" # In this scenario, business users requested a short number format, which is defined in this file.

view: intermediate_order_items {
  sql_table_name: `bigquery-public-data.thelook_ecommerce.order_items` ;;

  label: "Order Items" # Set the view's default label in the UI. Use labels that are intuitive to the end user.

  dimension: id {
    label: "Order Item ID" # Use `label` to adjust how fields appear in the Explore's field picker.
    view_label: "System Keys" # Use `view_label` to adjust what major section of field picker a field appears in. In this case, we're moving items that are less relevant to users to a special section.
    #hidden: yes # Note that hiding non-user fields is another important way to make the user interface more intuitive. Hidden fields may still be used in LookML references.
    primary_key: yes
    type: number
    value_format_name: id
    # sql: ${TABLE}.id ;; # The default SQL parameter value for fields is equivalent to `${table}.[field_name]`.
  }

  dimension: order_id {
    label: "Order ID (On Order Item)"
    view_label: "System Keys"
    type: number
    value_format_name: id
  }

  dimension: user_id {
    label: "User ID (On Order Item)"
    view_label: "System Keys"
    type: number
    value_format_name: id
  }

  dimension: product_id {
    label: "Product ID (On Order Item)"
    view_label: "System Keys"
    type: number
    value_format_name: id
  }

  dimension: inventory_item_id {
    label: "Inventory Item ID (On Order Item)"
    view_label: "System Keys"
    type: number
    value_format_name: id
  }

  dimension: status {
    # type: string # `type:string` is the default for dimensions
    group_label: "Status Fields" # Use `group_labels` to bundle fields together in the Explore's field picker.
  }

  dimension_group: created_at {
    type: time
    timeframes: [raw,time,date,week,month,quarter,year]
  }

  dimension_group: shipped_at {
    group_label: "Other Dates"
    type: time
    timeframes: [raw,time,date,week,month,quarter,year]
  }

  dimension_group: delivered_at {
    group_label: "Other Dates"
    type: time
    timeframes: [raw,time,date,week,month,quarter,year]
  }

  dimension_group: returned_at {
    group_label: "Other Dates"
    type: time
    timeframes: [raw,time,date,week,month,quarter,year]
  }

  dimension: sale_price {
    type: number
    value_format_name: short_dollars
  }


### CUSTOM STATUS GROUPINGS ###
# This shows how we created several derived fields for common status groupings. These are helpful for our use case
# in which the 'Valid' status of the orders needs to be tracked in various groupings and presentations.
  dimension: cancellation_type {
    group_label: "Status Fields" # Using `group-label` for this set of fields to make a subgrouping within the Explore's field picker.
    drill_fields: [status]
    case: {
      when: {sql:${status} in ('Cancelled');; label:"Cancelled"}
      when: {sql:${status} in ('Returned');; label:"Returned"}
      when: {sql:${status} in ('Shipped','Complete','Processing');; label:"Not Cancelled"}
      else: "Unknown"
    }
  }

  dimension: validation_status {
    group_label: "Status Fields"
    drill_fields: [status] # About drill fields on dimensions: Clicking the dimension value in the query results will filter on the clicked value and replace the clicked field with the fields listed in `drill_fields` parameter.  Dimension drill fields are typically set to drill down a hierarchy.
    # Here's an example of using built-in `case` parameter for case logic. It's often preferrable to writing your own case statements in SQL parameter, because Looker uses the labels to populate filter options.
    case: {
      when: {sql:${status} in ('Cancelled','Returned');; label:"Invalid"}
      when: {sql:${status} in ('Shipped','Complete','Processing');; label:"Valid"}
      else: "Unknown"
      }
  }

  dimension: status_in_order {
    case: {
      when: {sql:${status} in ('Processing');; label:"1 - Processing"}
      when: {sql:${status} in ('Cancelled');; label:"1x - Cancelled"}
      when: {sql:${status} in ('Shipped');; label:"2 - Shipped"}
      when: {sql:${status} in ('Complete');; label:"3 - Complete"}
      when: {sql:${status} in ('Returned');; label:"3x - Returned"}
      else: "Unknown"
    }
  }

  dimension: is_valid {
    group_label: "Status Fields"
    drill_fields: [status]
    type: yesno # `yesno` fields resolve the condition in the `sql` parameter to "Yes" or "No".  Note that a null result is treated as No. `yesno` fields are also very useful for establishing clear logic for common conditions, which you can then utilize in more complex derivations.
    sql:${status} in ('Shipped','Complete','Processing');;
  }


### OTHER NOTABLE FIELD TYPES
  # You can use duration types (or dimension groups with duration timeframes) to automatically calculate date differences.
  dimension: shipped_to_delivered_days {
    group_label: "Other Dates"
    type: duration_day
    sql_start: ${shipped_at_raw} ;;
    sql_end: ${delivered_at_raw} ;;
  }

  # Derive a tiered version of sale price for better grouping.
  dimension: sale_price_tier {
    type: bin
    bins: [10,20,50,100]
    style: relational
    sql: ${sale_price} ;;
  }

  # Note: Another helpful dimension type (`type:location`) can be seen in the intermediate_users view.

### Measures
# Measures (as opposed to dimensions) are columns that are aggregate calculations, such as sum, max, or min.
  measure: count {
    label: "# of Order Items"
    type: count
    drill_fields: [standard_order_items_measure_drill_fields*]
  }

  measure: total_sale_price {
    label: "Sales"
    type: sum
    sql: ${sale_price} ;;
    drill_fields: [standard_order_items_measure_drill_fields*]
    value_format_name: short_dollars # You can apply a standard formatting in visualizations. There are built-in `value_format_name` options, but you can also create your own value formats.
  }

  measure: average_sale_price {
    label: "Average Price"
    type: average
    sql: ${sale_price} ;;
    drill_fields: [standard_order_items_measure_drill_fields*]
    value_format_name: short_dollars
  }

### Filtered Measures
  measure: total_sales_price_validated {
    label: "Sales (Validated)"
    type: sum
    sql: ${sale_price} ;;
    filters: [is_valid: "Yes"] # This will count only `sale_price` values towards this measure's aggregated value if this condition is met. Note that `filter` parameter only works on measure types that apply an aggregation. `filter` does not work on not `type: number`, `type: string`, `type: yesno`, and types which don't apply their own aggregation.
    value_format_name: short_dollars
  }

### Example of a custom measure where you can apply an aggregation in the SQL clause.
  # Also, if you need to perform a calculation on an existing measure, such as dividing one measure by another, it is best to use `type: number` and not `type: sum` or another aggregation so as NOT to add another aggregation function.
  # measure: first_sale {
  measure: first_order_date {
    type: date
    sql: min(${created_at_raw}) ;;
  }


## Example sets. We've observed that some of this view's fields don't make sense when the data has been limited to 'Valid' only.
  set: innapropriate_fields_for_valid_only_explores {fields:[cancellation_type,total_sales_price_validated]}
  set: standard_order_items_measure_drill_fields {fields:[id,user_id,product_id,created_at_date,shipped_at_date, delivered_at_date, returned_at_date,status,sale_price]}
}
