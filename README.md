# IPL_Analysis_GCP

Project Overview:
This repository contains the IPL Data Analysis project, which demonstrates the use of Google Cloud Platform (GCP) services to analyze the Indian Premier League (IPL) dataset. The project showcases an end-to-end data pipeline that includes data storage, preprocessing, querying, and visualization to extract insights into cricket matches, player performances, and strategic elements.

Technologies Used:
* Google Cloud Storage: For storing raw and processed data.
* Apache Spark on Vertex AI: For data preprocessing and analysis.
* Google BigQuery: For executing SQL queries to analyze data.
* Looker Studio: For visualizing the data and sharing insights.

To replicate this project:
* Set up GCP: Ensure you have a Google Cloud account. Set up Google Cloud Storage and BigQuery.
* Clone the repository: Use git clone [repo-link] to download the project.
* Dataset Link: https://data.world/raghu543/ipl-data-till-2017
* Data Preparation: Upload the IPL dataset to your GCP bucket.
* Run Spark Jobs: Execute the Jupyter notebooks in Vertex AI to preprocess the data.
* Load to BigQuery: Upload the processed data from GCP bucket to BigQuery.
* Execute SQL Queries: Run the SQL queries located in the BigQuery.sql file.
* Visualize: Create dashboards in Looker Studio.
  
Challenges Encountered:
* Integration issues with Databricks and Docker due to compatibility with GCP.
* Required manual definition of data schemas in Spark to ensure accurate data types.
* Learning curve associated with PySpark.
