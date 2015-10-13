#Downloading and Installing Hadoop
Type This   It Means
touch testfile.txt  create an empty file name testfile.txt
echo "Hello world in HDFS" >> testfile.txt  display the line of text that is being inserted into the newly created testfile
cat testfile.txt    read and print out the file
hdfs -dfs -put testfile.txt  put the file into HDFS

Low-cost
scalable
fault-tolerant
flexible

###Use the cloudera quick-start vm
Open the VMWare application
Open a tab and go into HUE
hue username:cloudera
hue password:cloudera

**HUE** is the open source web-interface to Hadoop

open a terminal using the terminal icon that is at the top of thevirtual machine window (a picture of a small temrinal)

###Ingesting data into HDFS
touch test.txt
echo "Hello world in HDFS" >> testfile.txt
hdfs dfs -put testfile.txt  
hdfs dfs -get /home/cloudera/testfile.txt (bring it from hdfs to local)
hdfs dfs ls /home/cloudera

put the file into HDFS

#Exercise /home/cloudera/wordcount.txt

#Cloudera Tutorial For Workflow
Sqoop can automatically load our relational data from MySQL into HDFS, while preserving the structure.
Impala is the open source analytic query engine included with CDH.
We may want to leverage the power of apache Avro file format for other workloads on the cluster (as Avro is a Hadoop optimized file format), we will take a few extra steps than before to load this data into Impala using the Avro file format. 

1. Open a terminal:
2. launch the following **Sqoop** job:
    sqoop import-all-tables -m 1 --connect jdbc:mysql://quickstart:3306/retail_db --username=retail_dba --password=cloudera --compression-codec=snappy --as-avrodatafile --warehouse-dir=/user/hive/warehouse

This command is launching MapReduce jobs to export the data from our MySQL database, and put those export files into Avro format in HDFS. It is also creating the Avro schema, so that we can easily load our Hive tables for use in Impala later.

3. Confirm that your Avro data files exist in HDFS
    
    hadoop fs -ls /user/hive/warehouse

    hadoop fs -ls /user/hive/warehouse/categories/

At this point, sqoop has created schema files for this data in your home directory
    
    ls -l *.avsc

This command shows the .avsc files for the six tables that were in our retail_db data base in SQL

The schema and the data are stored in separate files. The schema is only applied when the data is queried, a technique called schema-on-red. This gives you the flexibility to query the data with SQL while it is still in a format usable by other systems as well. 

Now we need to specify how the structure of the data should be interpreted.

Apache Hive will need the schema files too, solet's copy them into HDFS where Hive can easily access them. 

    sudo -u hdfs hadoop fs -mkdir /user/examples
    sudo -u hdfs hadoop fs -chmod +rw /user/examples
    hadoop fs -copyFromLocal ~/*.avsc /user/examples/

Now that we have the data we cna prepare it to be queried. We are going yo do so using Impala, but you may notice that we imported the data ino Hive's directories. Hive and Impala both read their data from files in HDFS, and they even share metadata about the tables. The difference is that Hive executes queries by compliling them to MapReduce jobs. Impala is an MPP query engine that reads data directly from the file system itself. 

##Query structured Data
We will use Hue's Impala app to create the metadata for our tables in Hue, and then query them.
Hue provides a web-based interface for many of the tools in CDH and can be found on port 8888 of you Master Node. 

Inside Hue, click on Query Editors and open Impala Query Editor.

##Correlate Structured Data with Unstructured Data

