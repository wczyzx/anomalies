# anomalies
This Python project contains a set of functions and scripts for simulating and notifying about anomalies detection in candidates' accuracy using AWS cloud (S3, Kinesis)

## Features
* Generates random JSON data with defined frequency
* Uploads files to S3 bucket
* Detects anomalies in generated data
* Notifies about detected anomalies by e-mail

## Prerequisites
* Some of these functions and scripts require to be run and configured directly on AWS cloud
* AWS cloud account must be properly configured
* All the configuration and usage of particular scripts described in `Technical Assignment Anomaly detection in AWS` document which is confidential
* Boto3 library used in this project requires creating proper `~/.aws/config` and `~/.aws/credentials` files befor using it (better desctibed here: http://boto3.readthedocs.io/en/latest/guide/quickstart.html#configuration)

## Installation
This instruction reffers only to the `anomalies.py` which can be run locally. Running and configuring other scripts described in previously mentioned `Technical Assignment Anomaly detection in AWS` document.
There is a runner script `run.sh` located in `./deploy/` directory. The script installs the required dependencies and run the script.

Before running the script there should be proper configuration provided in `anomalies.cfg` configuration file.

## Config file structure
There is a `anomalies.cfg` file with the following structure:

```
[General]
filename-pattern: data-feed-{}.json.gz      #can be modified
timestamp-format: %Y-%m-%d-%H_%M_%S
upload-interval: 6
anomalies-frequency: 2
package-size: 20

[AWS]
bucket-name: values
```

where:

* filename-pattern - pattern of a file to be sent (str) 
* timestamp-format - format of timestamp used in filename-pattern (str)
* upload-interval - value [seconds] that stands for the interval between creating and uploading separate gzipped files with generated data (int)
* anomalies-frequency - value [percents] for the probability of generating data with anomalies (int)
* package-size - number of records stored in one data-feed package (int)
* bucket-name - name of a bucket where files should be uploaded to (str)

## Example usage

```bash
./deploy/run.sh
```

## Useful links
* http://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-create-and-update-a-trail.html 
* http://docs.aws.amazon.com/streams/latest/dev/learning-kinesis-module-one-create-stream.html
* http://docs.aws.amazon.com/lambda/latest/dg/getting-started.html
* http://docs.aws.amazon.com/kinesisanalytics/latest/dev/app-anomaly-detection.html
* https://aws.amazon.com/blogs/big-data/real-time-clickstream-anomaly-detection-with-amazon-kinesis-analytics/
* https://aws.amazon.com/blogs/big-data/real-time-clickstream-anomaly-detection-with-amazon-kinesis-analytics 

##TODO
* cover the functions with unit tests
* refactor the code to be more generic
* add more complex error handling and logging