function pfwd
    ssh -fNT -L 127.0.0.1:8050:127.0.0.1:8050 trident@"$argv[1]"
end
