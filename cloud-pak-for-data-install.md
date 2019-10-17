# Setup Analytics Zoo On IBM Cloud Pak for Data

Analytics Zoo is an open source project which is licensed under [Apache License 2.0](https://github.com/intel-analytics/analytics-zoo/blob/master/LICENSE).

## **Prerequisites**
To deploy Analytics Zoo on Cloud Pak for Data, the following prerequisites must be met:
1. Having an Cloud Pak for Data account with IBM and a working installation of Cloud Pak for Data on your cluster.
2. Having sufficient privileges to that cluster so that you can run kubectl/helm and log in to the Cloud Pak for Data internal docker registry.How to do this is described in the [Cloud Pak for Data Documentations](https://docs-icpdata.mybluemix.net/docs/content/SSQNUZ_current/com.ibm.icpdata.doc/zen/overview/overview.html)
3. The Analytics Zoo add-on is already bundled with required software which is enough for running deep-learning pipeline in Spark local mode. If you want to connect to another Spark cluster to do the AI pipeline with Analytics Zoo, please make sure it satisfies the software requirement including Spark 2.3.2, Python 3.6+, numpy<=1.14.5,>=1.13.3, tensorflow 1.10 on the cluster.
4. The minimum CPU requirement is 4 core.
5. The minimum memory request is 20G. 

## **Work Flow**
Deploying Analytics Zoo on IBM Cloud Pak for Data uses the following workflow:

1. After logging into your cluster with your Cloud Pak for Data credentials in your web browser, find Analytics Zoo in the Add-ons section.
2. Open the menu in the corner of the Analytics Zoo tile and click Get Started.
3. You are then forwarded in your browser to this page (the one you are reading).

## **Installation**
Follow the steps to have the Analytics Zoo up and running on your cluster.

1.  SSH to the Cloud Pak for Data cluster
```
ssh root@<cloud-pak-for-data-cluster-master-node>
```
2. Clone the github repository intel-analytics/zoo-icpd to receive a copy of the helmchart. Browse to the helm charts directory.
```bash
git clone https://github.com/intel-analytics/zoo-icpd.git
cd zoo-icpd/helmchart/analytics-zoo
```
3. Install the helmchart archive:
```bash
helm install . --name analytics-zoo --namespace zen --tls
```
Run the following kubectl commands to verify the deployment.
```bash
kubectl get svc -n zen|grep analytics-zoo
kubectl get pod -n zen|grep analytics-zoo
kubectl describe pod <the_pod_it_made> -n zen
```
```bash
kubectl describe svc analytics-zoo-analytics-zoo -n zen
```
From the output of above command, you can find the NodePort of the service. You can use this port to access analytics zoo service in web browser. 

## Using Analytics Zoo
After you install the Analytics Zoo add-on, you can input http://Your_Cluster_Address:Analytics_Zoo_NodePort/tree?token=1234qwer in the web browser, then you'll see the Jupyter notebook with analytics zoo. 

You can find many use cases/examples under current directory. Click one example and follow the README to open one notebook to run. 

Or you can create your own notebook with Analytics Zoo APIs to do your deep learning analytics. 

To get the detail information of how to use analytics zoo, please check [Analytics Zoo documentation](https://analytics-zoo.github.io)

## **Uninstall Analytics Zoo Add-on**
To uninstall/delete the analytics-zoo deployment:
```bash
helm delete --purge analytics-zoo --tls
```