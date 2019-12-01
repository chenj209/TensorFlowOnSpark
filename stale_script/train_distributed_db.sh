# Convert the MNIST zip files into CSV (if not already done)
cd ${TFoS_HOME}
${SPARK_HOME}/bin/spark-submit \
--master ${MASTER} \
--jars ${TFoS_HOME}/lib/tensorflow-hadoop-1.0-SNAPSHOT.jar \
${TFoS_HOME}/examples/mnist/mnist_data_setup.py \
--output ${TFoS_HOME}/data/mnist

# confirm that data was generated
ls -lR ${TFoS_HOME}/data/mnist/csv

# remove any old artifacts
rm -rf ${TFoS_HOME}/mnist_model
rm -rf ${TFoS_HOME}/mnist_export

# train
${SPARK_HOME}/bin/spark-submit \
--master ${MASTER} \
--conf spark.cores.max=${TOTAL_CORES} \
--conf spark.task.cpus=${CORES_PER_WORKER} \
--conf spark.eventLog.enabled=true \
--conf "spark.history.fs.logDirectory =file:/tmp/spark-events" \
${TFoS_HOME}/examples/mnist/keras/mnist_spark.py \
--cluster_size ${SPARK_WORKER_INSTANCES} \
--images_labels ${TFoS_HOME}/data/mnist/csv/train \
--model_dir ${TFoS_HOME}/mnist_model \
--export_dir ${TFoS_HOME}/mnist_export
