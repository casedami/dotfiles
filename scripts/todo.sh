if [[ $# -eq 0 ]]; then
  nvim ~/self/notes/main/tasks/self.md
  exit 0
fi
if [[ "$1" == "new" ]]; then
  read -p ">>> " task
  task=$(echo $task | xargs)
  echo "- [ ] $task" >>~/self/notes/main/tasks/self.md
elif [[ "$1" == "ls" ]]; then
  cat ~/self/notes/main/tasks/self.md | grep -- '- \[ \]' | sed 's/\[ \] //'
else
  echo "unsupported or unknown args"
fi
