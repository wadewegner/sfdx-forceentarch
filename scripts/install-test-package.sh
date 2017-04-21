#! /bin/bash

# Create an org
created="$(sfdx force:org:create -f config/workspace-scratch-def.json --json)"
username="$(echo ${created} | jq -r .username)"

# Get the Package ID
packageVersion="$(sfdx force:package1:version:list -u EntArchPackaging --json)"
packageVersionId="$(echo ${packageVersion} | jq -c '.results' | jq -c '.[]' | jq -r .MetadataPackageVersionId)"

# remove last three characters
packageVersionId=${packageVersionId%???}

# echo ${username}
# echo ${packageVersionId}

# install package into newly created scratch org
sfdx force:packageversion:install -i ${packageVersionId} -u ${username}