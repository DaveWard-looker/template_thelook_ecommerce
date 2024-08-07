<h1><span style="color:#2d7eea">Welcome to the Looker Sample Project!</span></h1>

This LookML project is a functional example for you to play with and learn from. Going through the examples in this project will help you understand the capabilities of Looker and the power of LookML. However, the Looker sample project is not a complete tutorial. For a more complete training course, check out the [Google Cloud Skills Boost](https://www.cloudskillsboost.google/course_templates/327).

See the [Git and navigation README](/projects/sample_thelook_ecommerce/files/0_start_here/_GIT_AND_NAVIGATION_README.md) for more information about using this code editor. You can find this file in the File Browser at left.

The Looker application uses SQL and configuration options written in LookML to scalably manage how data is presented to users when they are analyzing data or using dashboards.

This project is based on [thelook eCommerce](https://console.cloud.google.com/marketplace/product/bigquery-public-data/thelook-ecommerce) BigQuery public dataset --- a fictional ecommerce website with data about users, orders, items, and so on. It uses a pre-installed connection, which you can see [here](/admin/next/connections). When you're ready to get started with your own data, check out the docs for [connecting Looker to your database](https://cloud.google.com/looker/docs/connecting-to-your-db).

For teaching purposes, this project is presented in **Basic**, **Intermediate**, and **Advanced** sections. You should see the folder for each section in the File Browser at left. Note that each folder has a dedicated README with more detailed info.

<h3><span style="color:#2d7eea">Basic</span></h3>
This section focuses on these foundational LookML concepts:
- Overview of basic file types (models and views) and the hierarchy of logical objects (Explores, views, and fields)
- Creating a new basic dimension and measure
- Joining tables together in an Explore

<h3><span style="color:#2d7eea">Intermediate</span></h3>

This section uses the same dataset as the Basic section with better usability customizations applied:

- Labeling objects for clarity
- More derived fields, including special field types (filtered measures and tier fields)
- Using a SQL derived table for pre-aggregation (also known as a subquery)
- Reusing views in multiple Explores
- Common Explore parameters

<h3><span style="color:#2d7eea">Advanced</span></h3>
The Advanced section goes further in terms of LookML support for specialized end user capabilities.  We also demonstrate  object re-use by refining and extending the objects from the Basic and Intermediate sections.
- Inheritance - Extending and refining existing LookML objects for use in a different context
- Using a native derived table (NDT) for pre-aggregation
- Using parameters to create custom filter behavior
- A bare-join approach that facilitates keeping views independent of one another
