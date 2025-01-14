function monthly
    set -l month (date +%B)
    set -l fname (string join '' $NOTES_DIR $month .md)
    nvim $fname
end
