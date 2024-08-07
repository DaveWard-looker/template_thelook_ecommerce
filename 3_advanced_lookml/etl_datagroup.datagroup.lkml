# Datagroups are used to define caching policies and persisted table rebuild schedules.
# Documentation:
#   https://cloud.google.com/looker/docs/caching-and-datagroups
#   https://cloud.google.com/looker/docs/reference/param-model-datagroup

datagroup: etl_datagroup {
  # Looker will run the sql_trigger query on a recurring schedule. Whenever the result changes,
  # the datagroup is considered 'triggered' (the old cache is retired and persistent derived tables begin rebuilding).
  # This example is very general and would result in Looker ignoring all cached results whenever it sees a new ETL job
  # has completed. Real-world examples may filter to particular jobs that relate to a particular data domain,
  # and would use different datagroups with different Explores.
  sql_trigger: SELECT max(completed_at) FROM my_etl_jobs ;;
  max_cache_age: "24 hours" # Tells Looker to ignore cached query results if they are over a certain age. `max_cache_age` is best used for performance optimization of a near-real-time data source.
  description: "Triggered when new ID is added to ETL log"
}
