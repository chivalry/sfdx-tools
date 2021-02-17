function connectOrg {
   echo "Please Enter New Project Name"
   read projectName
   echo "Creating Project $projectName..."
   sfdx force:project:create -x -n $projectName
   cd $projectName
   echo "Is this for a Sandbox[s] or Production[p] org?"
   read orgType
   while [ "$orgType" != "s" ] && [ "$orgType" != "Sandbox" ] && [ "$orgType" != "p" ] && [ "$orgType" != "Production" ]
      do
      echo "I'm sorry. I didn't understand your response."
      echo "Is this for a Sandbox[s] or Production[p] org?"
      read orgType
   done
   echo "Please enter an Alias for this org:"
   read orgAlias
   
   if [ "$orgType" == "s" ] || [ "$orgType" == "Sandbox" ]
      then
      echo "Authenticating Sandbox org..."
      sfdx force:auth:web:login --setalias $orgAlias --instanceurl https://test.salesforce.com --setdefaultusername
   else
      echo "Authenticating Production org..."
      sfdx force:auth:web:login --setalias $orgAlias --instanceurl https://login.salesforce.com --setdefaultusername
   fi
   echo "Authentication Successful"
   # CLI notifies user that it's "Retrieving Source"
   sfdx force:mdapi:retrieve -r ./temp -u $orgAlias -k ./manifest/package.xml
   echo "Successfully retrieved metadata!"
   echo "Unzipping data"
   unzip ./temp/unpackaged.zip -d ./temp/
   echo "Unzip successful!"
   echo "Converting metadata to source format...."
   sfdx force:mdapi:convert --rootdir temp
   echo "Conversion complete!"   echo "Delete temp folder? [y]/[n]"
   read deleteTemp
   while [ $deleteTemp != "y" ] && [ $deleteTemp != "n" ]
      do
      echo "I'm sorry. I didn't understand your response."
      echo "Delete temp folder? [y]/[n]"
      read deleteTemp
   done
if [ $deleteTemp == "y" ]
   then
   echo "Deleting temp folder..."
   rm -rf ./temp
   echo "Success!"
fi
echo "Org Connection Complete!"
echo "Opening Project in new Window..."
code .
return
}
