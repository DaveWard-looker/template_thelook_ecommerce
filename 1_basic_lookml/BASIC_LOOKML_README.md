<span style="background-color:aliceblue">
**You Are Here**: You are reading the README that explains BASIC LookML concepts and the examples in the folder 1_basic_lookml.
For an overview of the whole sample project, head back to [START_HERE_README](/projects/sample_thelook_ecommerce/files/0_start_here/START_HERE_README.md).
</span>

This **Basic** section (1_basic_lookml folder) focuses on the most foundational concepts in LookML and is not far removed from the typical auto-generated code you will start with when setting up your own data source.

First, let's take a moment to get oriented to the environment and talk about the broader context.

<h2><span style="color:#2d7eea">The End User Experience You Are Building: Exploring Data</span></h2>

Ad hoc data discovery is one of Looker’s most powerful and unique features. Looker enables analysts to freely explore data and build dashboards, within governed datasets that you set up.

You can try the **Explore** that is defined in the basic section here: [Direct Link to Basic Explore](/explore/basic_ecomm/basic_order_items?fields=basic_order_items.created_at_date,basic_order_items.count&fill_fields=basic_order_items.created_at_date&sorts=basic_order_items.created_at_date+desc&limit=500&column_limit=50&vis=%7B%22x_axis_gridlines%22%3Afalse%2C%22y_axis_gridlines%22%3Atrue%2C%22show_view_names%22%3Afalse%2C%22show_y_axis_labels%22%3Atrue%2C%22show_y_axis_ticks%22%3Atrue%2C%22y_axis_tick_density%22%3A%22default%22%2C%22y_axis_tick_density_custom%22%3A5%2C%22show_x_axis_label%22%3Atrue%2C%22show_x_axis_ticks%22%3Atrue%2C%22y_axis_scale_mode%22%3A%22linear%22%2C%22x_axis_reversed%22%3Afalse%2C%22y_axis_reversed%22%3Afalse%2C%22plot_size_by_field%22%3Afalse%2C%22trellis%22%3A%22%22%2C%22stacking%22%3A%22%22%2C%22limit_displayed_rows%22%3Afalse%2C%22legend_position%22%3A%22center%22%2C%22point_style%22%3A%22none%22%2C%22show_value_labels%22%3Afalse%2C%22label_density%22%3A25%2C%22x_axis_scale%22%3A%22auto%22%2C%22y_axis_combined%22%3Atrue%2C%22show_null_points%22%3Atrue%2C%22interpolation%22%3A%22linear%22%2C%22series_types%22%3A%7B%7D%2C%22type%22%3A%22looker_line%22%2C%22defaults_version%22%3A1%7D&filter_config=%7B%7D&origin=share-expanded)

<h2><span style="color:#2d7eea">Benefits of Looker and LookML</span></h2>
**Looker and LookML Empower End Users**
LookML condenses and encapsulates the complexity of SQL. It lets analysts get the knowledge about what their data means "out of their heads" so that others can use it. This enables non-technical users to do their jobs -- building dashboards, drilling to row-level detail, and accessing complex metrics -- without having to worry about what’s behind the curtain.

**Looker and LookML Allow for Data Governance**
By defining business metrics in LookML, you can ensure that Looker is always a credible single source of truth.

**Looker and LookML Are All About Reusability**
Most data analysis requires the same work to be done over and over again. You extract raw data, prepare it, and deliver an analysis. With LookML, once you define a dimension or a measure the first time, you can continue to build on it, rather than having to rewrite it again and again.

<h2><span style="color:#2d7eea">LookML Object Hierarchy</span></h2>
You will encounter several different types of logical objects as shown in the following image.
![Parts of a Project](https://cloud.google.com/static/looker/docs/images/lookml_object_hierarchy.png "Parts of a Project")

In this **Basic** section (1_basic_lookml), we focus on models, Explores, joins, and views: We have an **Explore** (basic_ecomm) that **joins** two **views** (basic_order_items and basic_users).

Learn about these objects by following steps in **What's Next**.

---

<h1><span style="color:#2d7eea">What's Next</span></h1>

Suggested Next Steps:

1. **Go to the [Business Pulse - Basic](/dashboards/1) Dashboard** built using queries on that Explore.

2. **Go to the [Basic Ecommerce](/explore/basic_ecomm/basic_order_items) Explore** -- the query building and ad hoc analysis environment. You can also use an existing dashboard tile as a starting point (use **Explore from here** on the tile menu).

3. **Go to the LookML files in the 1_basic_lookml folder**.

- The model file where the Explore is defined -- Open [basic_ecomm.model](/projects/sample_thelook_ecommerce/files/1_basic_lookml/basic_ecomm.model.lkml) alongside [Model Companion README](/projects/sample_thelook_ecommerce/files/1_basic_lookml/BASIC_MODEL_COMPANION_README.md). You can open multiple editor windows in different browser tabs.
- An example view file -- Open [basic_order_items.view](/projects/sample_thelook_ecommerce/files/1_basic_lookml/basic_order_items.view.lkml) (.model file) alongside [Model Companion README](/projects/sample_thelook_ecommerce/files/1_basic_lookml/BASIC_VIEW_COMPANION_README.md).

After you've reviewed this 1_basic_lookml section, you can learn more advanced capabilities and techniques in the intermediate section, by **going to [INTERMEDIATE LOOKML README](/projects/sample_thelook_ecommerce/files/2_intermediate_lookml/INTERMEDIATE_LOOKML_README.md)**.

---

<h1><span style="color:#2d7eea">Additional Resources</span></h1>

To learn more about LookML and how to develop, visit:

- [Looker User Guide](https://looker.com/guide)
- [Looker Help Center](https://help.looker.com)
- [Google Cloud Skills Boost](https://www.cloudskillsboost.google/course_templates/327)
