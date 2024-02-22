#!/bin/bash

# Usage: ./run_sonar_scanner.sh -Dsonar.projectBaseDir=<path> -Dsonar.host.url=<url> -Dsonar.login=<login> -Dsonar.password=<password> -Dsonar.projectKey=<key> -Dsonar.projectName="<name>"

while [[ $# -gt 0 ]]; do
  case "$1" in
    -Dsonar.projectBaseDir=*)
      projectBaseDir="${1#*=}"
      ;;
    -Dsonar.host.url=*)
      hostUrl="${1#*=}"
      ;;
    -Dsonar.login=*)
      login="${1#*=}"
      ;;
    -Dsonar.password=*)
      password="${1#*=}"
      ;;
    -Dsonar.projectKey=*)
      projectKey="${1#*=}"
      ;;
    -Dsonar.projectName=*)
      projectName="${1#*=}"
      ;;
    *)
      echo "Invalid option: $1"
      exit 1
      ;;
  esac
  shift
done

# Validate required parameters
if [[ -z $projectBaseDir || -z $hostUrl || -z $login || -z $password || -z $projectKey || -z $projectName ]]; then
  echo "Missing required parameters. Please provide all required options."
  exit 1
fi

# Run sonar-scanner command
./sonar-scanner/bin/sonar-scanner -Dsonar.projectBaseDir="$projectBaseDir" -Dsonar.host.url="$hostUrl" -Dsonar.login="$login" -Dsonar.password="$password" -Dsonar.projectKey="$projectKey" -Dsonar.projectName="$projectName"

echo "Sleeping for 15 seconds..."
sleep 15
echo "Awake after 15 seconds!"

 curl -u $login:$password -X GET "$hostUrl/api/issues/search?componentKeys=$projectKey&ps=100&s=FILE_LINE&additionalFields=_all&statuses=OPEN,REOPENED,CLOSED"