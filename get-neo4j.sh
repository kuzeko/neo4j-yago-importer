#!/bin/bash

NEO4J_VERSION=4.0.4
rm -rf neo4j-server
wget https://neo4j.com/artifact.php?name=neo4j-community-$NEO4J_VERSION-unix.tar.gz -O neo4j.tar.gz
tar xf neo4j.tar.gz
mv neo4j-community-$NEO4J_VERSION neo4j-server
rm neo4j.tar.gz


export NEO4J_HOME=${PWD}/neo4j-server
export NEO4J_DATA_DIR=${NEO4J_HOME}/data


rm -rf $NEO4J_DATA_DIR


if [ ! -f ${NEO4J_HOME}/plugins/neosemantics-4.0.0.1.jar ]
then
    echo "Downloading Neo4j RDF plugin..."
    wget -P ${NEO4J_HOME}/plugins/ https://github.com/neo4j-labs/neosemantics/releases/download/4.0.0.1/neosemantics-4.0.0.1.jar
fi
echo "Installing Neo4j RDF plugin..."
echo 'dbms.unmanaged_extension_classes=n10s.endpoint=/rdf' >> ${NEO4J_HOME}/conf/neo4j.conf

${NEO4J_HOME}/bin/neo4j start
sleep 10


$NEO4J_HOME/bin/neo4j-admin set-initial-password admin


$NEO4J_HOME/bin/neo4j restart
sleep 10

ulimit -n 65535
echo "Creating index"
${NEO4J_HOME}/bin/cypher-shell -u neo4j -p 'admin' "CREATE CONSTRAINT n10s_unique_uri ON (r:Resource) ASSERT r.uri IS UNIQUE;"

${NEO4J_HOME}/bin/cypher-shell -u neo4j -p 'admin' 'call n10s.graphconfig.init( { handleMultival: "ARRAY",  handleVocabUris: "SHORTEN", keepLangTag: false, handleRDFTypes: "NODES" })'


echo Neo4j log:
tail -n 12 $NEO4J_HOME/logs/neo4j.log