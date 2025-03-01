" ========================================================================
" OBSIDIAN VIM CONFIGURATION
" Version: 1.0
" Last Updated: 2024
" ========================================================================

" === Basic Settings ===
" Sync with system clipboard for seamless copy/paste
set clipboard=unnamed
" Unmap space to use it as a leader key
unmap <Space>

" === Navigation Improvements ===
" Map j and k to move by visual lines instead of file lines
" Useful when dealing with wrapped text in Obsidian
nmap j gj
nmap k gk

" Quick line navigation
" H moves to start of line (like ^)
" L moves to end of line (like $)
nmap H ^
nmap L $

" === Search and Sidebar Controls ===
" Open global search dialog
exmap searchFile obcommand global-search:open
nmap <Space>sf :searchFile

" Toggle the left sidebar visibility
exmap toggleLeftSideBar obcommand app:toggle-left-sidebar
nmap <C-n> :toggleLeftSideBar

" === File Explorer Controls ===
" Reveal current file in navigation
exmap revealFile obcommand file-explorer:reveal-active-file
nmap <Space>gf :revealFile

" === Miscellaneous ===
" Clear search highlighting
nmap <F9> :nohl<CR>

" ========================================================================
" USAGE NOTES:
" - Place this file in your vault's root directory as '.obsidian.vimrc'
" - Ensure Vim key bindings are enabled in Obsidian settings
" - Check for conflicts with existing Obsidian hotkeys
" 
" KEY BINDINGS SUMMARY:
" j/k        - Move up/down by visual lines
" H/L        - Move to start/end of line
" Space/;    - Enter command mode
" Ctrl+o     - Go back in history
" Ctrl+i     - Go forward in history
" Space+sf   - Open search
" Ctrl+n     - Toggle left sidebar
" Space+gf   - Reveal current file in explorer
" F9         - Clear search highlighting
" ========================================================================
