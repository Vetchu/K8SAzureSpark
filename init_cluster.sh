#!/bin/bash
set -ex
# terraform apply -auto-approve
terraform output kube_config > ./azurek8s
export KUBECONFIG=./azurek8s
kubectl get nodes
 
#=================spark

# create new job in spark-job namespace
kubectl apply -f spark-pi.yaml
sleep 60

#watch this job running
kubectl logs spark-pi-driver -f -n spark-jobs
export SPARK_MASTER=$(echo "http://$(kubectl get pods -n spark-operator -o yaml | yq r - items[0].status.podIP):$(kubectl get pods -n spark-operator -o yaml | yq r - items[0].spec.containers[0].ports[0].containerPort)")
echo $SPARK_MASTER				
envsubst < spark-jobserver.yaml | kubectl apply -f - -n default
echo "Spark ready"

#==================kafka

# cat << EOF | kubectl apply -f -
# apiVersion: v1
# kind: Namespace
# metadata:
#   name: kafka
# EOF
# kubectl apply -f https://strimzi.io/install/latest?namespace=kafka -n kafka
# kubectl apply -f https://strimzi.io/examples/latest/kafka/kafka-persistent-single.yaml -n kafka 
# kubectl wait kafka/my-cluster --for=condition=Ready --timeout=300s -n kafka 
echo "Kafka ready"
## for testing kafka
#kubectl -n kafka run kafka-producer -ti --image=strimzi/kafka:0.17.0-kafka-2.4.0 --rm=true --restart=Never -- bin/kafka-console-producer.sh --broker-list my-cluster-kafka-bootstrap:9092 --topic my-topic
#kubectl -n kafka run kafka-consumer -ti --image=strimzi/kafka:0.17.0-kafka-2.4.0 --rm=true --restart=Never -- bin/kafka-console-consumer.sh --bootstrap-server my-cluster-kafka-bootstrap:9092 --topic my-topic --from-beginning


#====================neo4j

helm install stable/neo4j --set acceptLicenseAgreement=yes --set neo4jPassword=mySecretPassword --wait

## for running in neo4j
# kubectl run -it \
# --rm cypher-shell \
# --image=neo4j:3.2.3-enterprise \
# --restart=Never --namespace default \
# --command -- ./bin/cypher-shell \
# 	-u neo4j -p mySecretPassword \
# 	--a turbulent-uakari-neo4j.default.svc.cluster.local \
# 	"call dbms.cluster.overview()" 


echo "DONE INSTALLING CLUSTER"
