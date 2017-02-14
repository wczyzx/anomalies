from __future__ import print_function

import urllib
import boto3
import zlib

TARGET_INPUT_STREAM='candidates-input-stream'

s3 = boto3.client('s3')
kinesis = boto3.client('kinesis')

def put_record_to_stream(record):
    """
    Funcion that puts record (string containing JSON data) to defined stream

    Args:
        record (string):
    """
    try:
        kinesis.put_record(StreamName=TARGET_INPUT_STREAM, Data=record, PartitionKey="partitionkey")
    except Exception as e:
        print ("Exception occurred when putting record to stream: %s", e)

def lambda_handler(event, context):
    """
    Main function that is triggered when file upload is detected on the bucket

    """
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.unquote_plus(event['Records'][0]['s3']['object']['key']).decode('utf8')
    try:
        response = s3.get_object(Bucket=bucket, Key=key)
        body = response['Body']
        data = body.read()
    except Exception as e:
        print ("Error getting object {} from bucket {}. Make sure they exist "
               "and your bucket is in the same region as this function.".format(key, bucket))
        raise e

    try:
        data = zlib.decompress(data, 16+zlib.MAX_WBITS) #dedompre
    except zlib.error:
        print ("Content couldn't be decompressed")

    lines = data.split("\n")
    
    for line in lines:
        print (line)
        put_record_to_stream(line)

    print ("Done processing")
