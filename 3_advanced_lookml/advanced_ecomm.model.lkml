### Advanced ecommerce example model file ###
# See ADVANCED_LOOKML_README.md document for overall concepts, more details on specific parameters and
# techniques used, and the business scenario.
#
# Note that `advanced_example_ecommerce` logic is defined in a separate file,
# `advanced_example_ecommerce.explore.lkml"`. That file is included below.

connection: "sample_bigquery_connection"

label: "Z) Sample LookML"

include: "/3_advanced_lookml/advanced_example_ecommerce.explore.lkml"
# explore: advanced_example_ecommerce {} # Note: advanced_example_ecommerce is included above, so it exists in this model.

include: "/3_advanced_lookml/data_test_file.lkml"

### Advanced Concept: Aggregate Tables
# NOTE: The `include` and `explore` statements below are commented out because aggregate tables
# aren't supported unless persistent derived tables (PDTs) are enabled on the database connection.
# We chose to define the aggregate table separately like this so we can turn the aggregate table on or off
# without adjusting the main explore code.
# To use the aggregate table, we would enable PDTs on the database connection, then uncomment these lines:
###
# include: "/3_advanced_lookml/agg_table_file.lkml"
# explore: +advanced_example_ecommerce {
#  extends: [an_agg_table_for_order_items]
# }
