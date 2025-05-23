function glc
    git log -1 | awk 'NR==1 {print $2}'
end
