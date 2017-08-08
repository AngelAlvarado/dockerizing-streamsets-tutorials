# Dockerizing Streamsets tutorials

While learning streamsets data collector I decided to dockerize the whole process to quickly replicate my pipelines. This repo takes care of setting up the Streamsets datacollector [tutorial 1](https://github.com/streamsets/tutorials/tree/master/tutorial-1) via Docker.

## Requirements:

* Docker
* Docker compose
* [GeoLite2](http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz) database. Place it into: thisrepo/tutorial_data/
* Streamsets [sample data](https://github.com/streamsets/tutorials/tree/master/sample_data). Place it into the folder: thisrepo/tutorial_data/sample_data

## Instructions:

Once this repo has been cloned and Geolite and Sample Data has been placed, open your command line and initialize the docker containers using: $ docker-compose up. This can take a while.

Once the containers are up and running you’ll to execute only one step manually to kick off the datacollector and have the whole pipeline working.

1.-Import the [pipeline](tutorial1_pipeline.json) into streamsets by going to http://localhost:18630

[![importing-pipeline](images/import-pipeline-streamsets.png?raw=true)](images/import-pipeline-streamsets.png) 

* You can use a custom name and description.

You should see the following pipeline

[![pipeline](images/complete-pipeline-streamsets.png?raw=true)](images/complete-pipeline-streamsets.png)

Preview or Start the pipeline right away.

[![start-pipeline](images/preview-start-pipeline.png?raw=true)](images/preview-start-pipeline.png)


Access Kibana via http://localhost:5601.

A [Dashboard](http://localhost:5601/app/kibana#/dashboard/ApacheWeblog-Dashboard) and individual visualizations will be created automatically during the docker build.

[![dashboard](images/dashboard.png?raw=true)](images/dashboard.png)

This is what the folder structure should look like after including the necesary data and executing the pipeline:

```
.
├── build
│   ├── Dockerfile
│   └── start.sh
├── docker-compose.yml
├── images
│   ├── ...
├── readme.md
├── streamsets
│   ├── Dockerfile
│   ├── pipelines
│   │   └── ...
│   ├── runInfo
│   │   └── ...
│   ├── sdc.id
│   └── tutorial_data
│       ├── GeoLite2-City09012016.mmdb
│       └── sample_data
│           ├── access_log_20151221-101535.log.gz
│           ├── ...
└── tutorial1_pipeline.json
```
