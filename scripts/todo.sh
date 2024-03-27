#!/opt/homebrew/bin/bash

today_tasks_file="/Users/caseymiller/self/notes/main/tasks/today.md"
self_tasks_file="/Users/caseymiller/self/notes/main/tasks/self.md"

today=$(date +"%Y-%m-%d")
mod_date=$(stat -f "%Sm" -t "%Y-%m-%d" "$today_tasks_file")

if [ "$mod_date" != "$today" ]; then
  sed -i '' '/\[x\]/d' $today_tasks_file
  cat $today_tasks_file | grep -E '\[ \]' >>$self_tasks_file
  sed -i '' '/\[ \]/d' $today_tasks_file
  echo "todo: starting fresh..."
fi

if [[ $# -eq 0 ]]; then
  nvim $today_tasks_file
  exit 0
fi

if [[ "$1" == "-s" ]]; then
  nvim $self_tasks_file
  exit 0
fi

split_tasks() {
  local input=$1
  local file=$2
  awk '{n = split($0, t, ", "); for (i = 0; ++i <= n;) print "- [ ] " t[i]}' <<<"$input" >>$today_tasks_file
}

get_tasks() {
  local file=$1
  local scope=$2
  grep_output=$(grep -E '\[(x| )\]' $file)
  if [ -z "$grep_output" ]; then
    echo "todo: no more tasks to complete."
  else
    if [[ "$scope" == "today" ]]; then
      echo "here's your tasks for today:"
    else
      echo "here's your tasks:"
    fi
    cat $file | grep -E '\[(x| )\]' | sed 's/- \[x\]//' | sed 's/\[ \] //' | sort
  fi
}

if [[ "$1" == "new" ]]; then
  read -p ">>> " tasks
  tasks=$(echo $tasks | xargs)
  if [[ "$2" == "-s" ]]; then
    split_tasks "$tasks" $self_tasks_file
  else
    split_tasks "$tasks" $today_tasks_file
  fi
elif [[ "$1" == "ls" ]]; then
  if [[ "$2" == "-s" ]]; then
    get_tasks "$self_tasks_file" "self"
  else
    get_tasks "$today_tasks_file" "today"
  fi
elif [[ "$1" == "clean" ]]; then
  if [[ "$2" == "-s" ]]; then
    sed -i '' '/\[x\]/d' $self_tasks_file
  else
    sed -i '' '/\[x\]/d' $today_tasks_file
  fi
else
  echo "todo: unsupported or unknown args"
fi
