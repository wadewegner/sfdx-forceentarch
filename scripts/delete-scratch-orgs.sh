#! /bin/bash

# Get default dev hub
configs="$(sfdx force:config:list --json)"
filteredConfig="$(echo ${configs} | jq -r '.results' | jq -r '.[] | select( .key | contains("defaultdevhubusername"))' | jq -r .value)"

# Get orgs
orgs="$(sfdx force:org:list --json)"
orgResults="$(echo ${orgs} | jq -r '.results')"

# check if the default dev hub is an alias or org
if [[ ! $filteredConfig == *"@"* ]]; then
  # it's an alias

  # Filter based on the alias
  hubOrg="$(echo ${orgResults} | jq -r '.[] | select( .alias=="'$filteredConfig'")')"
  # Get the username
  hubOrgUsername="$(echo ${hubOrg} | jq -r .username)"
  # Update the filteredConfig to the username
  filteredConfig=$hubOrgUsername 
fi

# Filter to scratch orgs
filteredOrgs="$(echo ${orgResults} | jq -r '.[] | select( .username | contains("scratch"))')"
# Filter to scratch orgs belonging to the default dev hub
filteredOrgsByHub="$(echo ${filteredOrgs} | jq -r 'select( .devHubUsername=="'$filteredConfig'")')"
# Get usernames
usernames="$(echo ${filteredOrgsByHub} | jq -r .username)"

for username in ${usernames[@]}
do
    # Delete scratch orgs
    sfdx force:org:delete -u $username -p
done