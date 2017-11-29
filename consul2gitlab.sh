#!/bin/env bash

CONSUL_HOST=http://example1.com:8500
GITLAB_HOST=http://example2.com
TOKEN=aaaaaaaaaaaaaaaaaaaa
PROJ=test%2Fconsul-history
FILE=history

KEYS=$(curl -s ${CONSUL_HOST}/v1/kv/?recurse | jq -r '.[].Key')

RESULT=$(
for i in ${KEYS}; do
        VALUE=$(curl -s ${CONSUL_HOST}/v1/kv/${i} | jq -r '.[].Value')
                if [ x"${VALUE}" == x"null" ]; then
                        VALUE=''
                else
                        VALUE=$(echo ${VALUE} | base64 -d)
                fi
        echo -n "${i}: ${VALUE}\n"
done
)

PAYLOAD=$(cat <<EOF
{
  "branch": "master",
  "commit_message": "consul2gitlab commit message",
  "actions": [
    {
      "action": "update",
      "file_path": "${FILE}",
      "content": "${RESULT}"
    }
  ]
}
EOF
)

DATA=$(curl -s --header "Private-Token: ${TOKEN}" ${GITLAB_HOST}/api/v4/projects/${PROJ}/repository/files/${FILE}/raw?ref=master)
diff -u <(echo -e "${DATA}\n") <(echo -e "${RESULT}") > /dev/null

if [ $? -eq 0 ]; then
        exit 0
else
        curl -s --request POST --header "Private-Token: ${TOKEN}" --header "Content-Type: application/json" --data "$PAYLOAD" ${GITLAB_HOST}/api/v4/projects/${PROJ}/repository/commits > /dev/null
fi
