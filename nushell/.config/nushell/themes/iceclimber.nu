# name: ICECLIMBER colors for Nushell
# url: https://github.com/nushell/nushell
# upstream: https://github.com/cdmill/neomodern.nvim/raw/main/extras/nushell/iceclimber.nu
# author: Casey Miller

# 1. copy to ~/.config/nushell/themes/iceclimber.nu
# 2. load in your config.nu:
#       source ~/.config/nushell/themes/iceclimber.nu

let theme = {
    alt: "#abbceb",
    alt_bg: "#111113",
    bg: "#171719",
    comment: "#555568",
    constant: "#86a3f0",
    fg: "#bbbac1",
    func: "#cc93b8",
    keyword: "#8a88db",
    line: "#1d1d22",
    number: "#cfa18c",
    operator: "#9b99a3",
    property: "#629da3",
    string: "#6b6b99",
    type: "#a8a6de",
    visual: "#2a2a31",
    diag_red: "#e67e80",
    diag_blue: "#778fd1",
    diag_yellow: "#ad9368",
    diag_green: "#658c6d",
}

$env.config.color_config = {
    separator: $theme.comment
    leading_trailing_space_bg: { attr: n }
    header: { fg: $theme.func attr: b}
    empty: $theme.property
    bool: $theme.number
    int: $theme.number
    float: $theme.number
    filesize: $theme.type
    duration: $theme.type
    date: $theme.property
    range: $theme.string
    string: $theme.string
    nothing: $theme.comment
    binary: $theme.constant
    cellpath: $theme.property
    row_index: { fg: $theme.func attr: b }
    record: $theme.property
    list: $theme.property
    block: $theme.property
    hints: $theme.comment
    search_result: { fg: $theme.property bg: $theme.visual }

    shape_and: { fg: $theme.keyword }
    shape_binary: $theme.operator
    shape_block: $theme.property
    shape_bool: $theme.number
    shape_closure: $theme.func
    shape_custom: $theme.func
    shape_datetime: { fg: $theme.string attr: b }
    shape_directory: $theme.string
    shape_external: $theme.func
    shape_externalarg: $theme.alt
    shape_filepath: $theme.type
    shape_flag: { fg: $theme.alt attr: b }
    shape_float: $theme.number
    shape_garbage: { fg: $theme.fg bg: "#e67e80" attr: b }
    shape_globpattern: { fg: $theme.type attr: b }
    shape_int: $theme.number
    shape_internalcall: $theme.func
    shape_keyword: $theme.keyword
    shape_list: $theme.string
    shape_literal: $theme.string
    shape_match_pattern: $theme.type
    shape_matching_brackets: { fg: $theme.fg attr: b }
    shape_nothing: $theme.comment
    shape_operator: $theme.operator
    shape_or: $theme.keyword
    shape_pipe: $theme.operator
    shape_range: $theme.string
    shape_record: $theme.string
    shape_redirection: $theme.operator
    shape_signature: $theme.func
    shape_string: $theme.string
    shape_string_interpolation: $theme.alt
    shape_table: { fg: $theme.property attr: b }
    show_variable: $theme.fg
    shape_vardec1: { fg: $theme.fg attr: u }
}

$env.config.highlight_resolved_externals = true
$env.config.explore = {
    status_bar_background: { fg: $theme.fg, bg: $theme.line },
    command_bar_text: { fg: $theme.fg },
    highlight: { fg: $theme.type, bg: $theme.visual },
    status: {
        error: $theme.diag_red,
        warn: $theme.diag_yellow,
        info: $theme.diag_blue,
    },
    selected_cell: { bg: $theme.line fg: $theme.type },

}
$env.config.completions = {
    case_sensitive: false
    quick: true
    partial: true
    algorithm: "prefix"
    external: {
        enable: true
        max_results: 100
        completer: null
    }
    use_ls_colors: true
}

$env.config.menus = [
    {
        name: completion_menu
        only_buffer_difference: false
        marker: "= "
        type: {
            layout: columnar
            columns: 4
            col_width: 20
            col_padding: 2
        }
        style: {
            text: $theme.comment
            selected_text: {
                fg: $theme.type
                bg: $theme.line
                attr: "b"
            }
            description_text: $theme.comment
        }
    }
    {
        name: history_menu
        only_buffer_difference: true
        marker: "| "
        type: {
            layout: list
            page_size: 10
        }
        style: {
            text: $theme.fg
            selected_text: {
                fg: $theme.bg
                bg: $theme.property
                attr: "b"
            }
            description_text: $theme.comment
        }
    }
    {
        name: help_menu
        only_buffer_difference: true
        marker: "? "
        type: {
            layout: description
            columns: 4
            col_width: 20
            col_padding: 2
            selection_rows: 4
            description_rows: 10
        }
        style: {
            text: $theme.fg
            selected_text: {
                fg: $theme.bg
                bg: $theme.diag_blue
                attr: "b"
            }
            description_text: $theme.string
        }
    }
]

$env.LS_COLORS = "di=32:ln=35:fi=37:ex=37:*.tar=33:*.tgz=33:*.arc=33:*.arj=33:*.taz=33:*.lha=33:*.lz4=33:*.lzh=33:*.lzma=33:*.tlz=33:*.txz=33:*.tzo=33:*.t7z=33:*.zip=33:*.z=33:*.dz=33:*.gz=33:*.lrz=33:*.lz=33:*.lzo=33:*.xz=33:*.zst=33:*.tzst=33:*.bz2=33:*.bz=33:*.tbz=33:*.tbz2=33:*.tz=33:*.deb=33:*.rpm=33:*.jar=33:*.war=33:*.ear=33:*.sar=33:*.rar=33:*.alz=33:*.ace=33:*.zoo=33:*.cpio=33:*.7z=33:*.rz=33:*.cab=33:*.wim=33:*.swm=33:*.dwm=33:*.esd=33:*.jpg=36:*.jpeg=36:*.mjpg=36:*.mjpeg=36:*.gif=36:*.bmp=36:*.pbm=36:*.pgm=36:*.ppm=36:*.tga=36:*.xbm=36:*.xpm=36:*.tif=36:*.tiff=36:*.png=36:*.svg=36:*.svgz=36:*.mng=36:*.pcx=36:*.webp=36:*.ico=36:*.pdf=36:*.ps=36:*.eps=36"
