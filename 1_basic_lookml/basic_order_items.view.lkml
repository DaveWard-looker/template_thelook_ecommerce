### Basic order items view file
# This is a simple example view file.
# More explanation is provided in BASIC_VIEW_COMPANION_README.md markdown file in this folder. Open BASIC_VIEW_COMPANION_README.md in a separate tab to view it side-by-side with this document.
# For an overview of view files and other LookML objects, see the BASIC_LOOKML_README.md file.
###

# BUSINESS CASE: This view file correlates to the order_items table, which contains one unique row for each ecommerce order item place by a user.

# TEST

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
    timeframes:
    [raw,
      time,
      date,
      day_of_year,
      week,
      month,
      quarter,
      year,
      month_name
      ] # the different time grains to create dimensions for. They will be presented together in the Explore field-picker under one group label
    sql: ${TABLE}.created_at ;;
  }

  # Send to suradeep, Abshek & Rui
  dimension: is_current_month {
    type: yesno
    sql: ${created_at_day_of_year} <= FORMAT_DATE('%B', CURRENT_DATE()) ;;
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
    group_label: "Order Count"
    group_item_label: "Count"
    label: "# of Order Items" # overrides this measures label in Looker's front end
    type: count # defines the aggregation type (sum, count, count_distinct, etc)
    # Note that Count, unlike other measure types, doesn't require a SQL parameter
  }


  dimension: is_year_to_date {
    type: yesno
    sql:  ${created_at_day_of_year} <= EXTRACT(DAYOFYEAR FROM CURRENT_DATE())  ;;
  }

  measure: count_order_items_to_date {
    group_label: "Order Count"
    group_item_label: " YTD"
    type: count
    label: "Order Items to Date"
    filters: [is_year_to_date: "Yes"]
  }


  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;; # the actual SQL to be aggregated. Here sale_price will be wrapped in a SUM() function: SUM(sale_price)
    value_format_name: usd  #apply a standard formatting in visualizations.  There are built-in value_format_names, but you can also create your own value_formats.
  }


  measure: total_sale_price_ytd {
    type: sum
    sql: ${sale_price} ;; # the actual SQL to be aggregated. Here sale_price will be wrapped in a SUM() function: SUM(sale_price)
    value_format_name: usd  #apply a standard formatting in visualizations.  There are built-in value_format_names, but you can also create your own value_formats.
    filters: [is_year_to_date: "Yes"]
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

  measure: average_sale_price_ytd {
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: running_total_sales_price {
    type: running_total
    sql: ${total_sale_price} ;;
  }

  measure: running_total_sales_price_ytd {
    type: running_total
    sql: ${total_sale_price_ytd} ;;

  }


  parameter: flow {
    type: string
    allowed_value: {
      label: "YtD"
      value: "ytd"
    }
    allowed_value: {
      label: "MtD"
      value: "mtd"
    }
  }




  #####
  ### Period Over Period Measures ###
  ####

  measure: order_count_last_year {
    type: period_over_period
    group_label: "Order Count"
    group_item_label: "Previous Year"
    description: "Order count from the previous year"
    based_on: count
    based_on_time: created_at_year
    period: year
    kind: previous
    value_format_name: decimal_0
  }

  measure: order_count_last_year_to_date {
    type: period_over_period
    group_label: "Order Count"
    group_item_label: "Previous YTD"
    based_on: count
    based_on_time: created_at_year
    value_to_date: yes
    period: year
    kind: previous
    value_format_name: decimal_0
  }

  measure: order_count_difference_last_year_to_date {
    type: period_over_period
    group_label: "Order Count"
    group_item_label: "YoY Difference"
    description: "Year Over Year Order Count Difference"
    based_on: count
    based_on_time: created_at_year
    value_to_date: yes
    period: year
    kind: difference
    value_format_name: decimal_0
  }


  measure: order_count_change_last_year_to_date {
    type: period_over_period
    group_label: "Order Count"
    group_item_label: "YoY Change"
    description: "Percentage change in order items year over year."
    based_on: count
    based_on_time: created_at_year
    value_to_date: yes
    period: year
    kind: relative_change
    value_format_name: percent_2
  }



  # measure: order_count_last_month {
  #   group_label: "PoP Measures"
  #   type: period_over_period
  #   description: "Order count from the previous month"
  #   based_on: count
  #   based_on_time: created_at_month
  #   period: month
  #   kind: previous
  # }

  # measure: order_count_last_month_to_date {
  #   group_label: "PoP Measures"
  #   type: period_over_period
  #   description: "Order count from the previous month to date"
  #   based_on: count
  #   based_on_time: created_at_month
  #   value_to_date: yes
  #   period: month
  #   kind: previous
  # }


  ### Date Granularity Filter #####

  parameter: created_at_timeframe {
    type: unquoted
    allowed_value: {
      label: "By Day"
      value: "day"
    }
    allowed_value: {
      label: "By Week"
      value: "week"
    }
    allowed_value: {
      label: "By Month"
      value: "month"
    }
    allowed_value: {
      label: "By Year"
      value: "year"
    }
  }

  dimension: timeframe {
    label_from_parameter: created_at_timeframe
    type: string
    sql:
    {% if created_at_timeframe._parameter_value == 'day' %}
    ${created_at_date}
    {% elsif created_at_timeframe._parameter_value == 'week' %}
    ${created_at_week}
    {% elsif created_at_timeframe._parameter_value == 'month' %}
    ${created_at_month_name}
    {% else %}
    ${created_at_year}
    {% endif %}
    ;;
  }

  ## Year to Date Flag ###




}
