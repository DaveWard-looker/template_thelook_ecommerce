### Basic order items view file
# This is a simple example view file.
# More explanation is provided in BASIC_VIEW_COMPANION_README.md markdown file in this folder. Open BASIC_VIEW_COMPANION_README.md in a separate tab to view it side-by-side with this document.
# For an overview of view files and other LookML objects, see the BASIC_LOOKML_README.md file.
###

# BUSINESS CASE: This view file correlates to the order_items table, which contains one unique row for each ecommerce order item place by a user.

view: basic_order_items { # creates a view file with the name 'basic_order_items'
  sql_table_name: `bigquery-public-data.thelook_ecommerce.order_items` ;;  # defines the table in the database that this view is based on. This table name is used in the FROM/JOIN clause that Looker will use in SQL commands to your database.

  ### Dimensions ###
  # A dimension is a non-aggregate field used for grouping/slicing data. See the BASIC_VIEW_COMPANION_README.md markdown file for more info.
  ####

  dimension: id { # Creates a dimension named "id." You can name the dimension whatever you like.
    primary_key: yes # Identifies this dimension as the primary key (a dimension with a unique value for every row)
    type: number # Specifies the type of data in the dimension. The type affects rendering, filtering, sort order, suggestions, and more.
    sql: ${TABLE}.id ;; # Specifies the actual SQL that is used for the field when the query runs, notice the ${} substitution operator, see the BASIC_VIEW_COMPANION_README.md for more on this.
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: product_id {
    type: number
    sql: ${TABLE}.product_id ;;
  }

  dimension: inventory_item_id {
    type: number
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: is_returned_or_cancelled {
    description: "Can only return value of Returned or Cancelled"
    synonyms: ["Return Sales" ,"Cancelled Sales"]
    type: string
    sql: CASE
              WHEN ${status} IN ('Returned', 'Cancelled') THEN 'Returned or Cancelled'
              ELSE 'In progress or Completed'
         END;; # using some custom SQL in our dimensions SQL definition, remember you can write any SQL your database supports here
  }

  dimension_group: created_at { # dimension groups create multiple dimensions with different time granularities, in a single declaration.
    type: time
    timeframes: [raw,time,date,week,month,quarter,year,month_name] # the different time grains to create dimensions for. They will be presented together in the Explore field-picker under one group label
    sql: ${TABLE}.created_at ;;
  }

  # Send to suradeep, Abshek & Rui
  dimension: is_current_month {
    type: yesno
    sql: ${created_at_month_name} = FORMAT_DATE('%B', CURRENT_DATE()) ;;
  }



  dimension_group: shipped_at {
    type: time
    timeframes: [raw,time,date,week,month,quarter,year]
    sql: ${TABLE}.shipped_at ;;
  }

  dimension_group: delivered_at {
    type: time
    timeframes: [raw,time,date,week,month,quarter,year]
    sql: ${TABLE}.delivered_at ;;
  }

  dimension_group: returned_at {
    type: time
    timeframes: [raw,time,date,week,month,quarter,year]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    description: "This is the total sale value of an order"
    synonyms: ["Total Sales","Total Revenue","Sale"]
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  ####
  # Measures
  # Measures are fields that are aggregate calculations (e.g. sum, max, etc). Be sure to check the BASIC_VIEW_COMPANION_README.md markdown file for more info.
  ####

  measure: count { # creates a measure with any name we like
    label: "# of Order Items" # overrides this measures label in Looker's front end
    type: count # defines the aggregation type (sum, count, count_distinct, etc)
    # Note that Count, unlike other measure types, doesn't require a SQL parameter
  }

  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;; # the actual SQL to be aggregated. Here sale_price will be wrapped in a SUM() function: SUM(sale_price)
    value_format_name: usd  #apply a standard formatting in visualizations.  There are built-in value_format_names, but you can also create your own value_formats.
  }

  measure: total_sale_price_this_month {
    type: sum
    sql: ${sale_price} ;; # the actual SQL to be aggregated. Here sale_price will be wrapped in a SUM() function: SUM(sale_price)
    value_format_name: usd  #apply a standard formatting in visualizations.  There are built-in value_format_names, but you can also create your own value_formats.
    filters: [is_current_month: "Yes"]
  }

  measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
  }

}
