return {
  "goolord/alpha-nvim",
  opts = function(_, opts)
    local logo = [[ 
        ██╗   ██╗██╗███╗   ███╗         
        ██║   ██║██║████╗ ████║         
        ██║   ██║██║██╔████╔██║         
        ╚██╗ ██╔╝██║██║╚██╔╝██║         
██╗██╗██╗╚████╔╝ ██║██║ ╚═╝ ██║██╗██╗██╗
╚═╝╚═╝╚═╝ ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝╚═╝
                                        

              [ cdmill ]
    ]]
    opts.section.header.val = vim.split(logo, "\n", { trimempty = true })
  end,
}
