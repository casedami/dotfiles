# name: GYOKURO colors for Nushell
# url: https://github.com/nushell/nushell
# upstream: https://github.com/cdmill/neomodern.nvim/raw/main/extras/nushell/gyokuro.nu
# author: Casey Miller

# 1. copy to ~/.config/nushell/themes/gyokuro.nu
# 2. load in your config.nu:
#       source ~/.config/nushell/themes/gyokuro.nu

let theme = {
    alt: "#a69e6f",
    alt_bg: "#161617",
    bg: "#1b1c1d",
    comment: "#767777",
    constant: "#868db5",
    fg: "#bbbac1",
    func: "#8bab85",
    keyword: "#72966c",
    line: "#222324",
    number: "#d6a9b3",
    operator: "#b08c7d",
    property: "#748fa6",
    string: "#a2ad7b",
    type: "#bbc7b1",
    visual: "#323334",
    diag_red: "#9e5560",
    diag_blue: "#748fa6",
    diag_yellow: "#9c9167",
    diag_green: "#8bab85",
}

$env.config.color_config = {
    separator: $theme.operator
    leading_trailing_space_bg: { attr: "n" }
    header: { fg: $theme.func }
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
    cell-path: $theme.property
    row_index: { fg: $theme.comment }
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
    shape_custom: { fg: $theme.func attr: "b" }
    shape_datetime: { fg: $theme.string attr: "b" }
    shape_directory: $theme.string
    shape_external: $theme.func
    shape_externalarg: $theme.alt
    shape_filepath: $theme.type
    shape_flag: { fg: $theme.alt attr: "b" }
    shape_float: $theme.number
    shape_garbage: { fg: $theme.diag_red attr: "ib" }
    shape_glob: { fg: $theme.type attr: "b" }
    shape_int: $theme.number
    shape_internalarg: $theme.alt
    shape_internalcall: { fg: $theme.func attr: "b" }
    shape_keyword: $theme.keyword
    shape_list: $theme.string
    shape_literal: $theme.string
    shape_match_pattern: $theme.type
    shape_matching_brackets: { fg: $theme.fg attr: "b" }
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
    shape_table: { fg: $theme.property attr: "b" }
    shape_variable: $theme.fg
    shape_vardecl: { fg: $theme.fg attr: "u" }
}

$env.config.show_banner = false
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
