# Import Yago4 into Neo4j v4 with Neosemantics

0. Prerequisite: OpenJDK 11. If you run ubuntu with root you can use

   ```
   apt-get install default-jdk
   ```
   
   Otherwise, consider using docker : https://hub.docker.com/_/openjdk
   
   Third option, not recommended, you can install Java in userspace, you will have to play around with terminal configuration. Here is a starting point under "Installing OpenJDK Manually": https://dzone.com/articles/installing-openjdk-11-on-ubuntu-1804-for-real


1. Get Neo4j v4.0.X Community server and install Neosemantics plugin
    
    ```
    ./get-neo4j.sh
    ```

2. Download Yago4 Files, uncompress, ready to be imported

   ```
   ./download-yago.sh yago_files.txt
   ```
   
3. Configure neosemantics, add required index, and finally load data
   
   ```
   ./import-yago.sh
   ```
   
4. Test data is all right:

     - Count nodes
        ```
        ${NEO4J_HOME}/bin/cypher-shell -u neo4j -p 'admin' "MATCH (r:Resource) RETURN COUNT(r)"
        ```
        
     - Example node-edges
        ```
        ${NEO4J_HOME}/bin/cypher-shell -u neo4j -p 'admin' "MATCH (r1:Resource)-[l]->(r2:Resource) RETURN r1, l, r2 LIMIT 20"
        ```


