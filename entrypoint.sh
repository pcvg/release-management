#!/bin/bash
SUCCESS_MSG=${INPUT_SUCCESS_MSG}
CLICKUP_KEY=${INPUT_CLICKUP_KEY}
GH_EVENT_BEFORE=${INPUT_GH_EVENT_BEFORE}
GH_SHA=${INPUT_GH_SHA}

changes+=("$SUCCESS_MSG")
changes_dev+=("\n*Dev log:*")
changes_ct+=("\n*Tickets log:*")
IFS=$'\n' commits=`git log --oneline --pretty="%h^%s" $GH_EVENT_BEFORE..$GH_SHA`
for i in $commits; do
  commit_name=${i#*^}
  commit_hash=${i%^*}
  changes_dev+=("\n\\\`<https://github.com/pcvg/sz-vergleich/commit/$commit_hash|$commit_hash>\\\` - $commit_name")
  if [[ $commit_name == *"CV"* ]]; then
    task_id=`echo ${commit_name##*/} | grep -o 'CV[^ _]\+'`
    request=$(curl -H "Authorization: $CLICKUP_KEY" -H "Content-Type: application/json" \
    "https://api.clickup.com/api/v2/task/$task_id/?custom_task_ids=true&team_id=2467150&include_subtasks=" | tr '\r\n' ' ')
    changes_ct+=("\n<"$(printf '%s\n' "$request" | jq -r ".url")"|"$(printf '%s\n' "$request" | jq -r ".name")">")
  fi
done
if [ -z $task_id ]; then changes=("${changes[@]}" "\n${changes_dev[@]}"); else changes=("${changes[@]}" "${changes_ct[@]}" "\n${changes_dev[@]}"); fi
echo 'BODY_SUCCESS<<EOF' >> $GITHUB_ENV
echo ${changes[*]} >> $GITHUB_ENV
echo 'EOF' >> $GITHUB_ENV
