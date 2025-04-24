function ls
    set -l print_vert
    if test (count *) -lt 15
        set print_vert -1
    end

    eza -a --icons --group-directories-first $print_vert
end
