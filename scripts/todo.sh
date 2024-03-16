#!/opt/homebrew/bin/bash

if [[ $# -eq 0 ]]; then
  nvim ~/self/notes/main/tasks/today.md
  exit 0
fi

if [[ "$1" == "--self" ]]; then
  nvim ~/self/notes/main/tasks/self.md
  exit 0
fi

split_tasks() {
  local input=$1
  local file=$2
  array=$(awk '{n = split($0, t, ", "); for (i = 0; ++i <= n;) print t[i]}' <<<"$input")
  for ((i = 0; i < ${#array[@]}; i++)); do
    echo "- [ ] ${array[$i]}" >>$2
  done
}

if [[ "$1" == "new" ]]; then
  read -p ">>> " tasks
  tasks=$(echo $tasks | xargs)
  if [[ "$2" == "--self" ]]; then
    split_tasks "$tasks" ~/self/notes/main/tasks/self.md
  else
    split_tasks "$tasks" ~/self/notes/main/tasks/today.md
  fi
elif [[ "$1" == "ls" ]]; then
  if [[ "$2" == "--self" ]]; then
    cat ~/self/notes/main/tasks/self.md | grep -- '- \[ \]' | sed 's/\[ \] //'
  else
    cat ~/self/notes/main/tasks/today.md | grep -E -- '- \[(x| )\]' | sed 's/- \[x\]//' | sed 's/\[ \] //' | sort
  fi
elif [[ "$1" == "clean" ]]; then
  if [[ "$2" == "--self" ]]; then
    sed -i -e '/- \[x\]/d' ~/self/notes/main/tasks/self.md
  else
    sed -i -e '/- \[x\]/d' ~/self/notes/main/tasks/today.md
  fi
else
  echo "unsupported or unknown args"
fi
