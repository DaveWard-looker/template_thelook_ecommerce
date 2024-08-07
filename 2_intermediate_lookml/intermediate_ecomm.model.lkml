### Intermediate ecomm model file
# See the INTERMEDIATE_LOOKML_README.md document for overall concepts and the business example
###

connection: "sample_bigquery_connection"

label: "Z) Sample LookML"

# Note that the two similar-but-different Explores are defined in their own files.
# The `include` parameters below bring the Explore files in to this model file.
include: "/2_intermediate_lookml/intermediate_example_ecommerce.explore.lkml"
# explore: intermediate_example_ecommerce {
# }
# Note: intermediate_example_ecommerce is included above, so it exists in this model.

# IMPORTANT CONCEPT NOTE:
# Open the Explore LookML files side by side.
# You will see that the 'Valid Only' Explore uses the SAME view files,
# but some of the parameters are different.
# This type of object re-use is a core benefit of LookML.
include: "/2_intermediate_lookml/intermediate_example_ecommerce_validated_orders.explore.lkml"
# explore: intermediate_example_ecommerce_validated_orders {
# }
# Note: `intermediate_example_ecommerce_validated_orders` is included above, so it exists in this model.
