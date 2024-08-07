
include: "/2_intermediate_lookml/custom_named_value_formats.lkml"
# Scenario: business users requested a short number format. Included here so it can be used by views in this model.

view: user_summary_unfiltered {
  derived_table: {
    explore_source: advanced_example_ecommerce { # Use the exisitng `advanced_example_ecommerce` Explore as the source for this derived table
      column: user_id { field:order_items.user_id } # For the table to be one row per user/user_id, include the `user_id` dimension

      # Measures to include for each user:
      column: total_sale_price {field:order_items.total_sale_price}
      column: first_order_date {field:order_items.first_order_date}
      column: order_item_count {field:order_items.count}

      # Use derived columns to perform logic on the aggregated results in the above columns
      derived_column: user_revenue_rank {
        # Since our aggregate results are one row per `user_id`, this ranks over user
        sql: rank() over(order by total_sale_price desc) ;;
      }
      derived_column: total_user_count {
        # Since our aggregate results are one row per `user_id`, this counts the total number of users included
        sql: count(*) over() ;;
      }

      bind_all_filters: no # In this case we did not want to pass all UI filters to the derived table query, so we can calculate 'Lifetime Totals'
    }
  }
  view_label: "Users" # These elements are derived characteristics of user. They make sense with the other Users fields

  # This placeholder will be used to insert consistent text into various label elements. See usage in the `group_label` and `label` fields.
  dimension: label_placeholder {
    hidden: yes
    sql: (Lifetime);; # We will need to override this sql to update labels when extending this view and applying different filters.
  }


  # This is the one dimension used in this source, so we'll get one row per `user_id` value.
  # That makes this the primary key, and what we'll use to join to any explore (using relationship:..._to_one)
  dimension: user_id {
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  # Hidden calculation helper fields from the derived source table:
  dimension: total_user_count {hidden: yes}
  dimension: order_item_count {hidden: yes}
  dimension: total_sale_price {hidden: yes}


  dimension: user_revenue_rank {
    group_label: "{{label_placeholder._sql}}" label: "User Revenue Rank {{label_placeholder._sql}}"
    type: number
  }

  dimension: user_revenue_rank_quartile {
    hidden: yes
    sql: trunc((${user_revenue_rank}-1)*1.0/(${total_user_count})/.25) ;;
  }

  ### Named groupings/buckets
  # These are useful, since rank and item count have many distinct values.
  dimension: order_item_count_group {
    group_label: "{{label_placeholder._sql}}" label: "Item Count Group {{label_placeholder._sql}}"
    type: string
    case: {
      when: {sql:${order_item_count}=1;; label:"Single Item"}
      when: {sql:${order_item_count}=2;; label:"2 Items"}
      else:"3+ Items"
    }
  }

  dimension: user_revenue_rank_group {
    group_label: "{{label_placeholder._sql}}" label: "Revenue Rank Group {{label_placeholder._sql}}"
    case: {
      when: {sql:${user_revenue_rank}<=1000;; label:"Top 1000"}
      when: {sql:${user_revenue_rank_quartile}=0;; label:"1st 25%"}
      when: {sql:${user_revenue_rank_quartile}=1;; label:"2nd 25%"}
      when: {sql:${user_revenue_rank_quartile}=2;; label:"3nd 25%"}
      else:"Bottom 25%"
    }
    html: {% if value == 'Top 1000'%}😀<span style="color: green">{{rendered_value}}</span>{%else%}{{rendered_value}}{%endif%} ;;
  }
  dimension: is_top_rank_group {
    group_label: "{{label_placeholder._sql}}" label: "Top Revenue Group {{label_placeholder._sql}}"
    case: {
      when: {sql:${user_revenue_rank_group} like 'Top%';;label:"Top Revenue Group"}
      else: "Not Top Revenue Group"
    }
  }

  ### Time and Cohort Fields
  dimension_group: first_order {
    group_label: "{{label_placeholder._sql}}" label: "First Order {{label_placeholder._sql}}"
    type: time
    timeframes: [raw,date,month]
    sql: ${TABLE}.first_order_date ;;
  }

  ### Measures
  measure: total_sales_for_these_users {
    group_label: "{{label_placeholder._sql}}" label: "Purchasing Users Total Sales {{label_placeholder._sql}}"
    type: sum
    sql: ${total_sale_price} ;;
    value_format_name: short_dollars
  }
  measure: total_items_for_these_users {
    group_label: "{{label_placeholder._sql}}" label: "Purchasing Users Total Items {{label_placeholder._sql}}"
    type: sum
    sql: ${order_item_count} ;;
  }

  measure: average_sale_price_for_these_users {
    group_label: "{{label_placeholder._sql}}" label: "Purchasing Users Overall Average Sale Price {{label_placeholder._sql}}"
    type: number
    sql: ${total_sales_for_these_users}*1.0/nullif(${total_items_for_these_users},0) ;;
    value_format_name: short_dollars
  }
}
