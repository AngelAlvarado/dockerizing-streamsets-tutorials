# Dockerizing Streamsets tutorials

This branch takes care of setting up the Streamsets datacollector [tutorial 2](https://github.com/streamsets/tutorials/tree/master/tutorial-2) via Docker.

## Requirements:

* Docker
* Docker compose
* Streamsets [sample data](https://github.com/streamsets/tutorials/blob/master/sample_data/ccsample). Place it into the folder: streamsets/data/tutorial_data

## Instructions:

Once this repo has been cloned and sample data has been downloaded, open your command line and initialize the docker containers using: $ docker-compose up. This can take a while.

Once the containers are up and running import.

1.-Import the producer [pipeline](producer.json) and consumer [pipeline](consumer.json) into streamsets by going to http://localhost:18630

You should see the following pipelines (Filesystem was used instead of AWS S3)

[![consumer](images/consumer.png?raw=true)](images/consumer.png)
[![producer](images/producer.png?raw=true)](images/producer.png)

Preview or Start the pipelines right away.

[![start-pipeline](images/preview-start-pipeline.png?raw=true)](images/preview-start-pipeline.png)

Access Kibana via http://localhost:5601.

This is what the folder structure should look like after including the necesary data and executing the pipeline:

```
.
├── build
│   ├── Dockerfile
│   └── start.sh
├── consumer.json
├── docker-compose.yml
├── images
│   ├── ...
├── producer.json
├── readme.md
├── streamsets
│   ├── Dockerfile
│   ├── data
│       ├── pipelines
│       │   └── ...
│       ├── runInfo
│       │   └── ...
│       ├── sdc.id
│       └── tutorial_data
│           ├── ccsample
```
