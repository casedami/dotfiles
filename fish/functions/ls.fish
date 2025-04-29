function ls
    if test (eza -a $argv | count) -lt 15
        eza -a --icons --group-directories-first -1 $argv
    else
        eza -a --icons --group-directories-first $argv
    end
end
