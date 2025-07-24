# Project description

In order to gauge your coding and analysis skills, we would like to ask you to create a solution that can receive data, persist it and make it available for querying.

The implementation should read source files in JSON format containing forecasts of power production in power plants. The data provided is realistic for the power generation sector and has been adapted for the purpose of this test. The following sample files are provided in pub_data1 folder structure, with each containing power generation forecasts in Megawatts, except for assets_structure.json which is a mapping file.

* pub_data1/assets_structure.json
* pub-data1/cob_total/20250325/provider-A.json
* pub-data1/cob_total/20250325/provider-B.json

assets_structure.json reveals the data structure. Assets are power plants. Each asset has multiple engines: turbines and pumps that can be identified by names. Files provider-A.json and provider-B.json contain power data in UTC time zone. For simplification the data is a forecast of power generation for all engine summed up  in provided assets. Data is obtained  from two competing provider agencies. Data files are stored in a folder structure cob_total/YYYmmdd (cob = close of business) indicating that such forecasts are produced once per day.

You can assume that the data format for the power forecast is well-defined and strictly respected across providers. However, the data may be incomplete (e.g. missing data, letters where numbers are expected).

The data files should be pushed to your solution via API call where the data is parsed and persisted.

Create a solution in **Java Spring Boot** with persisted storage that provides an API on top that implements data reads and writes.

1. Ingest forecast data into your schema given a file posted to the API with an endpoint:

`/forecast/{cob}?provider=$providerName`

The file will be processed from your defined configuration path. The response should have the number of inserts, updates, deletes whilst processing the file.

2. Retrieve power forecast data 
`/forecast/{cob}`

Parameters:
* provider: optional, if absent use the hierarchy described below
* start_datetime, end_datetime: mandatory 
* asset: mandatory 

The retrieval call should process and return the focast data according to a configurable hierarchy (unless an optional provider identifier is provided). For example, if the hierarchy is defined as "provider-A,provider-B" and there is no power data available from the first supplier (provider-A in this case), the implementation should use the data from the 2nd supplier e.g. provider-B. If a provider name is specified, then only that provider's data should be used. You will need to implement a means of dealing with missing values. For imputations use a forward fill method (LOCF) with the initial boundary value 0.0.

Please provide a **README.txt** file with your solution that documents your design choices and highlights any areas for future development needed to create a more complete solution. Include code comments for local implementation decisions or add notes to the README.txt for project-wide considerations.

Structure your code to support organic growth into a large-scale project. Design your implementation to handle larger data volumes efficiently - while the sample contains only 5 days of data, production systems routinely manage daily forecasts spanning many years over dozens of assets.

The estimated time investment for this project is 4-6 hours. Use **multiple TODO comments** throughout your code to mark areas for future improvement that would be too time-consuming to implement within the current scope.

For submission, provide your source code as a developed local git repository. Exclude unnecessary files such as build artifacts, external packages, personal settings, and unused boilerplate code. Compress the folder and upload it to a public file sharing service (Google Drive, OneDrive, iCloud Drive, Dropbox), then email the public downloadable url to metis_entsoe_pro@alpiq.com.


You can use the provided `test-api-pub.sh` bash script  to persist the data and test first few retrieved foreast values.


**NOTE**: These requirements while opinionated on technology are relatively open to interpretation, allowing you to make independent design and implementation decisions that best fit the solution requirements. For data persistence if you decide to use JPA, consider using an in-memory Java H2 database for the simplicity.

# Required items

* Working solution with source code files (no binaries)
* Code-driven data persistence setup
* Tests demonstrating expected functionality of the delivered solution

# Good to have items

* Data validation checks

