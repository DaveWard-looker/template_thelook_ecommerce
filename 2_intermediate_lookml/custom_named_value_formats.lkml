# You can use the named_value_format parameter to create custom formats.
# These formats can be defined in a model file, but it's better to define them once
# in their own file and then use the `include` parameter to pull the formats file into model files.

# This logic displays dollar values in K (thousands) with one decimal if the value is over 1000,
# otherwise it displays the full dollar amount
named_value_format: short_dollars {value_format: "[>=999.5]$#.0,\" K\";$#,##0"}
