-- ** Anomaly detection **
-- Compute an anomaly score for each record in the source stream using Random Cut Forest
-- Creates a temporary stream and defines a schema
CREATE OR REPLACE STREAM "TEMP_STREAM" (
   "name"        VARCHAR(16),
   "accuracy"        INTEGER,
   "ANOMALY_SCORE"  DOUBLE);
-- Creates an output stream and defines a schema
CREATE OR REPLACE STREAM "DESTINATION_SQL_STREAM" (
   "name"        VARCHAR(16),
   "accuracy"        INTEGER,
   "ANOMALY_SCORE"  DOUBLE);
 
-- Compute an anomaly score for each record in the source stream
-- using Random Cut Forest
CREATE OR REPLACE PUMP "STREAM_PUMP" AS INSERT INTO "TEMP_STREAM"
SELECT STREAM "name", "accuracy", "ANOMALY_SCORE" FROM
  TABLE(RANDOM_CUT_FOREST(
    CURSOR(SELECT STREAM * FROM "SOURCE_SQL_STREAM_001")
  )
) where ANOMALY_SCORE>3;
-- Sort records by descending anomaly score, insert into output stream
CREATE OR REPLACE PUMP "OUTPUT_PUMP" AS INSERT INTO "DESTINATION_SQL_STREAM"
SELECT STREAM * FROM "TEMP_STREAM"
ORDER BY FLOOR("TEMP_STREAM".ROWTIME TO SECOND), ANOMALY_SCORE DESC;
