# NOSQL-GDELT
AWS - SPARK - CASSANDRA - GDELT DATABASE

![alt text](https://github.com/yamhiroto/NOSQL-GDELT/raw/master/GDELTProjectmainpage.png)

- - - -
## Objective
The purpose of this project was to design **a resilient and efficient distributed database / storage system**, 
able to contain and manage 1 year of Data from **the GDELT PROJECT** and using **AWS services such as S3, Elastic Compute Cloud (EC2) or Elastic MapReduce (EMR)**. The system had to be **resilient (fault tolerant)**. i.e. queries results had to stay unchanged even after shutting down one node of our cluster.

**Amount of data** : 1 year - roughly 7 Terabytes.

Among the tasks, we had to :
- Design a architecture that could meet the requirements 
- Implement it
- List the Pro and Cons of our solution
- Think about the limits and constraints. Explore where there are some rooms for improvement.

- - - -
### Context
This project was part of the curriculum of our Post-Master's Degree in Big Data at Telecom Paris.
Full curriculum and details on this Degree [here](
https://www.telecom-paris.fr/en/post-masters-degree/all-post-masters-degree/post-masters-degree-in-big-data "here").

### Duration
Less than two weeks, in January 2020

### Team Members
Name  | Github
------------- | -------------
Babacar Diouf | [badiouf](http://github.com/badiouf "badiouf")
Parfait Fangue  | [pfangue](http://github.com/pfangue "pfangue")
Guillaume Lehericy |
Hiroto Yamakakawa | [yamhiroto](http://github.com/yamhiroto "yamhiroto")


- - - -
### What is the GDELT Project ?
*A Global Database of Society
Supported by [GOOGLE_JIGSAW](http://jigsaw.google.com "GOOGLE Jigsaw") the GDELT Project monitors the world's broadcast, print, and web news from nearly every corner of every country in over 100 languages and identifies the people, locations, organizations, themes, sources, emotions, counts, quotes, images and events driving our global society every second of every day, creating a free open platform for computing on the entire world.*

 [Source](https://www.gdeltproject.org/ "Source")

- - - -

### Our Architecture proposal

![alt text](https://github.com/yamhiroto/NOSQL-GDELT/raw/master/architecture.png)

#### Description:
- Storage on **S3**
- NOSQL DBMS : **CASSANDRA** mounted **by hand on EMR** 
- Distributed and parallel data processing : **SPARK - SCALA** , premounted on EMR
- Exploration and ETL : **Zeppelin Notebook** premounted on EMR

*type of EMR clusters used* : 5 M5x.Large

#### Pros and Cons
-  Stable
-  Easy to implement thanks to EMR

- Currently only working efficiently for 1 month worth of data. The gkg table is very large, the jury suggested after our presentation to use a {key:Int , Value : String} dictionnary to map the long string to a single integer in order to reduce the processing load.
- Better visualisation framework ?

- - - -
### Important files

#### 0 - Columns_for_GDELT.ipynb 
Since the raw data returns a single long string called "value" for each row,
This files contains a small script (to run on Jupyter Notebook) which will help you create all the columns as described in the GDELT documentations  (here is one for the *events* table : [Link](http://data.gdeltproject.org/documentation/GDELT-Event_Codebook-V2.0.pdf "link") )
Simple, yet very useful ! :thumbsup:

#### 1 - gdeltETL.json
This script (json file to run on Zeppelin Notebook) will download the file **masterfile.txt** and **masterfile-translation.txt** in a EC2 Cluster with Spark and extract all the links included in those files. It will then download each file in the same cluster, copy that file to a S3 bucket and delete it from the EC2 once finished.
Thanks to the Regex, you can decide whether you want to download a day, a month or a year worth of Data.


#### 2 - gdeltExploration.json
This json file includes our codes written in SCALA in order to return the relevant data answering the queries. (Please note, most of the comments are still in French). The first 2 solutions are also written in Spark sql context.

Below the four queries, whose solutions were necessary to design the CASSANDRA tables :

1. Display the number of articles per event for each triplet (the day, the country where that event ocurred, the original language of that article).

2. For one country given as an input/parameter, display all the events that ocurred there, sorted by the number of mentions. 

3. For one source (gkg.SourceCommonName) given as an input/parameter, display all the themes,persons and locations that this selected source had talked about in its own articles, along with the number of articles and the average tone of those article ( for each theme, for each person and for each location (separately)). Design your solution to allow an aggregation per day, month, or even year. (*For this query, we decided to create 4 tables: one to answer the first part of the query and the three others to answer the second part.)*

4. Dislay the relations between two countries, based on the average tone of the articles mentionning both of the countries. Return the total number of articles and the average tone.  Design your solution to allow an aggregation per day, month, or even year and to filter the result by country.



#### 3 - gdeltCassandra_tables.json
This json file includes the code to create the CASSANDRA tables, which will store the data for each query.

#### 4 - traitement_v2.sh
This file is a small script to automate the installation of CASSANDRA on each node of the cluster.
Again, it's very handy to avoid this tedious task !

- - - -
### Other files

#### Directory ROOT
Original files for that project, if you want to start it from scratch. Intended to be used on AWS 

#### Directory Work on Local
Files appended to be used on a zeppelin DOCKER Container.
Useful if you want to explore the data on your local system, without using any AWS services (at least during the very beginning of your data exploration. We advise you to load only a single day of data. Beyond that, a cloud computing service is highly advised).

Link for the docker image https://hub.docker.com/r/apache/zeppelin/


- - - -
# Useful links 

http://andreiarion.github.io/projet2019.html  (Original link to the project. In French)

https://blog.gdeltproject.org/announcing-partitioned-gdelt-bigquery-tables/

https://blog.gdeltproject.org/google-bigquery-gkg-2-0-sample-queries/

https://blog.gdeltproject.org/getting-started-with-gdelt-google-cloud-datalab-simple-timelines/

https://blog.gdeltproject.org/a-compilation-of-gdelt-bigquery-demos/

http://data.gdeltproject.org/documentation/ISA.2013.GDELT.pdf
    
   

