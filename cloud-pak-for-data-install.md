# Setup Analytics Zoo On IBM Cloud Pak for Data

Analytics Zoo is an open source project which is licensed under [Apache License 2.0](https://github.com/intel-analytics/analytics-zoo/blob/master/LICENSE).

## **Prerequisites**
To deploy Analytics Zoo on Cloud Pak for Data, the following prerequisites must be met:
1. Having an Cloud Pak for Data account with IBM and a working installation of Cloud Pak for Data on your cluster.
2. Having sufficient privileges to that cluster so that you can run kubectl/helm and log in to the Cloud Pak for Data internal docker registry.How to do this is described in the [Cloud Pak for Data Documentations](https://docs-icpdata.mybluemix.net/docs/content/SSQNUZ_current/com.ibm.icpdata.doc/zen/overview/overview.html)
3. The Analytics Zoo add-on is already bundled with required software which is enough for running deep-learning pipeline in Spark local mode. If you want to connect to another Spark cluster to do the AI pipeline with Analytics Zoo, please make sure it satisfies the software requirement including Spark 2.3.2, Python 3.6+, numpy<=1.14.5,>=1.13.3, tensorflow 1.10 on the cluster.
4. The minimum CPU requirement is 1 core.
5. The minimum memory request is 4G. 

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
2. Edit your /etc/hosts file on your system (Linux/MacOS) or equivalent (Windows) to add a DNS entry for the Cloud Pak for Data cluster you'll be connecting to (this is needed for the Docker steps below):
```bash
<IP to your Cloud Pak for Data cluster provided by your system administrator> mycluster.icp
Example:
169.55.96.201 mycluster.icp
```
3. Ensure that you have the correct Kubectl, Helm, Cloudctl, and Docker versions that you have downloaded directly from the Cloud Pak for Data environment.
```
If you haven't done so already, get the kubectl/helm/cloudctl binaries corresponding to your platform. Here are the versions used to validate these instructions:
Kubectl v1.11.1
Helm v2.9.1
Cloudctl v3.1.0-715+e4d4ee1d28cc2a588dabc0f54067841ad6c36ec9
Docker v18.06.1-ce
Those binaries can be downloaded from the Cloud Pak for Data cluster itself at:
<HTTPS address of your ICP4D cluster provided by your system administrator>:8443/api/cli/
Please refer to the ICP4D command line documentation for more information on those.
```
4. Edit your Docker configuration to allow the push to insecure registries:

* If using Linux, edit /etc/docker/daemon.json and add :
```bash
{ "insecure-registries" : ["mycluster.icp:8500"]} 
```

* If using Mac/Windows (with use of Docker Desktop):

    a. Find the Docker icon in the system status bar and click on the Preferences menu entry.

    b. Go to the Daemon tab and find the Insecure Registries entry list.
    
    c. Create an entry for mycluster.icp:8500
    
    d. Restart the Docker Daemon.
* NOTE: It isn't recommended to edit Docker config files manually when on Mac/Windows. It is recommended to use Docker Desktop.

5. From your terminal, pull the Analytics Zoo image form Dockerhub with:
```bash
docker pull intelanalytics/analytics-zoo:0.5.1-2.2.1-0.8.0-py3
```
6. Push the docker image from your node to the docker registry using the following commands:

    a. Tag the image
    ```bash
    docker tag intelanalytics/analytics-zoo:0.5.1-2.2.1-0.8.0-py3 mycluster.icp:8500/zen/intelanalytics/analytics-zoo:0.5.1-2.2.1-0.8.0-py3
    ```
    b. Push the image to the private image registry.
    ```bash
    docker push mycluster.icp:8500/zen/intelanalytics/analytics-zoo:0.5.1-2.2.1-0.8.0-py3
    ```

7. Clone the github repository intel-analytics/zoo-icpd to receive a copy of the helmchart. Browse to the helm charts directory.
```bash
git clone https://github.com/intel-analytics/zoo-icpd.git
cd zoo-icpd/helmchart/analytics-zoo
```
8. Install the helmchart archive:
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

## **Enable Analytics Zoo Add-on**
1. Create a configmap file using the cmg.bin file from the link(<binary_url>) provided by running the following command:
```bash
chmod +x cmg.bin && ./cmg.bin -p Intel -s analytics-zoo-analytics-zoo -n zen -v 0.5.1 -u /tree?token=1234qwer
```
Then you'll get a config map yaml file.

2. Use the generated config map in the following commmand on the Cloud Pak for Data Cluster:
```bash
kubectl create -f 
```
3. Verify if the Analytics Zoo add-on tile is enabled on the Cloud Pak for Data UI with 'Open' link and also the version number is 0.5.1.

## Using Analytics Zoo
After you enable the Analytics Zoo add-on, you can click "Open" link in the Analytics Zoo Add-on page, then you'll see the Jupyter notebook with analytics zoo. 

You can find many use cases/examples under current directory. Click one example and follow the README to open one notebook to run. 

Or you can create your own notebook with Analytics Zoo APIs to do your deep learning analytics. 

To get the detail information of how to use analytics zoo, please check [Analytics Zoo documentation](https://analytics-zoo.github.io)

## **Disable Analytics Zoo Add-on**
If you want to disable the Analytics Zoo add-on in your Cloud Pak for Data cluster, please do the following steps:

## **Uninstall Analytics Zoo Add-on**
To uninstall/delete the analytics-zoo deployment:
```bash
helm delete --purge analytics-zoo --tls
```