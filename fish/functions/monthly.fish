function monthly
    set -l month (date +%B | string shorten --char='' --max 3)
    set -l year (date +%y)
    set -l fname (string join '' $NOTES_DIR $month $year .md)
    nvim $fname
end
