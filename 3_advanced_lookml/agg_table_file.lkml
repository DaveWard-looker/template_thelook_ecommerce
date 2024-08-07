### Advanced Concept: Aggregate Tables
# You can create aggregate tables to minimize the number of queries required for the large tables in your database.
# Frequently-used queries or combinations of fields are good candidates for aggregate tables.
# Link to documentation: https://cloud.google.com/looker/docs/reference/param-explore-aggregate-table
#
# This `agg_table_file.lkml` file defines an aggregate table. Aggregate tables are defined explicitly within a
# single `explore` parameter (the `aggregate_table` block is inside an `explore` parameter definition.)
# But we can define an aggregate table in a separate file as shown in this file,
# and then require an extension of the `explore` by using the `extension: required` statement.
# The `explore` defined in this file is extended by the `+advanced_example_ecommerce` Explore
# in the advanced_ecomm.model file:
#
# include: "/3_advanced_lookml/agg_table_file.lkml"
# explore: +advanced_example_ecommerce {
#   extends: [an_agg_table_for_order_items]
# }
#
# We can disable the `count_by_status` aggregate table defined below by commenting out the
# `+advanced_example_ecommerce` Explore in the advanced_ecomm.model file. That way, we can "turn off"
# the `count_by_status` aggregate table without adjusting the main code in this `agg_table_file.lkml` file.
#
# We can also use this same `count_by_status` aggregate table in multiple Explores by using the
# `extends: [an_agg_table_for_order_items]` statement inside other `explore` parameters (assuming the
# Explores have the same object names defined in the `count_by_status` aggregate table).
#
# In this case we create a small results table for the fastest possible results of simple count-by-status
# queries.
###

include: "/3_advanced_lookml/etl_datagroup.datagroup.lkml"
explore: an_agg_table_for_order_items {
  extension: required
  aggregate_table: count_by_status {

    query: {
      dimensions: [order_items.status]
      measures: [order_items.count]
      # sorts: []
      # filters: []
    }
    materialization: {
      datagroup_trigger: etl_datagroup
    }
  }
}
