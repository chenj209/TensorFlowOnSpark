# path to the SavedModel export
# shellcheck disable=SC2154
export MODEL_BASE=${TFoS_HOME}/mnist_export
# shellcheck disable=SC2155
export MODEL_VERSION=$(ls ${MODEL_BASE} | sort -n | tail -n 1)
export SAVED_MODEL=${MODEL_BASE}/${MODEL_VERSION}

# use a CSV formatted test example (reshaping from [784] to [28, 28, 1])
IMG=$(head -n 1 ${TFoS_HOME}/data/mnist/csv/test/part-00001 | python ${TFoS_HOME}/examples/utils/mnist_reshape.py)

# introspect model
saved_model_cli show --dir $SAVED_MODEL --all

# inference via saved_model_cli
saved_model_cli run --dir $SAVED_MODEL --tag_set serve --signature_def serving_default --input_exp "conv2d_input=[$IMG]"
