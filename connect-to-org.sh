#!/bin/bash

echo "Project Name: "
read project_name
echo "Creating Project $project_name..."
sfdx force:project:create --manifest --projectname $project_name
cd $project_name
mkdir notes

echo "Is this for a Sandbox (s) or Production (p) org?"
read org_type
while [ "$org_type" != "s" ] && [ "$org_type" != "p" ]
do
    echo "Unrecognized answer: Is this for a Sandbox (s) or Production (p) org?"
    read org_type
done

echo "Please enter an alias for this org:"
read org_alias
if [ "$org_type" == "s" ]
then
    echo "Authenticating Sandbox org..."
    sfdx force:auth:web:login --setalias $org_alias --instanceurl \
        https://test.salesforce.com --setdefaultusername
else
    echo "Authenticating Production org..."
    sfdx force:auth:web:login --setalias $org_alias --instanceurl \
        https://login.salesforce.com --setdefaultusername
fi
echo "Authentication successful"

cp /Users/chuck/Projects/chivalry/sfdx-tools/package.xml ./manifest/package.xml

echo "Retrievimng metadata"
sfdx force:source:retrieve --manifest manifest/package.xml
echo "Metadata retrieved"

code .
